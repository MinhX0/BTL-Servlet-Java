        </div>
    </div>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Sản phẩm</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3>Sản phẩm</h3>
            <a href="${pageContext.request.contextPath}/admin/products/new" class="btn btn-primary">Thêm sản phẩm</a>
        </div>
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                        <thead><tr><th>ID</th><th>Tên</th><th>Giá</th><th>Danh mục</th><th>Thao tác</th></tr></thead>
                        <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>${p.id}</td>
                                <td>${p.name}</td>
                                <td><fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true"/> đ</td>
                                <td>${p.category.name}</td>
                                <td>
                                    <a class="btn btn-sm btn-outline-secondary disabled" href="#" title="Sửa (sắp có)">Sửa</a>
                                    <a class="btn btn-sm btn-outline-danger disabled" href="#" title="Xóa (sắp có)">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
