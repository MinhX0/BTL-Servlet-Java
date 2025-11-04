<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>E Shop - Sản phẩm</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="breadcrumb-wrap">
    <div class="container">
        <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
        </ul>
    </div>
</div>

<div class="product-view">
    <div class="container">
        <div class="row">
            <!-- Left sidebar: categories -->
            <div class="col-md-3">
                <div class="sidebar-widget category">
                    <h2 class="title">Danh mục</h2>
                    <ul>
                        <c:choose>
                            <c:when test="${not empty categories}">
                                <c:forEach var="cat" items="${categories}">
                                    <c:url var="catUrl" value="/products">
                                        <c:param name="categoryId" value="${cat.id}"/>
                                        <c:param name="page" value="1"/>
                                        <c:param name="size" value="${size}"/>
                                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                                        <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
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

                <div class="sidebar-widget image">
                    <h2 class="title">Sản phẩm nổi bật</h2>
                    <a href="#">
                        <c:url var="sideImg" value="/assets/img/category-1.jpg"/>
                        <c:url var="placeholderUrl" value="/assets/img/placeholder.jpg"/>
                        <img src="${sideImg}" alt="Nổi bật" onerror="this.onerror=null;this.src='${placeholderUrl}'">
                    </a>
                </div>
            </div>

            <!-- Right content: products grid -->
            <div class="col-md-9">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="product-search">
                                    <c:set var="kw" value="${param.q != null ? param.q : keyword}"/>
                                    <c:url var="searchAction" value="/products">
                                        <c:if test="${not empty categoryId}">
                                            <c:param name="categoryId" value="${categoryId}"/>
                                        </c:if>
                                        <c:param name="size" value="${size}"/>
                                        <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
                                    </c:url>
                                    <form method="get" action="${searchAction}" class="d-flex">
                                        <input type="text" name="q" value="${fn:escapeXml(kw)}" placeholder="Tìm kiếm sản phẩm" class="form-control"/>
                                        <button type="submit" class="btn btn-primary ml-2"><i class="fa fa-search"></i></button>
                                    </form>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="product-short">
                                    <div class="dropdown">
                                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Sắp xếp</a>
                                        <div class="dropdown-menu dropdown-menu-right">
                                            <c:url var="sortNewest" value="/products">
                                                <c:param name="page" value="1"/>
                                                <c:param name="size" value="${size}"/>
                                                <c:param name="sort" value="date_desc"/>
                                                <c:if test="${not empty kw}"><c:param name="q" value="${kw}"/></c:if>
                                                <c:if test="${not empty categoryId}"><c:param name="categoryId" value="${categoryId}"/></c:if>
                                            </c:url>
                                            <c:url var="sortPriceAsc" value="/products">
                                                <c:param name="page" value="1"/>
                                                <c:param name="size" value="${size}"/>
                                                <c:param name="sort" value="price_asc"/>
                                                <c:if test="${not empty kw}"><c:param name="q" value="${kw}"/></c:if>
                                                <c:if test="${not empty categoryId}"><c:param name="categoryId" value="${categoryId}"/></c:if>
                                            </c:url>
                                            <c:url var="sortPriceDesc" value="/products">
                                                <c:param name="page" value="1"/>
                                                <c:param name="size" value="${size}"/>
                                                <c:param name="sort" value="price_desc"/>
                                                <c:if test="${not empty kw}"><c:param name="q" value="${kw}"/></c:if>
                                                <c:if test="${not empty categoryId}"><c:param name="categoryId" value="${categoryId}"/></c:if>
                                            </c:url>
                                            <a href="${sortNewest}" class="dropdown-item ${sort == 'date_desc' || empty sort ? 'active' : ''}">Mới nhất</a>
                                            <a href="${sortPriceAsc}" class="dropdown-item ${sort == 'price_asc' ? 'active' : ''}">Giá: Thấp đến Cao</a>
                                            <a href="${sortPriceDesc}" class="dropdown-item ${sort == 'price_desc' ? 'active' : ''}">Giá: Cao đến Thấp</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product grid -->
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="p" items="${products}">
                                <div class="col-lg-4 col-md-6">
                                    <div class="product-item">
                                        <div class="product-image">
                                            <c:url var="detailUrl" value="/product-detail">
                                                <c:param name="id" value="${p.id}"/>
                                            </c:url>
                                            <c:choose>
                                                <c:when test="${empty p.mainImageUrl or fn:length(fn:trim(p.mainImageUrl)) == 0}">
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
                                            <c:url var="imgUrl" value="${resolvedImg}"/>
                                            <c:url var="placeholderUrl" value="/assets/img/placeholder.jpg"/>
                                            <!-- Avoid double-prefixing context path, use resolvedImg directly -->
                                            <a href="${detailUrl}"><img src="${resolvedImg}" alt="${fn:escapeXml(p.name)}" loading="lazy" onerror="this.onerror=null;this.src='${placeholderUrl}'"></a>
                                            <div class="product-action">
                                                <c:url var="addToCartUrl" value="/add-to-cart">
                                                    <c:param name="productId" value="${p.id}"/>
                                                </c:url>
                                                <a href="${addToCartUrl}" aria-label="Thêm ${fn:escapeXml(p.name)} vào giỏ"><i class="fa fa-cart-plus"></i></a>
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
                            <div class="col-12">
                                <div class="alert alert-info">Không tìm thấy sản phẩm.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>

                <div class="col-lg-12">
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Điều hướng trang">
                            <ul class="pagination justify-content-center">
                                <c:set var="prevPage" value="${page - 1}"/>
                                <c:set var="nextPage" value="${page + 1}"/>

                                <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                    <c:url var="prevUrl" value="/products">
                                        <c:param name="page" value="${prevPage}"/>
                                        <c:param name="size" value="${size}"/>
                                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                                        <c:if test="${not empty categoryId}"><c:param name="categoryId" value="${categoryId}"/></c:if>
                                        <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
                                    </c:url>
                                    <a class="page-link" href="${prevUrl}" tabindex="-1">Trước</a>
                                </li>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:url var="pUrl" value="/products">
                                        <c:param name="page" value="${i}"/>
                                        <c:param name="size" value="${size}"/>
                                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                                        <c:if test="${not empty categoryId}"><c:param name="categoryId" value="${categoryId}"/></c:if>
                                        <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
                                    </c:url>
                                    <li class="page-item ${i == page ? 'active' : ''}"><a class="page-link" href="${pUrl}">${i}</a></li>
                                </c:forEach>

                                <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                    <c:url var="nextUrl" value="/products">
                                        <c:param name="page" value="${nextPage}"/>
                                        <c:param name="size" value="${size}"/>
                                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                                        <c:if test="${not empty categoryId}"><c:param name="categoryId" value="${categoryId}"/></c:if>
                                        <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
                                    </c:url>
                                    <a class="page-link" href="${nextUrl}">Tiếp</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
