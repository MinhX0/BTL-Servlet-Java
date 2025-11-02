<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thanh toán</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Checkout Start -->
<div class="checkout">
    <div class="container">
        <c:if test="${param.error == '1'}">
            <div class="alert alert-danger" role="alert">Thanh toán thất bại. Vui lòng thử lại sau.</div>
        </c:if>
        <div class="row">
            <div class="col-md-7">
                <form method="post" action="${pageContext.request.contextPath}/checkout">
                    <div class="billing-address">
                        <h2>Thông tin thanh toán</h2>
                        <div class="row">
                            <div class="col-md-6">
                                <label>Họ tên</label>
                                <input class="form-control" type="text" name="fullName" placeholder="Họ tên" required>
                            </div>
                            <div class="col-md-6">
                                <label>Số điện thoại</label>
                                <input class="form-control" type="text" name="phone" placeholder="Số điện thoại" required>
                            </div>
                            <div class="col-md-6">
                                <label>E-mail</label>
                                <input class="form-control" type="email" name="email" placeholder="E-mail" required>
                            </div>
                            <div class="col-md-6">
                                <label>Địa chỉ</label>
                                <input class="form-control" type="text" name="address" placeholder="Địa chỉ" required>
                            </div>
                            <div class="col-md-6">
                                <label>Thành phố</label>
                                <input class="form-control" type="text" name="city" placeholder="Thành phố">
                            </div>
                            <div class="col-md-6">
                                <label>Tỉnh/Quận</label>
                                <input class="form-control" type="text" name="state" placeholder="Tỉnh/Quận">
                            </div>
                            <div class="col-md-6">
                                <label>Mã bưu điện</label>
                                <input class="form-control" type="text" name="zip" placeholder="Mã bưu điện">
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
                        <c:forEach var="ci" items="${cartItems}">
                            <c:set var="lineTotal" value="${ci.product.basePrice * ci.quantity}"/>
                            <p>
                                ${ci.product.name} x ${ci.quantity}
                                <span><fmt:formatNumber value="${lineTotal}" type="number" groupingUsed="true"/> đ</span>
                            </p>
                        </c:forEach>
                        <p class="sub-total">Tạm tính<span><fmt:formatNumber value="${subTotal}" type="number" groupingUsed="true"/> đ</span></p>
                        <p class="ship-cost">Phí vận chuyển<span>0đ</span></p>
                        <h4>Tổng cộng<span><fmt:formatNumber value="${subTotal}" type="number" groupingUsed="true"/> đ</span></h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Checkout End -->

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
