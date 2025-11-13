<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng nhập / Đăng ký</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>

<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Breadcrumb Start -->
<div class="breadcrumb-wrap">
    <div class="container">
        <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.jsp">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="#">Người dùng</a></li>
            <li class="breadcrumb-item active">Đăng nhập</li>
        </ul>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- Login Start -->
<div class="login">
    <div class="container">
        <div class="section-header">
            <h3>Đăng nhập / Đăng ký</h3>
            <p>
                Đăng nhập vào tài khoản hoặc tạo tài khoản mới.
            </p>
        </div>
        <div class="row">
            <!-- Login Form -->
            <div class="col-md-6" id="login">
                <div class="login-form">
                    <!-- Show login error if present -->
                    <%
                        Object loginErrObj = request.getAttribute("error");
                        String loginError = loginErrObj != null ? String.valueOf(loginErrObj) : null;
                        if (loginError != null && !loginError.isEmpty()) {
                    %>
                    <div class="alert alert-danger" role="alert"><%= loginError %></div>
                    <% } %>
                    <form method="post" action="<%= request.getContextPath() %>/login">
                        <div class="row">
                            <div class="col-md-12">
                                <label>Tên đăng nhập hoặc Email</label>
                                <input class="form-control" type="text" name="username" placeholder="Nhập tên đăng nhập hoặc email" required autofocus>
                            </div>
                            <div class="col-md-12 mt-3">
                                <label>Mật khẩu</label>
                                <input class="form-control" type="password" name="password" placeholder="Nhập mật khẩu" required>
                            </div>
                            <div class="col-md-12 mt-3">
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" class="custom-control-input" id="rememberme" name="remember">
                                    <label class="custom-control-label" for="rememberme">Ghi nhớ đăng nhập</label>
                                </div>
                            </div>
                            <div class="col-md-12 mt-3">
                                <button class="btn" type="submit">Đăng nhập</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Register Form -->
            <div class="col-md-6" id="register">
                <div class="register-form">
                    <!-- Show register error/success if present -->
                    <%
                        Object regErrObj = request.getAttribute("registerError");
                        String registerError = regErrObj != null ? String.valueOf(regErrObj) : null;
                        Object regSuccessObj = request.getAttribute("registerSuccess");
                        String registerSuccess = regSuccessObj != null ? String.valueOf(regSuccessObj) : null;
                        if (registerError != null && !registerError.isEmpty()) {
                    %>
                    <div class="alert alert-danger" role="alert"><%= registerError %></div>
                    <% } %>
                    <% if (registerSuccess != null && !registerSuccess.isEmpty()) { %>
                    <div class="alert alert-success" role="alert"><%= registerSuccess %></div>
                    <% } %>

                    <form method="post" action="<%= request.getContextPath() %>/register">
                        <div class="row">
                            <div class="col-md-12">
                                <label>Họ tên</label>
                                <input class="form-control" type="text" name="name" placeholder="Họ tên" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required>
                            </div>
                            <div class="col-md-12 mt-3">
                                <label>Tên đăng nhập</label>
                                <input class="form-control" type="text" name="username" placeholder="Tên đăng nhập" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>
                            </div>
                            <div class="col-md-12 mt-3">
                                <label>E-mail</label>
                                <input class="form-control" type="email" name="email" placeholder="E-mail" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Mật khẩu</label>
                                <input class="form-control" type="password" name="password" id="regPassword" placeholder="Mật khẩu" minlength="7" required>
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Xác nhận mật khẩu</label>
                                <input class="form-control" type="password" name="confirm-password" id="regConfirmPassword" placeholder="Xác nhận mật khẩu" minlength="7" required>
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Số điện thoại (Không bắt buộc)</label>
                                <input class="form-control" type="text" name="phone" placeholder="Số điện thoại" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Địa chỉ (Không bắt buộc)</label>
                                <input class="form-control" type="text" name="address" placeholder="Địa chỉ" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                            </div>
                            <div class="col-md-12 mt-3">
                                <button class="btn" type="submit">Đăng ký</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Login End -->

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
<script>
  (function(){
    function setupRegisterValidation(){
      var pwd = document.getElementById('regPassword');
      var cpw = document.getElementById('regConfirmPassword');
      if(!pwd || !cpw) return;
      function validate(){
        // minlength handled by HTML, here ensure identical
        if(cpw.value && pwd.value !== cpw.value){
          cpw.setCustomValidity('Mật khẩu xác nhận không khớp.');
        } else {
          cpw.setCustomValidity('');
        }
      }
      pwd.addEventListener('input', validate);
      cpw.addEventListener('input', validate);
    }
    document.addEventListener('DOMContentLoaded', setupRegisterValidation);
  })();
</script>
</body>
</html>
