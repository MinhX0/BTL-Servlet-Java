<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>E Shop - Login & Register</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>

<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Breadcrumb Start -->
<div class="breadcrumb-wrap">
    <div class="container">
        <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="#">User</a></li>
            <li class="breadcrumb-item active">Login</li>
        </ul>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- Login Start -->
<div class="login">
    <div class="container">
        <div class="section-header">
            <h3>User Registration & Login</h3>
            <p>
                Sign in to your account or create a new one.
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
                                <label>E-mail / Username</label>
                                <input class="form-control" type="text" name="username" placeholder="Enter username or email" required autofocus>
                            </div>
                            <div class="col-md-12 mt-3">
                                <label>Password</label>
                                <input class="form-control" type="password" name="password" placeholder="Enter password" required>
                            </div>
                            <div class="col-md-12 mt-3">
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" class="custom-control-input" id="rememberme" name="remember">
                                    <label class="custom-control-label" for="rememberme">Keep me signed in</label>
                                </div>
                            </div>
                            <div class="col-md-12 mt-3">
                                <button class="btn" type="submit">Login</button>
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
                                <label>Full Name</label>
                                <input class="form-control" type="text" name="name" placeholder="Full Name" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required>
                            </div>
                            <div class="col-md-12 mt-3">
                                <label>Username</label>
                                <input class="form-control" type="text" name="username" placeholder="Username" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>
                            </div>
                            <div class="col-md-12 mt-3">
                                <label>E-mail</label>
                                <input class="form-control" type="email" name="email" placeholder="E-mail" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Password</label>
                                <input class="form-control" type="password" name="password" placeholder="Password" required>
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Confirm Password</label>
                                <input class="form-control" type="password" name="confirm-password" placeholder="Confirm Password" required>
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Mobile No (Optional)</label>
                                <input class="form-control" type="text" name="phone" placeholder="Mobile No" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                            </div>
                            <div class="col-md-6 mt-3">
                                <label>Address (Optional)</label>
                                <input class="form-control" type="text" name="address" placeholder="Address" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                            </div>
                            <div class="col-md-12 mt-3">
                                <button class="btn" type="submit">Register</button>
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
</body>
</html>
