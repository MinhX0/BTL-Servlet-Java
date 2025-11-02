<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Cửa hàng E Shop</title>
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
        <c:url var="slide4" value="/assets/img/slider-4.jpg"/>

        <div class="main-slider-item"><img src="${slide1}?v=${v}" alt="Slider 1" /></div>
        <div class="main-slider-item"><img src="${slide2}?v=${v}" alt="Slider 2" /></div>
        <div class="main-slider-item"><img src="${slide3}?v=${v}" alt="Slider 3" /></div>
        <div class="main-slider-item"><img src="${slide4}?v=${v}" alt="Slider 4" /></div>
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
                    <h2>Mua sắm đáng tin cậy</h2>
                    <p>Mua sắm an toàn, bảo mật với dịch vụ hỗ trợ tận tâm</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 feature-col">
                <div class="feature-content">
                    <i class="fa fa-shopping-bag"></i>
                    <h2>Sản phẩm chất lượng</h2>
                    <p>Sản phẩm chính hãng, chất lượng được kiểm chứng</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 feature-col">
                <div class="feature-content">
                    <i class="fa fa-truck"></i>
                    <h2>Giao hàng toàn cầu</h2>
                    <p>Vận chuyển nhanh chóng đến nhiều quốc gia</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 feature-col">
                <div class="feature-content">
                    <i class="fa fa-phone"></i>
                    <h2>Hỗ trợ qua điện thoại</h2>
                    <p>Liên hệ dễ dàng khi cần tư vấn hoặc trợ giúp</p>
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
            <h3>Sản phẩm nổi bật</h3>
            <p>
                Những sản phẩm mới nhất
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
                                    <a href="${detailUrl}" aria-label="Xem chi tiết ${fn:escapeXml(p.name)}">
                                        <img src="${placeholderUrl2}?v=${v}" data-src="${imgUrl}?v=${v}" alt="${fn:escapeXml(p.name)}" class="lazy-img">
                                    </a>
                                    <div class="product-action">
                                        <c:url var="addToCart" value="/add-to-cart">
                                            <c:param name="productId" value="${p.id}"/>
                                        </c:url>
                                        <a href="${addToCart}" aria-label="Thêm ${fn:escapeXml(p.name)} vào giỏ"><i class="fa fa-cart-plus"></i></a>
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
                                    <div class="price"><fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true"/> đ</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-info">Chưa có sản phẩm nổi bật.</div>
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