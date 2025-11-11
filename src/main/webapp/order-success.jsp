<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt hàng thành công</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="alert alert-success">
                <h4 class="alert-heading">Cảm ơn! Đơn hàng của bạn đã được đặt thành công.</h4>
                <p>Mã đơn hàng: <strong>#${orderId}</strong></p>
                <p>Tổng tiền: <strong><fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</strong></p>
                <p>Ngày: <strong>${orderDate}</strong></p>
                <c:if test="${not empty address}">
                    <p>Địa chỉ giao hàng: <strong>${address}</strong></p>
                </c:if>
                <hr>
                <c:url var="ordersUrl" value="/orders"/>
                <a class="btn btn-primary" href="${ordersUrl}">Xem đơn hàng</a>
                <c:url var="homeUrl" value="/index"/>
                <a class="btn btn-outline-secondary" href="${homeUrl}">Về trang chủ</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
