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
        <c:set var="v" value="${applicationScope.assetVersion}"/>
        <c:url var="slide1" value="/assets/img/slider-1.jpg"/>
        <c:url var="slide2" value="/assets/img/slider-2.jpg"/>
        <c:url var="slide3" value="/assets/img/slider-3.jpg"/>
        <div class="main-slider-item"><img src="${slide1}?v=${v}" alt="Slider 1" /></div>
        <div class="main-slider-item"><img src="${slide2}?v=${v}" alt="Slider 2" /></div>
        <div class="main-slider-item"><img src="${slide3}?v=${v}" alt="Slider 3" /></div>
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
            <!-- Demo card (kept) but corrected paths and fallback -->
            <div class="col-lg-3">
                <div class="product-item">
                    <div class="product-image">
                        <c:url var="demoDetail" value="/product-detail.jsp"/>
                        <c:url var="demoImg" value="/assets/img/product-1.png"/>
                        <c:url var="placeholderUrl" value="/assets/img/placeholder.jpg"/>
                        <a href="${demoDetail}">
                            <img src="${demoImg}?v=${v}" alt="Product Image" onerror="this.onerror=null;this.src='${placeholderUrl}?v=${v}'">
                        </a>
                        <div class="product-action">
                            <a href="#"><i class="fa fa-cart-plus"></i></a>
                            <a href="#"><i class="fa fa-heart"></i></a>
                            <a href="#"><i class="fa fa-search"></i></a>
                        </div>
                    </div>
                    <div class="product-content">
                        <div class="title"><a href="#">Phasellus Gravida</a></div>
                        <div class="ratting">
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                        </div>
                        <div class="price">$22 <span>$25</span></div>
                    </div>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty featuredProducts}">
                    <c:forEach var="p" items="${featuredProducts}">
                        <div class="col-lg-3">
                            <div class="product-item">
                                <div class="product-image">
                                    <c:url var="detailUrl" value="/product-detail.jsp">
                                        <c:param name="id" value="${p.id}"/>
                                    </c:url>
                                    <%-- Robust image URL resolution: default, absolute, or prefix relative filenames under /assets/img/ --%>
                                    <c:choose>
                                        <c:when test="${empty p.mainImageUrl}">
                                            <c:set var="resolvedImg" value="/assets/img/placeholder.jpg"/>
                                        </c:when>
                                        <c:when test="${fn:startsWith(p.mainImageUrl, 'http://') || fn:startsWith(p.mainImageUrl, 'https://') || fn:startsWith(p.mainImageUrl, '/')}" >
                                            <c:set var="resolvedImg" value="${p.mainImageUrl}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="resolvedImg" value="/assets/img/${p.mainImageUrl}"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:url var="imgUrl" value="${resolvedImg}"/>
                                    <c:url var="placeholderUrl2" value="/assets/img/placeholder.jpg"/>
                                    <a href="${detailUrl}" aria-label="View ${fn:escapeXml(p.name)} details">
                                        <img src="${imgUrl}?v=${v}" alt="${fn:escapeXml(p.name)}" onerror="this.onerror=null;this.src='${placeholderUrl2}?v=${v}'">
                                    </a>
                                    <div class="product-action">
                                        <c:url var="addToCart" value="/add-to-cart">
                                            <c:param name="productId" value="${p.id}"/>
                                        </c:url>
                                        <a href="${addToCart}" aria-label="Add ${fn:escapeXml(p.name)} to cart"><i class="fa fa-cart-plus"></i></a>
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