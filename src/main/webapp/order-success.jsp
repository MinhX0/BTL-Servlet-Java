<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order Success</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="alert alert-success">
                <h4 class="alert-heading">Thank you! Your order was placed successfully.</h4>
                <p>Order ID: <strong>#${orderId}</strong></p>
                <p>Total Amount: <strong>${totalAmount}</strong></p>
                <p>Date: <strong>${orderDate}</strong></p>
                <c:if test="${not empty address}">
                    <p>Shipping Address: <strong>${address}</strong></p>
                </c:if>
                <hr>
                <c:url var="ordersUrl" value="/customer/orders.jsp"/>
                <a class="btn btn-primary" href="${ordersUrl}">View My Orders</a>
                <c:url var="homeUrl" value="/index"/>
                <a class="btn btn-outline-secondary" href="${homeUrl}">Back to Home</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
