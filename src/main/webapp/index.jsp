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
<body class="home-index">
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



<!-- Main Content: Categories (left) + Sections (right) -->
<div class="container">
    <div class="row">
        <!-- Left: Categories column spans entire page height next to product sections -->
        <div class="col-md-3">
            <div class="sidebar-widget category">
                <h2 class="title">Danh mục</h2>
                <ul>
                    <c:choose>
                        <c:when test="${not empty categories}">
                            <c:forEach var="cat" items="${categories}">
                                <c:url var="catUrl" value="/products">
                                    <c:param name="categoryId" value="${cat.id}"/>
                                </c:url>
                                <li>
                                    <a href="${catUrl}">${cat.name}</a>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <li><span class="text-muted">Không có danh mục</span></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <!-- Right: Stacked product sections -->
        <div class="col-md-9">
            <c:url var="placeholderUrl2" value="/assets/img/placeholder.jpg"/>

            <!-- Featured products -->
            <div class="featured-product">
                <div class="section-header">
                    <h3>Sản phẩm nổi bật</h3>
                    <p>Những sản phẩm mới nhất</p>
                </div>
                <div class="row align-items-center product-slider product-slider-4">
                    <c:choose>
                        <c:when test="${not empty featuredProducts}">
                            <c:forEach var="p" items="${featuredProducts}">
                                <div class="col-lg-3">
                                    <div class="product-item">
                                        <div class="product-image">
                                            <c:url var="detailUrl" value="/product-detail">
                                                <c:param name="id" value="${p.id}"/>
                                            </c:url>
                                            <c:choose>
                                                <c:when test="${empty p.mainImageUrl}">
                                                    <c:set var="resolvedImg" value="/product-image"/>
                                                </c:when>
                                                <c:when test="${fn:startsWith(p.mainImageUrl, 'http://') || fn:startsWith(p.mainImageUrl, 'https://')}">
                                                    <c:set var="resolvedImg" value="${p.mainImageUrl}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="resolvedImg" value="/product-image">
                                                        <c:param name="file" value="${fn:startsWith(p.mainImageUrl,'/') ? fn:substringAfter(p.mainImageUrl,'/') : p.mainImageUrl}"/>
                                                    </c:url>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty p.salePrice && p.salePrice > 0 && p.basePrice > p.salePrice}">
                                                <c:set var="discountPercent" value="${(100 - (p.salePrice * 100 / p.basePrice))}"/>
                                                <span class="discount-badge">-${discountPercent}%</span>
                                            </c:if>
                                            <a href="${detailUrl}" aria-label="Xem chi tiết ${fn:escapeXml(p.name)}">
                                                <img src="${resolvedImg}" alt="${fn:escapeXml(p.name)}" class="lazy-img" onerror="this.onerror=null;this.src='${placeholderUrl2}?v=${v}'">
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
                                            <div class="price">
                                                <c:choose>
                                                    <c:when test="${not empty p.salePrice && not empty p.basePrice && p.salePrice > 0 && p.basePrice > p.salePrice}">
                                                        <span class="price-new">
                                                            <fmt:formatNumber value="${p.salePrice}" type="number" groupingUsed="true"/> đ
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="price-new">
                                                            <fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true"/> đ
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
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

            <!-- On Sale -->
            <div class="featured-product">
                <div class="section-header">
                    <h3>Đang giảm giá</h3>
                    <p>Các ưu đãi hot hiện tại</p>
                </div>
                <div class="row align-items-center product-slider product-slider-4">
                    <c:choose>
                        <c:when test="${not empty onSaleProducts}">
                            <c:forEach var="p" items="${onSaleProducts}">
                                <div class="col-lg-3">
                                    <div class="product-item">
                                        <div class="product-image">
                                            <c:url var="detailUrl" value="/product-detail">
                                                <c:param name="id" value="${p.id}"/>
                                            </c:url>
                                            <c:choose>
                                                <c:when test="${empty p.mainImageUrl}">
                                                    <c:set var="resolvedImg" value="/product-image"/>
                                                </c:when>
                                                <c:when test="${fn:startsWith(p.mainImageUrl, 'http://') || fn:startsWith(p.mainImageUrl, 'https://')}">
                                                    <c:set var="resolvedImg" value="${p.mainImageUrl}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="resolvedImg" value="/product-image">
                                                        <c:param name="file" value="${fn:startsWith(p.mainImageUrl,'/') ? fn:substringAfter(p.mainImageUrl,'/') : p.mainImageUrl}"/>
                                                    </c:url>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty p.salePrice && p.salePrice > 0 && p.basePrice > p.salePrice}">
                                                <c:set var="discountPercent" value="${(100 - (p.salePrice * 100 / p.basePrice))}"/>
                                                <span class="discount-badge">-${discountPercent}%</span>
                                            </c:if>
                                            <a href="${detailUrl}">
                                                <img src="${resolvedImg}" alt="${fn:escapeXml(p.name)}" onerror="this.onerror=null;this.src='${placeholderUrl2}?v=${v}'">
                                            </a>
                                            <div class="product-action">
                                                <c:url var="addToCart" value="/add-to-cart">
                                                    <c:param name="productId" value="${p.id}"/>
                                                </c:url>
                                                <a href="${addToCart}"><i class="fa fa-cart-plus"></i></a>
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
                                            <div class="price">
                                                <span class="price-new"><fmt:formatNumber value="${p.salePrice}" type="number" groupingUsed="true"/> đ</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12"><div class="alert alert-info">Không có sản phẩm giảm giá.</div></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- New Arrivals -->
            <div class="featured-product">
                <div class="section-header">
                    <h3>Hàng mới về</h3>
                    <p>Sản phẩm vừa cập nhật</p>
                </div>
                <div class="row align-items-center product-slider product-slider-4">
                    <c:choose>
                        <c:when test="${not empty newestProducts}">
                            <c:forEach var="p" items="${newestProducts}">
                                <div class="col-lg-3">
                                    <div class="product-item">
                                        <div class="product-image">
                                            <c:url var="detailUrl" value="/product-detail">
                                                <c:param name="id" value="${p.id}"/>
                                            </c:url>
                                            <c:choose>
                                                <c:when test="${empty p.mainImageUrl}">
                                                    <c:set var="resolvedImg" value="/product-image"/>
                                                </c:when>
                                                <c:when test="${fn:startsWith(p.mainImageUrl, 'http://') || fn:startsWith(p.mainImageUrl, 'https://')}">
                                                    <c:set var="resolvedImg" value="${p.mainImageUrl}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="resolvedImg" value="/product-image">
                                                        <c:param name="file" value="${fn:startsWith(p.mainImageUrl,'/') ? fn:substringAfter(p.mainImageUrl,'/') : p.mainImageUrl}"/>
                                                    </c:url>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="${detailUrl}">
                                                <img src="${resolvedImg}" alt="${fn:escapeXml(p.name)}" onerror="this.onerror=null;this.src='${placeholderUrl2}?v=${v}'">
                                            </a>
                                            <div class="product-action">
                                                <c:url var="addToCart" value="/add-to-cart">
                                                    <c:param name="productId" value="${p.id}"/>
                                                </c:url>
                                                <a href="${addToCart}"><i class="fa fa-cart-plus"></i></a>
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
                                            <div class="price">
                                                <c:choose>
                                                    <c:when test="${not empty p.salePrice && not empty p.basePrice && p.salePrice > 0 && p.basePrice > p.salePrice}">
                                                        <span class="price-new"><fmt:formatNumber value="${p.salePrice}" type="number" groupingUsed="true"/> đ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="price-new"><fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true"/> đ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12"><div class="alert alert-info">Chưa có sản phẩm mới.</div></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
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
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>