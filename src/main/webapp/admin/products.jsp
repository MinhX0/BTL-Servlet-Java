</div>
    </div>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                <c:if test="${param.deleted == '1'}">
                  <div class="alert alert-success">Đã xóa (ẩn) sản phẩm.</div>
                </c:if>
                <c:if test="${param.deleted == '0'}">
                  <div class="alert alert-danger">Không thể xóa sản phẩm.</div>
                </c:if>
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                        <thead><tr><th>ID</th><th>Tên</th><th>Giá</th><th>Danh mục</th><th>Thao tác</th></tr></thead>
                        <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>${p.id}</td>
                                <td>${p.name}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.salePrice && p.salePrice > 0 && p.basePrice > p.salePrice}">
                                            <span class="text-decoration-line-through text-muted"><fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</span>
                                            <br/>
                                            <strong><fmt:formatNumber value="${p.salePrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</strong>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${p.category.name}</td>
                                <td>
                                    <c:url var="editUrl" value="/admin/products/edit">
                                        <c:param name="id" value="${p.id}"/>
                                    </c:url>
                                    <a class="btn btn-sm btn-outline-secondary" href="${editUrl}">Sửa</a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/products/delete" class="d-inline" onsubmit="return confirm('Ẩn (xóa mềm) sản phẩm này?');">
                                      <input type="hidden" name="id" value="${p.id}" />
                                      <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
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
