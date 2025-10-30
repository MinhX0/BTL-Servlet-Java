<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order Detail</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-12">
            <c:choose>
                <c:when test="${not empty order}">
                    <div class="card mb-3">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-0">Order #${order.id}</h5>
                                <small class="text-muted">Placed on ${order.orderDate}</small>
                            </div>
                            <span class="badge badge-info">${order.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6>Billing</h6>
                                    <p class="mb-1"><strong>Name:</strong> ${fn:escapeXml(sessionScope.name)}</p>
                                    <p class="mb-1"><strong>Email:</strong> ${fn:escapeXml(sessionScope.user.email)}</p>
                                    <c:if test="${not empty sessionScope.user.phoneNumber}">
                                        <p class="mb-1"><strong>Phone:</strong> ${fn:escapeXml(sessionScope.user.phoneNumber)}</p>
                                    </c:if>
                                    <c:if test="${not empty sessionScope.user.address}">
                                        <p class="mb-1"><strong>Address:</strong> ${fn:escapeXml(sessionScope.user.address)}</p>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <h6>Summary</h6>
                                    <p class="mb-1"><strong>Total Amount:</strong> ${order.totalAmount}</p>
                                    <p class="mb-1"><strong>Items:</strong> <c:out value="${fn:length(items)}"/></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead class="thead-light">
                            <tr>
                                <th>Product</th>
                                <th>Price</th>
                                <th>Qty</th>
                                <th>Line Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="it" items="${items}">
                                <tr>
                                    <td>
                                        <c:url var="detailUrl" value="/product-detail.jsp">
                                            <c:param name="id" value="${it.product.id}"/>
                                        </c:url>
                                        <a href="${detailUrl}">${it.product.name}</a>
                                    </td>
                                    <td>${it.priceAtPurchase}</td>
                                    <td>${it.quantity}</td>
                                    <td>${it.priceAtPurchase * it.quantity}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-between">
                        <c:url var="ordersUrl" value="/orders"/>
                        <a class="btn btn-outline-secondary" href="${ordersUrl}">Back to Orders</a>
                        <c:url var="homeUrl" value="/index"/>
                        <a class="btn btn-primary" href="${homeUrl}">Continue Shopping</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger">Order not found.</div>
                    <c:url var="ordersUrl" value="/orders"/>
                    <a class="btn btn-outline-secondary" href="${ordersUrl}">Back to Orders</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>

