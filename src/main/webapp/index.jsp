<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>E Shop - Home</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Main Slider Start -->
<div class="home-slider">
    <div class="main-slider">
        <div class="main-slider-item"><img src="<%= request.getContextPath() %>/bootstrap-ecommerce-template/img/slider-1.jpg" alt="Slider Image" /></div>
        <div class="main-slider-item"><img src="<%= request.getContextPath() %>/bootstrap-ecommerce-template/img/slider-2.jpg" alt="Slider Image" /></div>
        <div class="main-slider-item"><img src="<%= request.getContextPath() %>/bootstrap-ecommerce-template/img/slider-3.jpg" alt="Slider Image" /></div>
    </div>
</div>
<!-- Main Slider End -->

<!-- Feature Start-->
<div class="feature">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-3 col-md-6 feature-col">
                <div class="feature-content">
                    <i class="fa fa-shield"></i>
                    <h2>Trusted Shopping</h2>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 feature-col">
                <div class="feature-content">
                    <i class="fa fa-shopping-bag"></i>
                    <h2>Quality Product</h2>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 feature-col">
                <div class="feature-content">
                    <i class="fa fa-truck"></i>
                    <h2>Worldwide Delivery</h2>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 feature-col">
                <div class="feature-content">
                    <i class="fa fa-phone"></i>
                    <h2>Telephone Support</h2>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit</p>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Feature End-->

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>