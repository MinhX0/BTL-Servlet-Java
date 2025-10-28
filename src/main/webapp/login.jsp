<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>E Shop - Login & Register</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Bootstrap Ecommerce Template" name="keywords">
    <meta content="Bootstrap Ecommerce Template Free Download" name="description">
    <base href="${pageContext.request.contextPath}/" />

    <!-- Favicon -->
    <link href="bootstrap-ecommerce-template/img/favicon.ico" rel="icon">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,700&display=swap" rel="stylesheet">

    <!-- CSS Libraries -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="bootstrap-ecommerce-template/lib/slick/slick.css" rel="stylesheet">
    <link href="bootstrap-ecommerce-template/lib/slick/slick-theme.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="bootstrap-ecommerce-template/css/style.css" rel="stylesheet">
</head>

<body>
<!-- Top Header Start -->
<div class="top-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-3">
                <div class="logo">
                    <a href="index.jsp">
                        <img src="bootstrap-ecommerce-template/img/logo.png" alt="Logo">
                    </a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="search">
                    <input type="text" placeholder="Search">
                    <button><i class="fa fa-search"></i></button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="user">
                    <div class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">My Account</a>
                        <div class="dropdown-menu">
                            <a href="login.jsp#login" class="dropdown-item">Login</a>
                            <a href="login.jsp#register" class="dropdown-item">Register</a>
                        </div>
                    </div>
                    <div class="cart">
                        <i class="fa fa-cart-plus"></i>
                        <span>(0)</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Top Header End -->

<!-- Header Start -->
<div class="header">
    <div class="container">
        <nav class="navbar navbar-expand-md bg-dark navbar-dark">
            <a href="#" class="navbar-brand">MENU</a>
            <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">
                <div class="navbar-nav m-auto">
                    <a href="index.jsp" class="nav-item nav-link active">Home</a>
                    <a href="bootstrap-ecommerce-template/product-list.jsp" class="nav-item nav-link">Products</a>
                    <div class="nav-item dropdown">
                        <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Pages</a>
                        <div class="dropdown-menu">
                            <a href="bootstrap-ecommerce-template/product-list.jsp" class="dropdown-item">Product</a>
                            <a href="bootstrap-ecommerce-template/product-detail.jsp" class="dropdown-item">Product Detail</a>
                            <a href="bootstrap-ecommerce-template/cart.jsp" class="dropdown-item">Cart</a>
                            <a href="bootstrap-ecommerce-template/wishlist.jsp" class="dropdown-item">Wishlist</a>
                            <a href="bootstrap-ecommerce-template/checkout.jsp" class="dropdown-item">Checkout</a>
                            <a href="login.jsp" class="dropdown-item">Login & Register</a>
                            <a href="bootstrap-ecommerce-template/my-account.jsp" class="dropdown-item">My Account</a>
                        </div>
                    </div>
                    <a href="bootstrap-ecommerce-template/contact.jsp" class="nav-item nav-link">Contact Us</a>
                </div>
            </div>
        </nav>
    </div>
</div>
<!-- Header End -->

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

<!-- Footer Start -->
<div class="footer">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-3 col-md-6">
                <div class="footer-widget">
                    <h1>E Shop</h1>
                    <p>
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse sollicitudin rutrum massa.
                    </p>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="footer-widget">
                    <h3 class="title">Useful Pages</h3>
                    <ul>
                        <li><a href="bootstrap-ecommerce-template/product-list.jsp">Product</a></li>
                        <li><a href="bootstrap-ecommerce-template/product-detail.jsp">Product Detail</a></li>
                        <li><a href="bootstrap-ecommerce-template/cart.jsp">Cart</a></li>
                        <li><a href="bootstrap-ecommerce-template/checkout.jsp">Checkout</a></li>
                        <li><a href="login.jsp">Login & Register</a></li>
                        <li><a href="bootstrap-ecommerce-template/my-account.jsp">My Account</a></li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="footer-widget">
                    <h3 class="title">Quick Links</h3>
                    <ul>
                        <li><a href="bootstrap-ecommerce-template/product-list.jsp">Product</a></li>
                        <li><a href="bootstrap-ecommerce-template/cart.jsp">Cart</a></li>
                        <li><a href="bootstrap-ecommerce-template/checkout.jsp">Checkout</a></li>
                        <li><a href="login.jsp">Login & Register</a></li>
                        <li><a href="bootstrap-ecommerce-template/my-account.jsp">My Account</a></li>
                        <li><a href="bootstrap-ecommerce-template/wishlist.jsp">Wishlist</a></li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="footer-widget">
                    <h3 class="title">Get in Touch</h3>
                    <div class="contact-info">
                        <p><i class="fa fa-map-marker"></i>123 E Shop, Los Angeles, CA, USA</p>
                        <p><i class="fa fa-envelope"></i>email@example.com</p>
                        <p><i class="fa fa-phone"></i>+123-456-7890</p>
                        <div class="social">
                            <a href=""><i class="fa fa-twitter"></i></a>
                            <a href=""><i class="fa fa-facebook"></i></a>
                            <a href=""><i class="fa fa-linkedin"></i></a>
                            <a href=""><i class="fa fa-instagram"></i></a>
                            <a href=""><i class="fa fa-youtube"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row payment">
            <div class="col-md-6">
                <div class="payment-method">
                    <p>We Accept:</p>
                    <img src="bootstrap-ecommerce-template/img/payment-method.png" alt="Payment Method" />
                </div>
            </div>
            <div class="col-md-6">
                <div class="payment-security">
                    <p>Secured By:</p>
                    <img src="bootstrap-ecommerce-template/img/godaddy.svg" alt="Payment Security" />
                    <img src="bootstrap-ecommerce-template/img/norton.svg" alt="Payment Security" />
                    <img src="bootstrap-ecommerce-template/img/ssl.svg" alt="Payment Security" />
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Footer End -->

<!-- Footer Bottom Start -->
<div class="footer-bottom">
    <div class="container">
        <div class="row">
            <div class="col-md-6 copyright">
                <p>Copyright &copy; <a href="https://htmlcodex.com">HTML Codex</a>. All Rights Reserved</p>
            </div>

            <div class="col-md-6 template-by">
                <p>Template By <a href="https://htmlcodex.com">HTML Codex</a></p>
            </div>
        </div>
    </div>
</div>
<!-- Footer Bottom End -->

<!-- Back to Top -->
<a href="#" class="back-to-top"><i class="fa fa-chevron-up"></i></a>

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
<script src="bootstrap-ecommerce-template/lib/easing/easing.min.js"></script>
<script src="bootstrap-ecommerce-template/lib/slick/slick.min.js"></script>

<!-- Template Javascript -->
<script src="bootstrap-ecommerce-template/js/main.js"></script>
</body>
</html>
