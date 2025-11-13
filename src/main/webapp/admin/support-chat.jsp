<%@ page contentType="text/html; charset=UTF-8" %>
<%
    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    if (!user.isSeller() && !user.isAdmin()) { response.sendRedirect(request.getContextPath()+"/index"); return; }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hỗ trợ khách hàng - Bảng điều khiển</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
    <style>
        .support-wrapper{max-width:1200px;margin:1.5rem auto;display:grid;grid-template-columns:280px 1fr;gap:1rem}
        .panel{background:#fff;border:1px solid #e3e3e3;border-radius:8px;display:flex;flex-direction:column;min-height:540px}
        .panel-header{padding:12px 16px;border-bottom:1px solid #eee;font-weight:600;display:flex;justify-content:space-between;align-items:center}
        .panel-body{flex:1;overflow:auto;padding:12px 16px}
        .customer-list .item{padding:8px 10px;border-radius:5px;cursor:pointer;margin-bottom:4px;background:#f8f9fa;border:1px solid #eee;display:flex;justify-content:space-between;align-items:center}
        .customer-list .item.active{background:#0d6efd;color:#fff;border-color:#0d6efd}
        .customer-list .empty{color:#888;font-size:.9rem;margin-top:.5rem}
        .chat-messages{display:flex;flex-direction:column;gap:4px;height:55vh;overflow:auto}
        .msg{display:flex}
        .msg.me{justify-content:flex-end}
        .bubble{padding:.5rem .75rem;border-radius:14px;max-width:65%}
        .msg.me .bubble{background:#0d6efd;color:#fff;border-bottom-right-radius:4px}
        .msg.other .bubble{background:#e9ecef;color:#000;border-bottom-left-radius:4px}
        .msg.system{justify-content:center}
        .msg.system .bubble{background:transparent;color:#6c757d}
        .chat-input{display:flex;gap:.5rem;padding:12px;border-top:1px solid #eee}
        .chat-input input{flex:1}
        .seller-tag{display:inline-block;font-size:.65rem;padding:0 .35rem;margin-left:.35rem;background:#ffc107;color:#000;border-radius:3px}
        /* Center chat area inside the right panel on wide screens */
        .chat-centered{max-width:760px;margin:0 auto;width:100%}
        @media (max-width:992px){.support-wrapper{grid-template-columns:1fr}}
    </style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="support-wrapper">
    <div class="panel">
      <div class="panel-header">Khách đang cần hỗ trợ <button id="refreshList" class="btn btn-sm btn-outline-secondary">Làm mới</button></div>
      <div class="panel-body customer-list" id="customerList"><div class="empty">Chưa có khách nào.</div></div>
    </div>
    <div class="panel">
      <div class="panel-header">Kênh chat <span id="currentTarget" class="text-muted" style="font-weight:normal"></span></div>
      <div class="panel-body">
        <div class="chat-messages chat-centered" id="chatMessages"></div>
      </div>
      <div class="chat-input chat-centered">
        <input id="chatText" type="text" class="form-control" placeholder="Nhập tin nhắn..." />
        <button id="chatSend" class="btn btn-primary" disabled>Gửi</button>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
<script>
(function(){
  const ctx = '<%=request.getContextPath()%>';
  const $list = document.getElementById('customerList');
  const $messages = document.getElementById('chatMessages');
  const $text = document.getElementById('chatText');
  const $send = document.getElementById('chatSend');
  const $targetLabel = document.getElementById('currentTarget');
  let currentTarget='';
  let lastTs = 0;
  function escapeHtml(str){return str.replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':'&#39;'}[c]));}
  function addMsg(cls, html){const d=document.createElement('div');d.className='msg '+cls;const b=document.createElement('div');b.className='bubble';b.innerHTML=html;d.appendChild(b);$messages.appendChild(d);$messages.scrollTop=999999;}
  function renderCustomers(arr){$list.innerHTML=''; if(!arr||arr.length===0){$list.innerHTML='<div class="empty">Chưa có khách nào.</div>'; return;} arr.forEach(u=>{const div=document.createElement('div');div.className='item'+(u===currentTarget?' active':'');div.textContent=u;div.onclick=function(){currentTarget=u;updateActive();$targetLabel.textContent='→ '+u;$send.disabled=false;lastTs=0;$messages.innerHTML='';};$list.appendChild(div);});}
  function updateActive(){Array.from($list.querySelectorAll('.item')).forEach(el=>el.classList.toggle('active', el.textContent===currentTarget));}
  // initial tip
  addMsg('system','<em>Chọn một khách ở bên trái để bắt đầu trò chuyện.</em>');
  function poll(){const url = ctx+"/chat/poll?after="+lastTs+(currentTarget?"&customer="+encodeURIComponent(currentTarget):""); fetch(url,{cache:'no-store'}).then(r=>{if(!r.ok) throw new Error('poll '+r.status); return r.json();}).then(data=>{renderCustomers(Array.from(data.activeCustomers||[])); (data.messages||[]).forEach(m=>{lastTs=Math.max(lastTs,m.ts); const mine=m.fromSeller; const who=m.fromSeller?('Tôi<span class=\"seller-tag\">SELLER</span>'):escapeHtml(m.from); addMsg(mine?'me':'other','<strong>'+who+':</strong> '+escapeHtml(m.content));}); setTimeout(poll,1500);}).catch(()=>setTimeout(poll,3000));}
  poll();
  document.getElementById('refreshList').onclick=function(){poll();};
  $send.onclick=function(){if(!currentTarget) return; const t=($text.value||'').trim(); if(!t) return; const body=new URLSearchParams(); body.append('content', t); body.append('to', currentTarget); fetch(ctx+'/chat/send',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},body:body.toString()}).then(r=>{if(r.ok){$text.value='';} else { addMsg('system','<em>Gửi thất bại. Vui lòng thử lại.</em>'); }}).catch(()=>addMsg('system','<em>Mất kết nối, đang thử lại...</em>'));};
  $text.addEventListener('keydown',e=>{if(e.key==='Enter'){ $send.click(); }});
})();
</script>
</body>
</html>
