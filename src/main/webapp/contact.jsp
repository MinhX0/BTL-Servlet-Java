<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Require logged in customer --%>
<%
    com.example.btl.model.User u = (com.example.btl.model.User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    if (!u.isCustomer()) {
        response.sendRedirect(request.getContextPath() + "/admin/support-chat");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Liên hệ - Chat hỗ trợ</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
    <style>
        .chat-wrapper{max-width:760px;margin:2rem auto;display:flex;gap:1rem}
        .chat-panel{flex:1;background:#fff;border:1px solid #eee;border-radius:8px;display:flex;flex-direction:column;}
        .chat-header{padding:12px 16px;border-bottom:1px solid #eee;font-weight:600}
        .chat-messages{height:60vh;padding:12px 16px;overflow:auto;background:#fafafa}
        .chat-input{display:flex;gap:.5rem;padding:12px;border-top:1px solid #eee}
        .chat-input input{flex:1}
        .msg{display:flex;margin:.25rem 0}
        .bubble{padding:.5rem .75rem;border-radius:14px;max-width:70%}
        .msg.me{justify-content:flex-end}
        .msg.me .bubble{background:#0d6efd;color:#fff;border-bottom-right-radius:4px}
        .msg.other .bubble{background:#e9ecef;color:#000;border-bottom-left-radius:4px}
        .msg.system{justify-content:center}
        .msg.system .bubble{background:transparent;color:#6c757d}
        .seller-tag{display:inline-block;font-size:.75rem;padding:0 .35rem;margin-left:.35rem;background:#ffc107;color:#000;border-radius:3px}
    </style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="container">
    <div class="py-4">
        <h1 class="mb-1">Hỗ trợ trực tuyến</h1>
        <p class="text-muted mb-3">Bạn đang trò chuyện với nhân viên hỗ trợ. Vui lòng gửi câu hỏi của bạn.</p>
    </div>
    <div class="chat-wrapper">
        <div class="chat-panel">
            <div class="chat-header">Chat hỗ trợ</div>
            <div class="chat-messages" id="chatMessages"></div>
            <div class="chat-input">
                <label for="chatText" class="sr-only">Tin nhắn</label>
                <input id="chatText" class="form-control" type="text" placeholder="Nhập tin nhắn..." />
                <button id="chatSend" class="btn btn-primary">Gửi</button>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
<script>
(function(){
  const ctx = '<%=request.getContextPath()%>';
  const $msgs = document.getElementById('chatMessages');
  const $text = document.getElementById('chatText');
  const $send = document.getElementById('chatSend');
  let lastTs = 0;
  function escapeHtml(str){return str.replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}
  function addMsg(cls, html){const d=document.createElement('div');d.className='msg '+cls;const b=document.createElement('div');b.className='bubble';b.innerHTML=html;d.appendChild(b);$msgs.appendChild(d);$msgs.scrollTop=999999;}
  // Initial system greet
  addMsg('system','<em>Bạn đã kết nối tới kênh hỗ trợ. Vui lòng chờ nhân viên phản hồi...</em>');
  function poll(){fetch(ctx+"/chat/poll?after="+lastTs,{cache:'no-store'}).then(r=>{if(!r.ok) throw new Error('poll '+r.status); return r.json();}).then(data=>{(data.messages||[]).forEach(m=>{lastTs=Math.max(lastTs,m.ts);const mine=!m.fromSeller;const who=m.fromSeller?('Hỗ trợ<span class=\"seller-tag\">SELLER</span>'):escapeHtml(m.from);addMsg(mine?'me':'other', '<strong>'+who+':</strong> '+escapeHtml(m.content));}); setTimeout(poll,1200);}).catch(()=>setTimeout(poll,3000));}
  poll();
  $send.onclick=function(){const t=($text.value||'').trim(); if(!t) return; const body=new URLSearchParams(); body.append('content', t); fetch(ctx+'/chat/send',{method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'}, body:body.toString()}).then(r=>{if(r.ok){$text.value='';} else { addMsg('system','<em>Gửi thất bại. Vui lòng thử lại.</em>'); }}).catch(()=>addMsg('system','<em>Mất kết nối, đang thử lại...</em>'))};
  $text.addEventListener('keydown',e=>{if(e.key==='Enter'){ $send.click(); }});
})();
</script>
</body>
</html>
