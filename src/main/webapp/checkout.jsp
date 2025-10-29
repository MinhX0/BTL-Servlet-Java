<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>E Shop - Checkout</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Checkout Start -->
<div class="checkout">
    <div class="container">
        <div class="row">
            <div class="col-md-7">
                <form method="post" action="${pageContext.request.contextPath}/checkout">
                    <div class="billing-address">
                        <h2>Billing Address</h2>
                        <div class="row">
                            <div class="col-md-6">
                                <label>Full Name</label>
                                <input class="form-control" type="text" name="fullName" placeholder="Your Name" required>
                            </div>
                            <div class="col-md-6">
                                <label>Phone Number</label>
                                <input class="form-control" type="text" name="phone" placeholder="Phone Number" required>
                            </div>
                            <div class="col-md-6">
                                <label>E-mail</label>
                                <input class="form-control" type="email" name="email" placeholder="E-mail" required>
                            </div>
                            <div class="col-md-6">
                                <label>Address</label>
                                <input class="form-control" type="text" name="address" placeholder="Address" required>
                            </div>
                            <div class="col-md-6">
                                <label>City</label>
                                <input class="form-control" type="text" name="city" placeholder="City">
                            </div>
                            <div class="col-md-6">
                                <label>State</label>
                                <input class="form-control" type="text" name="state" placeholder="State">
                            </div>
                            <div class="col-md-6">
                                <label>ZIP Code</label>
                                <input class="form-control" type="text" name="zip" placeholder="ZIP Code">
                            </div>
                        </div>
                    </div>

                    <div class="checkout-payment">
                        <h2>Payment Methods</h2>
                        <div class="payment-methods">
                            <div class="payment-method">
                                <div class="custom-control custom-radio">
                                    <input type="radio" class="custom-control-input" id="payment-1" name="payment" value="VNPAY" checked>
                                    <label class="custom-control-label" for="payment-1">VNPAY</label>
                                </div>
                            </div>
                            <div class="payment-method">
                                <div class="custom-control custom-radio">
                                    <input type="radio" class="custom-control-input" id="payment-2" name="payment" value="COD">
                                    <label class="custom-control-label" for="payment-2">Cash on Delivery</label>
                                </div>
                            </div>
                        </div>
                        <div class="checkout-btn">
                            <button type="submit">Place Order</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="col-md-5">
                <div class="checkout-summary">
                    <h2>Cart Total</h2>
                    <div class="checkout-content">
                        <h3>Products</h3>
                        <c:forEach var="ci" items="${cartItems}">
                            <p>
                                ${ci.variant.product.name} x ${ci.quantity}
                                <span>${ci.variant.finalVariantPrice * ci.quantity}</span>
                            </p>
                        </c:forEach>
                        <p class="sub-total">Sub Total<span>${subTotal}</span></p>
                        <p class="ship-cost">Shipping Cost<span>$0</span></p>
                        <h4>Grand Total<span>${subTotal}</span></h4>
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
