<%@ page contentType="text/html; charset=UTF-8" %>
<%
    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    if (!user.isSeller() && !user.isAdmin()) { response.sendRedirect(request.getContextPath()+"/index"); return; }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang hỗ trợ - Giới hạn chức năng</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <div class="alert alert-info mt-3">Bạn đang đăng nhập với vai trò <strong>SELLER</strong>. Chỉ được phép truy cập mục Chat hỗ trợ và Đơn hàng (xem).</div>
    <div class="row g-3 mt-1">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-header">Tác vụ nhanh</div>
          <div class="card-body d-grid gap-2">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/support-chat">Mở chat hỗ trợ</a>
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/orders">Xem đơn hàng</a>
          </div>
        </div>
      </div>
      <div class="col-lg-6">
        <div class="card">
          <div class="card-header">Giới hạn</div>
          <div class="card-body">
            <ul class="mb-0">
              <li>Không thể tạo/sửa/xóa sản phẩm</li>
              <li>Không thể tạo/sửa/xóa danh mục</li>
              <li>Không thể quản lý người dùng</li>
              <li>Chỉ xem thông tin đơn hàng</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>

