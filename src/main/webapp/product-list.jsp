<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>E Shop - Products</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="breadcrumb-wrap">
    <div class="container">
        <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Products</a></li>
        </ul>
    </div>
</div>

<div class="product-view">
    <div class="container">
        <div class="row">
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
                                        <input type="text" name="q" value="${fn:escapeXml(kw)}" placeholder="Search products" class="form-control"/>
                                        <button type="submit" class="btn btn-primary ml-2"><i class="fa fa-search"></i></button>
                                    </form>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="product-short">
                                    <div class="dropdown">
                                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Sort</a>
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
                                            <a href="${sortNewest}" class="dropdown-item ${sort == 'date_desc' || empty sort ? 'active' : ''}">Newest</a>
                                            <a href="${sortPriceAsc}" class="dropdown-item ${sort == 'price_asc' ? 'active' : ''}">Price: Low to High</a>
                                            <a href="${sortPriceDesc}" class="dropdown-item ${sort == 'price_desc' ? 'active' : ''}">Price: High to Low</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="p" items="${products}">
                                <div class="col-lg-4 mb-4">
                                    <div class="product-item">
                                        <div class="product-image">
                                            <c:url var="detailUrl" value="/product-detail.jsp">
                                                <c:param name="id" value="${p.id}"/>
                                            </c:url>
                                            <c:choose>
                                                <c:when test="${empty p.mainImageUrl}">
                                                    <c:set var="resolvedImg" value="/assets/img/placeholder.jpg"/>
                                                </c:when>
                                                <c:when test="${fn:startsWith(p.mainImageUrl, 'http://') || fn:startsWith(p.mainImageUrl, 'https://') || fn:startsWith(p.mainImageUrl, '/')}">
                                                    <c:set var="resolvedImg" value="${p.mainImageUrl}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="resolvedImg" value="/assets/img/${p.mainImageUrl}"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:url var="imgUrl" value="${resolvedImg}"/>
                                            <c:url var="placeholderUrl" value="/assets/img/placeholder.jpg"/>
                                            <a href="${detailUrl}">
                                                <img src="${imgUrl}" alt="${fn:escapeXml(p.name)}" onerror="this.onerror=null;this.src='${placeholderUrl}'">
                                            </a>
                                            <div class="product-action">
                                                <c:url var="addToCartUrl" value="/add-to-cart">
                                                    <c:param name="productId" value="${p.id}"/>
                                                </c:url>
                                                <a href="${addToCartUrl}" aria-label="Add ${fn:escapeXml(p.name)} to cart"><i class="fa fa-cart-plus"></i></a>
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
                                                ${p.basePrice}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="alert alert-info">No products found.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>

                <div class="col-lg-12">
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
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
                                    <a class="page-link" href="${prevUrl}" tabindex="-1">Previous</a>
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
                                    <a class="page-link" href="${nextUrl}">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>

            <div class="col-md-3">
                <div class="sidebar-widget category">
                    <h2 class="title">Category</h2>
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
                                <li><span class="text-muted">No categories</span></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>

                <div class="sidebar-widget image">
                    <h2 class="title">Featured Product</h2>
                    <a href="#">
                        <c:url var="sideImg" value="/assets/img/category-1.jpg"/>
                        <img src="${sideImg}" alt="Featured">
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
