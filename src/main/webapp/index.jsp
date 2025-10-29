<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
        <c:url var="slide1" value="/assets/img/slider-1.jpg"/>
        <c:url var="slide2" value="/assets/img/slider-2.jpg"/>
        <c:url var="slide3" value="/assets/img/slider-3.jpg"/>
        <div class="main-slider-item"><img src="${slide1}" alt="Slider 1" /></div>
        <div class="main-slider-item"><img src="${slide2}" alt="Slider 2" /></div>
        <div class="main-slider-item"><img src="${slide3}" alt="Slider 3" /></div>
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

<!-- Category Start-->
<div class="category">
    <div class="container-fluid">
        <div class="row">
            <c:choose>
                <c:when test="${not empty categories}">
                    <c:forEach var="cat" items="${categories}" varStatus="st">
                        <div class="col-md-4">
                            <div class="category-img">
                                <c:set var="imgName" value="${st.index % 4 == 0 ? 'category-1.jpg' : st.index % 4 == 1 ? 'category-2.jpg' : st.index % 4 == 2 ? 'category-3.jpg' : 'category-4.jpg'}"/>
                                <c:url var="catImg" value="/assets/img/${imgName}"/>
                                <img src="${catImg}" alt="${fn:escapeXml(cat.name)}" />
                                <c:url var="catUrl" value="/products">
                                    <c:param name="categoryId" value="${cat.id}"/>
                                    <c:param name="page" value="1"/>
                                </c:url>
                                <a class="category-name" href="${catUrl}">
                                    <h2>${cat.name}</h2>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12"><span class="text-muted">No categories</span></div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<!-- Category End-->

<!-- Featured Product Start -->
<div class="featured-product">
    <div class="container">
        <div class="section-header">
            <h3>Featured Product</h3>
            <p>
                Latest additions to the store
            </p>
        </div>
        <div class="row align-items-center product-slider product-slider-4">
            <c:choose>
                <c:when test="${not empty featuredProducts}">
                    <c:forEach var="p" items="${featuredProducts}">
                        <div class="col-lg-3">
                            <div class="product-item">
                                <div class="product-image">
                                    <c:url var="detailUrl" value="/product-detail.jsp">
                                        <c:param name="id" value="${p.id}"/>
                                    </c:url>
                                    <c:set var="img" value="${empty p.mainImageUrl ? '/assets/img/product-1.png' : p.mainImageUrl}"/>
                                    <c:url var="imgUrl" value="${img}"/>
                                    <a href="${detailUrl}">
                                        <img src="${imgUrl}" alt="${fn:escapeXml(p.name)}">
                                    </a>
                                    <div class="product-action">
                                        <a href="#"><i class="fa fa-cart-plus"></i></a>
                                        <a href="#"><i class="fa fa-heart"></i></a>
                                        <a href="#"><i class="fa fa-search"></i></a>
                                    </div>
                                </div>
                                <div class="product-content">
                                    <div class="title"><a href="${detailUrl}">${p.name}</a></div>
                                    <div class="ratting">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                    </div>
                                    <div class="price">${p.basePrice}</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-info">No featured products yet.</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<!-- Featured Product End -->

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>