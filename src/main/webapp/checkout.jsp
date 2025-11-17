<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thanh toán</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
    <style>
        .checkout-summary .checkout-content p {display:flex;justify-content:space-between;align-items:center;margin:0 0 6px 0;padding:4px 0; border:none;}
        .checkout-summary .checkout-content p span {white-space:nowrap;}
        .checkout-summary .checkout-content h3 {margin:15px 0 10px;}
        .checkout-summary .price-old {text-decoration:line-through;color:#999;font-size:12px;margin-right:4px;}
        .checkout-summary .checkout-content .empty-cart {text-align:center;color:#777;font-style:italic;margin:10px 0;}
        .badge-selected {background:#007bff;color:#fff;border-radius:4px;padding:2px 6px;font-size:12px;}
    </style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="checkout">
    <div class="container">
        <c:if test="${param.error == '1'}">
            <div class="alert alert-danger" role="alert">Thanh toán thất bại. Vui lòng thử lại sau.</div>
        </c:if>
        <div class="row">
            <div class="col-md-7">
                <form method="post" action="${pageContext.request.contextPath}/checkout">
                    <c:if test="${not empty selectedIds}">
                        <div class="mb-2"><span class="badge-selected">Thanh toán ${fn:length(selectedIds)} mục đã chọn</span></div>
                        <c:forEach var="sid" items="${selectedIds}">
                            <input type="hidden" name="selectedItem" value="${sid}" />
                        </c:forEach>
                    </c:if>
                    <div class="billing-address">
                        <h2>Thông tin thanh toán</h2>
                        <div class="row">
                            <div class="col-md-6">
                                <label for="fullName">Họ tên</label>
                                <input id="fullName" class="form-control" type="text" name="fullName" placeholder="Họ tên" required>
                            </div>
                            <div class="col-md-6">
                                <label for="phone">Số điện thoại</label>
                                <input id="phone" class="form-control" type="text" name="phone" placeholder="Số điện thoại" required>
                            </div>
                            <div class="col-md-6">
                                <label for="email">E-mail</label>
                                <input id="email" class="form-control" type="email" name="email" placeholder="E-mail" required>
                            </div>
                            <div class="col-md-6">
                                <label for="address">Địa chỉ</label>
                                <input id="address" class="form-control" type="text" name="address" placeholder="Địa chỉ" required>
                            </div>
                            <div class="col-md-6">
                                <label for="city">Thành phố</label>
                                <input id="city" class="form-control" type="text" name="city" placeholder="Thành phố">
                            </div>
                            <div class="col-md-6">
                                <label for="state">Tỉnh/Quận</label>
                                <input id="state" class="form-control" type="text" name="state" placeholder="Tỉnh/Quận">
                            </div>
                            <div class="col-md-6">
                                <label for="zip">Mã bưu điện</label>
                                <input id="zip" class="form-control" type="text" name="zip" placeholder="Mã bưu điện">
                            </div>
                        </div>
                    </div>
                    <div class="checkout-payment">
                        <h2>Phương thức thanh toán</h2>
                        <div class="payment-methods">
                            <div class="payment-method">
                                <div class="custom-control custom-radio">
                                    <input type="radio" class="custom-control-input" id="payment-vnpay" name="payment" value="VNPAY" checked>
                                    <label class="custom-control-label" for="payment-vnpay">VNPay</label>
                                </div>
                            </div>
                            <div class="payment-method">
                                <div class="custom-control custom-radio">
                                    <input type="radio" class="custom-control-input" id="payment-cod" name="payment" value="COD">
                                    <label class="custom-control-label" for="payment-cod">Thanh toán khi nhận hàng (COD)</label>
                                </div>
                            </div>
                        </div>
                        <div class="checkout-btn">
                            <button type="submit">Đặt hàng</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="col-md-5">
                <div class="checkout-summary">
                    <h2>Tổng giỏ hàng</h2>
                    <div class="checkout-content">
                        <h3>Sản phẩm</h3>
                        <c:set var="computedTotal" value="0" />
                        <c:choose>
                            <c:when test="${not empty cartItems}">
                                <c:forEach var="ci" items="${cartItems}">
                                    <c:set var="discounted" value="${not empty ci.product.salePrice && ci.product.salePrice > 0 && ci.product.basePrice > ci.product.salePrice}" />
                                    <c:set var="unitPrice" value="${discounted ? ci.product.salePrice : ci.product.basePrice}" />
                                    <c:set var="lineTotal" value="${unitPrice * ci.quantity}" />
                                    <c:set var="computedTotal" value="${computedTotal + lineTotal}" />
                                    <p>${ci.product.name} x ${ci.quantity}
                                        <span><fmt:formatNumber value="${lineTotal}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0" /> đ</span>
                                    </p>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-cart">Giỏ hàng trống</div>
                            </c:otherwise>
                        </c:choose>
                        <c:set var="finalTotal" value="${empty subTotal ? computedTotal : subTotal}" />
                        <p class="sub-total">Tạm tính<span><fmt:formatNumber value="${finalTotal}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0" /> đ</span></p>
                        <p class="ship-cost">Phí vận chuyển<span>0đ</span></p>
                        <h4>Tổng cộng<span><fmt:formatNumber value="${finalTotal}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0" /> đ</span></h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
