<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Bảng điều khiển</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <div class="row g-3">
      <div class="col-12">
        <div class="alert <%= user.isAdmin()?"alert-warning":"alert-info" %>">
          <%= user.isAdmin() ? "Bạn có toàn quyền quản trị hệ thống. Hãy thao tác cẩn trọng." : "Bạn đang ở chế độ SELLER: chỉ có thể xem đơn hàng và hỗ trợ chat." %>
        </div>
      </div>
      <% if (user.isAdmin()) { %>
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <div class="display-6">${kpiUsers}</div>
            <div class="text-muted">Người dùng</div>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <div class="display-6">${kpiProducts}</div>
            <div class="text-muted">Sản phẩm</div>
          </div>
        </div>
      </div>
      <% } %>
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <div class="display-6">${kpiOrders}</div>
            <div class="text-muted">Đơn hàng</div>
          </div>
        </div>
      </div>
      <% if (user.isAdmin()) { %>
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <div class="display-6"><span class="kpi-revenue" data-val="${kpiRevenue}"></span></div>
            <div class="text-muted">Doanh thu</div>
          </div>
        </div>
      </div>
      <% } %>
    </div>

    <div class="row g-3 mt-1">
      <% if (user.isAdmin()) { %>
      <div class="col-lg-6">
        <div class="card">
          <div class="card-header">Quản lý nội dung</div>
          <div class="card-body d-grid gap-2">
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a>
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/categories">Danh mục</a>
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a>
          </div>
        </div>
      </div>
      <div class="col-lg-6">
        <div class="card">
          <div class="card-header">Người dùng</div>
          <div class="card-body d-grid gap-2">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/add-user">Tạo người dùng</a>
          </div>
        </div>
      </div>
      <% } else { %>
      <div class="col-lg-6">
        <div class="card">
          <div class="card-header">Tác vụ cho Seller</div>
          <div class="card-body d-grid gap-2">
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/orders">Xem đơn hàng</a>
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/support-chat">Hỗ trợ Chat</a>
          </div>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
<script>
  (function(){
    const el = document.querySelector('.kpi-revenue');
    if(!el) return;
    const val = el.getAttribute('data-val');
    try { const num = Number(val); if (!isNaN(num)) { el.textContent = new Intl.NumberFormat('vi-VN').format(num) + ' đ'; } else { el.textContent = val; } }
    catch(e){ el.textContent = val; }
  })();
</script>
</body>
</html>
