<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Orders</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="container mt-4">
    <h3>My Orders</h3>
    <c:choose>
        <c:when test="${not empty orders}">
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>${o.id}</td>
                            <td>${o.orderDate}</td>
                            <td>${o.status}</td>
                            <td>${o.totalAmount}</td>
                            <td>
                                <c:url var="detailUrl" value="/orders/detail">
                                    <c:param name="orderId" value="${o.id}"/>
                                </c:url>
                                <a class="btn btn-sm btn-outline-primary" href="${detailUrl}">View</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">You have no orders yet.</div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
