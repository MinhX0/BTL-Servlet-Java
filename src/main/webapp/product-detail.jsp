<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi tiết sản phẩm</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
    <style>
      .product-detail .product-detail-top { align-items: flex-start !important; }
      .product-detail .product-content .title { margin-top: 0; }
      .review-item { border-bottom: 1px solid #eee; padding: 12px 0; }
      .review-item:last-child { border-bottom: none; }
      .rating-stars i { color: #f8b500; }
      .rating-stars .inactive { color: #ccc; }
      .avg-stars i { font-size: 18px; }
      .user-rate-stars i { cursor: pointer; font-size: 22px; transition: transform .15s; }
      .user-rate-stars i:hover { transform: scale(1.2); }
    </style>
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
        <div class="row align-items-start product-detail-top">
            <div class="col-lg-9">
                <div class="row">
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
                            <!-- Pre-format avgRating for use in attribute (EL cannot call fmt tag as function) -->
                            <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" var="avgRatingOneDec"/>
                            <!-- Dynamic average rating stars -->
                            <div class="ratting avg-stars" title="Điểm trung bình: ${avgRatingOneDec} / 5">
                                <c:set var="avg" value="${avgRating != null ? avgRating : 0}"/>
                                <c:choose>
                                    <c:when test="${avg >= 5}">
                                        <c:set var="fullStars" value="5"/>
                                        <c:set var="hasHalf" value="false"/>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- floor using mod: base = avg - (avg mod 1) -->
                                        <c:set var="base" value="${avg - (avg mod 1)}"/>
                                        <!-- our rule: any decimal shows .5 (e.g., 4.1 -> 4.5, 4.9 -> 4.5) -->
                                        <c:set var="fullStars" value="${base}"/>
                                        <c:set var="hasHalf" value="${avg > base}"/>
                                    </c:otherwise>
                                </c:choose>

                                <!-- render full stars -->
                                <c:forEach begin="1" end="${fullStars}" var="i">
                                    <i class="fa fa-star"></i>
                                </c:forEach>
                                <!-- render half star if any -->
                                <c:if test="${hasHalf}">
                                    <i class="fa fa-star-half-o"></i>
                                </c:if>
                                <!-- render empty stars to complete 5 -->
                                <c:set var="empties" value="${5 - fullStars - (hasHalf ? 1 : 0)}"/>
                                <c:forEach begin="1" end="${empties}" var="i">
                                    <i class="fa fa-star-o"></i>
                                </c:forEach>

                                <c:if test="${reviewCount > 0}">
                                    <span class="ms-2">(<fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> / 5 từ ${reviewCount} đánh giá)</span>
                                </c:if>
                                <c:if test="${reviewCount == 0}">
                                    <span class="ms-2">Chưa có đánh giá</span>
                                </c:if>
                            </div>
                            <div class="price">
                                <c:choose>
                                    <c:when test="${not empty product && not empty product.basePrice && not empty product.salePrice && product.salePrice > 0 && product.basePrice > product.salePrice}">
                                        <span class="price-old">
                                            <fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ
                                        </span>
                                        <span class="price-new">
                                            <fmt:formatNumber value="${product.salePrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ
                                        </span>
                                    </c:when>
                                    <c:when test="${not empty product && not empty product.basePrice}">
                                        <span class="price-new"><fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</span>
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

                            <c:choose>
                              <c:when test="${productInactive}">
                                <div class="alert alert-warning mt-3">
                                  Sản phẩm này hiện không còn khả dụng để mua (đã ngừng bán).
                                </div>
                              </c:when>
                              <c:otherwise>
                                <form class="quantity" method="post" action="${pageContext.request.contextPath}/add-to-cart">
                                    <input type="hidden" name="productId" value="${product.id}" />
                                    <!-- Size selector (above quantity) -->
                                    <div class="mb-3">
                                        <label class="d-block font-weight-bold mb-2">Kích cỡ</label>
                                        <div class="btn-group btn-group-toggle flex-wrap" data-toggle="buttons">
                                            <label class="btn btn-outline-secondary m-1">
                                                <input type="radio" name="size" value="39" autocomplete="off"> 39
                                            </label>
                                            <label class="btn btn-outline-secondary m-1 ">
                                                <input type="radio" name="size" value="39" autocomplete="off"> 40
                                            </label>
                                            <label class="btn btn-outline-secondary m-1">
                                                <input type="radio" name="size" value="41" autocomplete="off"> 41
                                            </label>
                                            <label class="btn btn-outline-secondary m-1">
                                                <input type="radio" name="size" value="42" autocomplete="off"> 42
                                            </label>
                                            <label class="btn btn-outline-secondary m-1">
                                                <input type="radio" name="size" value="43" autocomplete="off"> 43
                                            </label>
                                            <label class="btn btn-outline-secondary m-1">
                                                <input type="radio" name="size" value="44" autocomplete="off"> 44
                                            </label>
                                            <label class="btn btn-outline-secondary m-1">
                                                <input type="radio" name="size" value="45" autocomplete="off"> 45
                                            </label>
                                        </div>
                                    </div>

                                    <h4>Số lượng:</h4>
                                    <div class="qty">
                                        <button type="button" class="btn-minus"><i class="fa fa-minus"></i></button>
                                        <input name="quantity" type="text" value="1">
                                        <button type="button" class="btn-plus"><i class="fa fa-plus"></i></button>
                                    </div>
                                    <div class="action">
                                        <button type="submit" class="btn btn-primary" aria-label="Thêm vào giỏ"><i class="fa fa-cart-plus"></i></button>
                                    </div>
                                </form>
                              </c:otherwise>
                            </c:choose>
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
                                    <c:if test="${not empty product && not empty product.category && not empty product.category.name}"><li>Danh mục: ${fn:escapeXml(product.category.name)}</li></c:if>
                                </ul>
                            </div>
                            <div id="reviews" class="container tab-pane fade"><br>
                                <h4>Đánh giá khách hàng</h4>
                                <c:choose>
                                    <c:when test="${reviewCount > 0}">
                                        <p><strong>${reviewCount}</strong> đánh giá - Điểm trung bình: <strong><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> / 5</strong></p>
                                    </c:when>
                                    <c:otherwise><p>Chưa có đánh giá nào cho sản phẩm này.</p></c:otherwise>
                                </c:choose>
                                <div class="reviews-submitted">
                                    <c:forEach var="r" items="${reviews}">
                                        <div class="review-item">
                                            <div class="d-flex justify-content-between">
                                                <div class="reviewer"><strong>${fn:escapeXml(r.user.name)}</strong> - <span>${r.createdAtStr}</span></div>
                                                <div class="rating-stars">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <i class="fa <c:out value='${star <= r.rating ? "fa-star" : "fa-star inactive"}'/>"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="mt-2">${fn:escapeXml(r.content)}</div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <c:if test="${not empty sessionScope.user}">
                                    <div class="reviews-submit mt-4">
                                        <h5>${userReviewRating == null ? 'Gửi đánh giá của bạn' : 'Cập nhật đánh giá của bạn'}</h5>
                                        <form method="post" action="${pageContext.request.contextPath}/reviews" class="row g-3" id="reviewForm">
                                            <input type="hidden" name="productId" value="${product.id}" />
                                            <input type="hidden" name="rating" id="ratingInput" value="${userReviewRating != null ? userReviewRating : 5}" />
                                            <div class="col-12">
                                                <label class="form-label">Điểm:</label>
                                                <div class="user-rate-stars" id="userRateStars">
                                                    <c:set var="initial" value="${userReviewRating != null ? userReviewRating : 5}"/>
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <i data-val="${star}" class="fa <c:out value='${star <= initial ? "fa-star" : "fa-star-o"}'/>"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <label for="content" class="form-label">Nội dung đánh giá</label>
                                                <textarea name="content" id="content" rows="3" class="form-control" placeholder="Cảm nhận của bạn..." required></textarea>
                                            </div>
                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary">${userReviewRating == null ? 'Gửi đánh giá' : 'Cập nhật đánh giá'}</button>
                                            </div>
                                        </form>
                                    </div>
                                </c:if>
                                <c:if test="${empty sessionScope.user}">
                                    <p>Vui lòng <a href="${pageContext.request.contextPath}/login">đăng nhập</a> để gửi đánh giá.</p>
                                </c:if>
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
                            <c:if test="${rp.active}">
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
                                            <c:if test="${not empty rp.salePrice && rp.salePrice > 0 && rp.basePrice > rp.salePrice}">
                                                <c:set var="discountPercent" value="${(100 - (rp.salePrice * 100 / rp.basePrice))}"/>
                                                <span class="discount-badge">-${discountPercent}%</span>
                                            </c:if>
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
                                            <div class="price">
                                                <c:choose>
                                                    <c:when test="${not empty rp.salePrice && not empty rp.basePrice && rp.salePrice > 0 && rp.basePrice > rp.salePrice}">
                                                        <span class="price-new"><fmt:formatNumber value="${rp.salePrice}" type="number" groupingUsed="true"/> đ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="price-new"><fmt:formatNumber value="${rp.basePrice}" type="number" groupingUsed="true"/> đ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
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
<script>
(function() {
  const starsContainer = document.getElementById('userRateStars');
  if (!starsContainer) return;
  const hiddenInput = document.getElementById('ratingInput');
  const setVisual = (val) => {
    [...starsContainer.querySelectorAll('i')].forEach(i => {
      const starVal = parseInt(i.getAttribute('data-val'));
      if (starVal <= val) { i.classList.remove('fa-star-o'); i.classList.add('fa-star'); } else { i.classList.remove('fa-star'); i.classList.add('fa-star-o'); }
    });
  };
  starsContainer.addEventListener('click', (e) => {
    const target = e.target.closest('i');
    if (!target) return;
    const val = parseInt(target.getAttribute('data-val'));
    hiddenInput.value = val;
    setVisual(val);
  });
})();
</script>
</body>
</html>
