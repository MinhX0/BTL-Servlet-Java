<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Orders</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="container mt-4">
    <h3>Orders</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>ID</th><th>User</th><th>Date</th><th>Total</th><th>Status</th><th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="o" items="${orders}">
            <tr>
                <td>${o.id}</td>
                <td>${o.user.username}</td>
                <td>${o.orderDate}</td>
                <td>${o.totalAmount}</td>
                <td>${o.status}</td>
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/admin/orders/action" class="d-inline">
                        <input type="hidden" name="orderId" value="${o.id}">
                        <button name="action" value="confirm" class="btn btn-sm btn-success">Confirm</button>
                        <button name="action" value="ship" class="btn btn-sm btn-primary">Ship</button>
                        <button name="action" value="deliver" class="btn btn-sm btn-info">Deliver</button>
                        <button name="action" value="cancel" class="btn btn-sm btn-warning">Cancel</button>
                        <button name="action" value="refund" class="btn btn-sm btn-danger">Refund</button>
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

