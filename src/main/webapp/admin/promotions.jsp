<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Khuyến mãi</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3>Quản lý Khuyến mãi</h3>
            <a href="${pageContext.request.contextPath}/admin/promotions/create" class="btn btn-primary">Tạo khuyến mãi mới</a>
        </div>
        <div class="card">
            <div class="card-body">
                <c:if test="${param.success == '1'}">
                    <div class="alert alert-success">Thao tác thành công!</div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger">${param.error}</div>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên</th>
                                <th>Loại giảm giá</th>
                                <th>Giá trị</th>
                                <th>ĐH tối thiểu</th>
                                <th>Thời gian</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="promo" items="${promotions}">
                                <tr>
                                    <td>${promo.id}</td>
                                    <td>
                                        <strong>${promo.name}</strong>
                                        <c:if test="${not empty promo.description}">
                                            <br><small class="text-muted">${promo.description}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${promo.discountType == 'PERCENTAGE'}">
                                                <span class="badge bg-info">Phần trăm</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">Số tiền cố định</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${promo.discountType == 'PERCENTAGE'}">
                                                <fmt:formatNumber value="${promo.discountValue}" maxFractionDigits="0"/>%
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${promo.discountValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${promo.minOrderAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                    </td>
                                    <td>
                                        <small>
                                            <fmt:formatDate value="${promo.startDateAsDate}" pattern="dd/MM/yyyy HH:mm"/><br>
                                            đến<br>
                                            <fmt:formatDate value="${promo.endDateAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${promo.currentlyValid}">
                                                <span class="badge bg-success">Đang hoạt động</span>
                                            </c:when>
                                            <c:when test="${promo.active}">
                                                <span class="badge bg-secondary">Đã lên lịch</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:url var="editUrl" value="/admin/promotions/edit">
                                            <c:param name="id" value="${promo.id}"/>
                                        </c:url>
                                        <a class="btn btn-sm btn-outline-secondary" href="${editUrl}">Sửa</a>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/promotions/delete"
                                              class="d-inline"
                                              onsubmit="return confirm('Bạn có chắc muốn xóa khuyến mãi này?');">
                                            <input type="hidden" name="id" value="${promo.id}" />
                                            <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty promotions}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted">
                                        Chưa có khuyến mãi nào. <a href="${pageContext.request.contextPath}/admin/promotions/create">Tạo khuyến mãi mới</a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>
