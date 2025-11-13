<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Giỏ hàng</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
    <style>
      .size-select { max-height: 120px; overflow-y: auto; }
      .price-old { color: #888; text-decoration: line-through; font-size: .9rem; }
      .price-new { color: #d0021b; font-weight: 600; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Cart Start -->
<div class="cart-page">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead class="thead-dark">
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên</th>
                            <th>Kích cỡ</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Tổng</th>
                            <th>Xóa</th>
                        </tr>
                        </thead>
                        <tbody class="align-middle">
                        <c:choose>
                            <c:when test="${not empty cartItems}">
                                <c:set var="subTotal" value="0"/>
                                <c:forEach var="ci" items="${cartItems}" varStatus="st">
                                    <c:set var="unitPrice" value="${ci.product.effectivePrice}"/>
                                    <c:set var="lineTotal" value="${unitPrice * ci.quantity}"/>
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty ci.product.mainImageUrl}">
                                                    <c:set var="resolvedImg" value="/product-image"/>
                                                </c:when>
                                                <c:when test="${fn:startsWith(ci.product.mainImageUrl,'http://') || fn:startsWith(ci.product.mainImageUrl,'https://') || fn:startsWith(ci.product.mainImageUrl,'/')}">
                                                    <c:set var="resolvedImg" value="${ci.product.mainImageUrl}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="resolvedImg" value="/product-image">
                                                        <c:param name="file" value="${ci.product.mainImageUrl}"/>
                                                    </c:url>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:url var="phUrl" value="/assets/img/placeholder.jpg"/>
                                            <a href="#"><img src="${resolvedImg}" alt="${fn:escapeXml(ci.product.name)}" onerror="this.onerror=null;this.src='${phUrl}'"></a>
                                        </td>
                                        <td>
                                            <c:url var="detailUrl" value="/product-detail">
                                                <c:param name="id" value="${ci.product.id}"/>
                                            </c:url>
                                            <a href="${detailUrl}">${ci.product.name}</a>
                                        </td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/cart" class="mb-0">
                                                <input type="hidden" name="action" value="changeSize"/>
                                                <input type="hidden" name="cartItemId" value="${ci.id}"/>
                                                <select name="size" class="form-control size-select" onchange="this.form.submit()">
                                                    <c:forEach var="opt" items="${[39,40,41,42,43,44,45]}">
                                                        <option value="${opt}" ${ci.itemSize == opt ? 'selected' : ''}>${opt}</option>
                                                    </c:forEach>
                                                </select>
                                            </form>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${ci.product.salePrice != null && ci.product.salePrice > 0}">
                                                    <div class="price-old"><fmt:formatNumber value="${ci.product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</div>
                                                    <div class="price-new"><fmt:formatNumber value="${unitPrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div><fmt:formatNumber value="${unitPrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/cart" class="d-inline">
                                                <input type="hidden" name="action" value="update"/>
                                                <input type="hidden" name="cartItemId" value="${ci.id}"/>
                                                <div class="qty">
                                                    <button type="button" class="btn-minus"><i class="fa fa-minus"></i></button>
                                                    <input type="text" name="qty" value="${ci.quantity}" min="1">
                                                    <button type="button" class="btn-plus"><i class="fa fa-plus"></i></button>
                                                    <button type="submit" class="btn btn-sm btn-secondary ml-2">Cập nhật</button>
                                                </div>
                                            </form>
                                        </td>
                                        <td><fmt:formatNumber value="${lineTotal}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/cart" onsubmit="return confirm('Xóa sản phẩm này?');">
                                                <input type="hidden" name="action" value="remove"/>
                                                <input type="hidden" name="cartItemId" value="${ci.id}"/>
                                                <button class="btn btn-danger"><i class="fa fa-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                    <c:set var="subTotal" value="${subTotal + lineTotal}"/>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="7" class="text-center text-muted">Giỏ hàng trống.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <c:if test="${not empty cartItems}">
            <div class="row">
                <div class="col-md-6">
                    <div class="cart-summary">
                        <div class="cart-content">
                            <h3>Tóm tắt giỏ hàng</h3>
                            <p>Tạm tính<span><fmt:formatNumber value="${subTotal}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</span></p>
                            <p>Phí vận chuyển<span>0đ</span></p>
                            <h4>Tổng cộng<span><fmt:formatNumber value="${subTotal}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</span></h4>
                        </div>
                        <div class="cart-btn">
                            <form method="post" action="${pageContext.request.contextPath}/cart" class="d-inline">
                                <input type="hidden" name="action" value="clear"/>
                                <button class="btn btn-secondary" name="action" value="clear">Xóa giỏ</button>
                            </form>
                            <c:url var="checkoutUrl" value="/checkout"/>
                            <a class="btn btn-secondary" href="${checkoutUrl}">Thanh toán</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>
<!-- Cart End -->

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
