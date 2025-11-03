<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi tiết sản phẩm</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Breadcrumb Start -->
<div class="breadcrumb-wrap">
    <div class="container">
        <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
            <li class="breadcrumb-item active">Chi tiết</li>
        </ul>
    </div>
</div>
<!-- Breadcrumb End -->

<!-- Product Detail Start -->
<div class="product-detail">
    <div class="container">
        <c:set var="v" value="${applicationScope.assetVersion}"/>
        <c:url var="phUrl" value="/assets/img/placeholder.jpg"/>
        <div class="row">
            <div class="col-lg-9">
                <div class="row align-items-center product-detail-top">
                    <div class="col-md-5">
                        <div class="product-slider-single">
                            <c:choose>
                                <c:when test="${empty product}">
                                    <img src="${phUrl}?v=${v}" alt="Placeholder">
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${empty product.mainImageUrl}">
                                            <c:set var="imgSrc" value="/product-image"/>
                                        </c:when>
                                        <c:when test="${fn:startsWith(product.mainImageUrl,'http://') || fn:startsWith(product.mainImageUrl,'https://')}">
                                            <c:set var="imgSrc" value="${product.mainImageUrl}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url var="imgSrc" value="/product-image">
                                                <c:param name="file" value="${fn:startsWith(product.mainImageUrl,'/') ? fn:substringAfter(product.mainImageUrl,'/') : product.mainImageUrl}"/>
                                            </c:url>
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${imgSrc}" alt="${fn:escapeXml(product.name)}" onerror="this.onerror=null;this.src='${phUrl}?v=${v}'">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-7">
                        <div class="product-content">
                            <div class="title"><h2>${empty product ? 'Sản phẩm' : fn:escapeXml(product.name)}</h2></div>
                            <div class="ratting">
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                            </div>
                            <div class="price">
                                <c:choose>
                                    <c:when test="${not empty product && not empty product.basePrice}">
                                        <fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true"/> đ
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="details">
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty product && not empty product.description}">
                                            ${fn:escapeXml(product.description)}
                                        </c:when>
                                        <c:otherwise>Không có mô tả cho sản phẩm này.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <form class="quantity" method="post" action="${pageContext.request.contextPath}/add-to-cart">
                                <input type="hidden" name="productId" value="${product.id}" />
                                <h4>Số lượng:</h4>
                                <div class="qty">
                                    <button type="button" class="btn-minus"><i class="fa fa-minus"></i></button>
                                    <input name="quantity" type="text" value="1">
                                    <button type="button" class="btn-plus"><i class="fa fa-plus"></i></button>
                                </div>
                                <div class="action">
                                    <button type="submit" class="btn btn-primary" aria-label="Thêm vào giỏ"><i class="fa fa-cart-plus"></i></button>
                                    <a href="#" class="btn btn-outline-secondary" aria-label="Yêu thích"><i class="fa fa-heart"></i></a>
                                    <a href="#" class="btn btn-outline-secondary" aria-label="Xem nhanh"><i class="fa fa-search"></i></a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="row product-detail-bottom">
                    <div class="col-lg-12">
                        <ul class="nav nav-pills nav-justified">
                            <li class="nav-item">
                                <a class="nav-link active" data-toggle="pill" href="#description">Mô tả</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="pill" href="#specification">Thông số</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="pill" href="#reviews">Đánh giá</a>
                            </li>
                        </ul>

                        <div class="tab-content">
                            <div id="description" class="container tab-pane active"><br>
                                <h4>Mô tả sản phẩm</h4>
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty product && not empty product.description}">${fn:escapeXml(product.description)}</c:when>
                                        <c:otherwise>Không có mô tả.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div id="specification" class="container tab-pane fade"><br>
                                <h4>Thông số</h4>
                                <ul>
                                    <li>Tên: ${empty product ? '-' : fn:escapeXml(product.name)}</li>
                                    <li>Giá: <c:choose><c:when test="${not empty product && not empty product.basePrice}"><fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true"/> đ</c:when><c:otherwise>-</c:otherwise></c:choose></li>
                                    <c:if test="${not empty product && not empty product.category && not empty product.category.name}"><li>Danh mục: ${fn:escapeXml(product.category.name)}</li></c:if>
                                </ul>
                            </div>
                            <div id="reviews" class="container tab-pane fade"><br>
                                <div class="reviews-submitted">
                                    <div class="reviewer">Khách hàng - <span><fmt:formatDate value="${nowDate}" pattern="dd/MM/yyyy"/></span></div>
                                    <div class="ratting">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                    </div>
                                    <p>
                                        Chưa có đánh giá.
                                    </p>
                                </div>
                                <div class="reviews-submit">
                                    <h4>Gửi đánh giá:</h4>
                                    <div class="ratting">
                                        <i class="fa fa-star-o"></i>
                                        <i class="fa fa-star-o"></i>
                                        <i class="fa fa-star-o"></i>
                                        <i class="fa fa-star-o"></i>
                                        <i class="fa fa-star-o"></i>
                                    </div>
                                    <div class="row form">
                                        <div class="col-sm-6">
                                            <input type="text" placeholder="Tên">
                                        </div>
                                        <div class="col-sm-6">
                                            <input type="email" placeholder="Email">
                                        </div>
                                        <div class="col-sm-12">
                                            <textarea placeholder="Nội dung đánh giá"></textarea>
                                        </div>
                                        <div class="col-sm-12">
                                            <button>Gửi</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="container">
                    <div class="section-header">
                        <h3>Sản phẩm liên quan</h3>
                        <p>
                            Có thể bạn cũng thích
                        </p>
                    </div>
                </div>

                <div class="row align-items-center product-slider product-slider-3">
                    <c:if test="${not empty relatedProducts}">
                        <c:forEach var="rp" items="${relatedProducts}">
                            <div class="col-lg-3">
                                <div class="product-item">
                                    <div class="product-image">
                                        <c:url var="rpDetail" value="/product-detail">
                                            <c:param name="id" value="${rp.id}"/>
                                        </c:url>
                                        <c:choose>
                                            <c:when test="${empty rp.mainImageUrl}">
                                                <c:set var="rpImg" value="/product-image"/>
                                            </c:when>
                                            <c:when test="${fn:startsWith(rp.mainImageUrl,'http://') || fn:startsWith(rp.mainImageUrl,'https://')}">
                                                <c:set var="rpImg" value="${rp.mainImageUrl}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:url var="rpImg" value="/product-image">
                                                    <c:param name="file" value="${fn:startsWith(rp.mainImageUrl,'/') ? fn:substringAfter(rp.mainImageUrl,'/') : rp.mainImageUrl}"/>
                                                </c:url>
                                            </c:otherwise>
                                        </c:choose>
                                        <img src="${rpImg}" alt="${fn:escapeXml(rp.name)}" onerror="this.onerror=null;this.src='${phUrl}?v=${v}'">
                                        <div class="product-action">
                                            <c:url var="addRp" value="/add-to-cart">
                                                <c:param name="productId" value="${rp.id}"/>
                                            </c:url>
                                            <a href="${addRp}"><i class="fa fa-cart-plus"></i></a>
                                        </div>
                                    </div>
                                    <div class="product-content">
                                        <div class="title"><a href="${rpDetail}">${rp.name}</a></div>
                                        <div class="ratting">
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                        </div>
                                        <div class="price"><fmt:formatNumber value="${rp.basePrice}" type="number" groupingUsed="true"/> đ</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>

            <div class="col-lg-3">
                <div class="sidebar-widget image">
                    <h2 class="title">Sản phẩm nổi bật</h2>
                    <a href="#">
                        <img src="${phUrl}?v=${v}" alt="Image">
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Product Detail End -->

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
