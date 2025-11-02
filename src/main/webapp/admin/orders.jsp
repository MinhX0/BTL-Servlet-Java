<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Đơn hàng</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="container mt-4">
    <h3>Đơn hàng</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Mã đơn hàng</th>
            <th>Người dùng</th>
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
                <td>${o.user.username}</td>
                <td>${o.orderDate}</td>
                <td>${o.totalAmount}</td>
                <td><ui:orderStatusText value="${o.status}" /></td>
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/admin/orders/action" class="d-inline">
                        <input type="hidden" name="orderId" value="${o.id}">
                        <button name="action" value="confirm" class="btn btn-sm btn-primary">Xác nhận</button>
                        <button name="action" value="ship" class="btn btn-sm btn-info">Giao hàng</button>
                        <button name="action" value="deliver" class="btn btn-sm btn-success">Đã giao</button>
                        <button name="action" value="cancel" class="btn btn-sm btn-warning">Hủy</button>
                        <button name="action" value="refund" class="btn btn-sm btn-secondary">Hoàn tiền</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
