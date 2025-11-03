<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
    if (!user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Tạo người dùng</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <h3>Tạo người dùng</h3>
    <div class="card mt-3">
      <div class="card-body">
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/admin/add-user">
            <div class="row g-3">
              <div class="col-md-6">
                <label for="name" class="form-label">Họ tên</label>
                <input type="text" name="name" id="name" class="form-control" required />
              </div>
              <div class="col-md-6">
                <label for="username" class="form-label">Tên đăng nhập</label>
                <input type="text" name="username" id="username" class="form-control" required />
              </div>
              <div class="col-md-6">
                <label for="email" class="form-label">Email</label>
                <input type="email" name="email" id="email" class="form-control" required />
              </div>
              <div class="col-md-6">
                <label for="password" class="form-label">Mật khẩu</label>
                <input type="password" name="password" id="password" class="form-control" required />
              </div>
              <div class="col-md-6">
                <label for="phone" class="form-label">Số điện thoại</label>
                <input type="text" name="phone" id="phone" class="form-control" />
              </div>
              <div class="col-md-6">
                <label for="address" class="form-label">Địa chỉ</label>
                <input type="text" name="address" id="address" class="form-control" />
              </div>
              <div class="col-md-6">
                <label for="role" class="form-label">Vai trò</label>
                <select name="role" id="role" class="form-select" required>
                    <option value="CUSTOMER">Khách hàng</option>
                    <option value="SELLER">Người bán</option>
                    <option value="ADMIN">Quản trị</option>
                </select>
              </div>
            </div>
            <div class="mt-3 d-flex gap-2">
              <button class="btn btn-success" type="submit">Tạo</button>
              <a class="btn btn-secondary" href="<%= request.getContextPath() %>/admin/dashboard">Quay lại</a>
            </div>
        </form>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>
