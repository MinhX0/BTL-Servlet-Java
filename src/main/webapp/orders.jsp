<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đơn hàng của tôi</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="container mt-4">
    <h3>Đơn hàng của tôi</h3>
    <c:choose>
        <c:when test="${not empty orders}">
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>${o.id}</td>
                            <td>${o.orderDate}</td>
                            <td>${o.totalAmount}</td>
                            <td><ui:orderStatusText value="${o.status}" /></td>
                            <td>
                                <c:url var="detailUrl" value="/orders/detail">
                                    <c:param name="orderId" value="${o.id}"/>
                                </c:url>
                                <a class="btn btn-sm btn-outline-primary" href="${detailUrl}">Xem</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
