<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
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
                    <c:set var="u" value="${sessionScope.user}"/>
                    <div class="card mb-3">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-0">Đơn hàng #${order.id}</h5>
                                <small class="text-muted">Ngày đặt ${orderDateStr}</small>
                            </div>
                            <span class="badge badge-info"><ui:orderStatusText value="${order.status}" /></span>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6>Thông tin người nhận</h6>
                                    <p class="mb-1"><strong>Họ tên:</strong>
                                        <c:choose>
                                            <c:when test="${not empty u and not empty u.name}">${fn:escapeXml(u.name)}</c:when>
                                            <c:when test="${not empty sessionScope.name}">${fn:escapeXml(sessionScope.name)}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="mb-1"><strong>Email:</strong>
                                        <c:choose>
                                            <c:when test="${not empty u and not empty u.email}">${fn:escapeXml(u.email)}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <c:if test="${not empty u and not empty u.phoneNumber}">
                                        <p class="mb-1"><strong>Số điện thoại:</strong> ${fn:escapeXml(u.phoneNumber)}</p>
                                    </c:if>
                                    <p class="mb-1"><strong>Địa chỉ:</strong>
                                        <c:choose>
                                            <c:when test="${not empty order.address}">${fn:escapeXml(order.address)}</c:when>
                                            <c:when test="${not empty u and not empty u.address}">${fn:escapeXml(u.address)}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <h6>Tổng quan</h6>
                                    <p class="mb-1"><strong>Tổng tiền:</strong>
                                        <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> đ
                                    </p>
                                    <p class="mb-1"><strong>Số lượng sản phẩm:</strong>
                                        <c:out value="${fn:length(items)}"/>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead class="thead-light">
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Kích cỡ</th>
                                <th>Giá</th>
                                <th>SL</th>
                                <th>Tạm tính</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty items}">
                                    <c:forEach var="it" items="${items}">
                                        <tr>
                                            <td>
                                                <c:url var="detailUrl" value="/product-detail">
                                                    <c:param name="id" value="${it.product.id}"/>
                                                </c:url>
                                                <a href="${detailUrl}">${it.product.name}</a>
                                            </td>
                                            <td>${empty it.itemSize ? '-' : it.itemSize}</td>
                                            <td><fmt:formatNumber value="${it.priceAtPurchase}" type="number" groupingUsed="true"/> đ</td>
                                            <td>${it.quantity}</td>
                                            <td><fmt:formatNumber value="${it.priceAtPurchase * it.quantity}" type="number" groupingUsed="true"/> đ</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">Đơn hàng chưa có sản phẩm.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
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
