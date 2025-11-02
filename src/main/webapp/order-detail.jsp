<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi tiết đơn hàng</title>
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
                                <h5 class="mb-0">Đơn hàng #${order.id}</h5>
                                <small class="text-muted">Ngày đặt ${order.orderDate}</small>
                            </div>
                            <span class="badge badge-info">${order.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6>Thanh toán</h6>
                                    <p class="mb-1"><strong>Họ tên:</strong> ${fn:escapeXml(sessionScope.name)}</p>
                                    <p class="mb-1"><strong>Email:</strong> ${fn:escapeXml(sessionScope.user.email)}</p>
                                    <c:if test="${not empty sessionScope.user.phoneNumber}">
                                        <p class="mb-1"><strong>Số điện thoại:</strong> ${fn:escapeXml(sessionScope.user.phoneNumber)}</p>
                                    </c:if>
                                    <c:if test="${not empty sessionScope.user.address}">
                                        <p class="mb-1"><strong>Địa chỉ:</strong> ${fn:escapeXml(sessionScope.user.address)}</p>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <h6>Tổng quan</h6>
                                    <p class="mb-1"><strong>Tổng tiền:</strong> ${order.totalAmount}</p>
                                    <p class="mb-1"><strong>Số lượng sản phẩm:</strong> <c:out value="${fn:length(items)}"/></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead class="thead-light">
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Giá</th>
                                <th>SL</th>
                                <th>Tạm tính</th>
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
                        <a class="btn btn-outline-secondary" href="${ordersUrl}">Về danh sách đơn hàng</a>
                        <c:url var="homeUrl" value="/index"/>
                        <a class="btn btn-primary" href="${homeUrl}">Tiếp tục mua sắm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger">Không tìm thấy đơn hàng.</div>
                    <c:url var="ordersUrl" value="/orders"/>
                    <a class="btn btn-outline-secondary" href="${ordersUrl}">Về danh sách đơn hàng</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
