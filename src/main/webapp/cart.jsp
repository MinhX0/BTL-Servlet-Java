<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>E Shop - Cart</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
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
                            <th>Image</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Remove</th>
                        </tr>
                        </thead>
                        <tbody class="align-middle">
                        <c:choose>
                            <c:when test="${not empty cartItems}">
                                <c:set var="subTotal" value="0"/>
                                <c:forEach var="ci" items="${cartItems}" varStatus="st">
                                    <c:set var="unitPrice" value="${ci.product.basePrice}"/>
                                    <c:set var="lineTotal" value="${unitPrice * ci.quantity}"/>
                                    <tr>
                                        <td>
                                            <c:set var="img" value="${empty ci.product.mainImageUrl ? '/assets/img/product-1.png' : ci.product.mainImageUrl}"/>
                                            <c:url var="imgUrl" value="${img}"/>
                                            <a href="#"><img src="${imgUrl}" alt="${fn:escapeXml(ci.product.name)}"></a>
                                        </td>
                                        <td>
                                            <c:url var="detailUrl" value="/product-detail.jsp">
                                                <c:param name="id" value="${ci.product.id}"/>
                                            </c:url>
                                            <a href="${detailUrl}">${ci.product.name}</a>
                                        </td>
                                        <td>${unitPrice}</td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/cart" class="d-inline">
                                                <input type="hidden" name="action" value="update"/>
                                                <input type="hidden" name="cartItemId" value="${ci.id}"/>
                                                <div class="qty">
                                                    <button type="button" class="btn-minus" onclick="var i=this.parentNode.querySelector('input[name=qty]'); if(i.value>1){i.value--}"><i class="fa fa-minus"></i></button>
                                                    <input type="text" name="qty" value="${ci.quantity}">
                                                    <button type="button" class="btn-plus" onclick="var i=this.parentNode.querySelector('input[name=qty]'); i.value++"><i class="fa fa-plus"></i></button>
                                                    <button type="submit" class="btn btn-sm btn-secondary ml-2">Update</button>
                                                </div>
                                            </form>
                                        </td>
                                        <td>${lineTotal}</td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/cart" onsubmit="return confirm('Remove this item?');">
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
                                <tr><td colspan="6" class="text-center text-muted">Your cart is empty.</td></tr>
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
                    <div class="coupon">
                        <input type="text" placeholder="Coupon Code" disabled>
                        <button disabled>Apply Code</button>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="cart-summary">
                        <div class="cart-content">
                            <h3>Cart Summary</h3>
                            <p>Sub Total<span>${subTotal}</span></p>
                            <p>Shipping Cost<span>$0</span></p>
                            <h4>Grand Total<span>${subTotal}</span></h4>
                        </div>
                        <div class="cart-btn">
                            <form method="post" action="${pageContext.request.contextPath}/cart" class="d-inline">
                                <input type="hidden" name="action" value="clear"/>
                                <button class="btn btn-outline-secondary" onclick="return confirm('Clear cart?');">Clear Cart</button>
                            </form>
                            <c:url var="checkoutUrl" value="/checkout"/>
                            <a class="btn btn-primary" href="${checkoutUrl}">Checkout</a>
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
