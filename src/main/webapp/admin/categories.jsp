<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Danh mục</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Danh mục</h3>
        <a href="${pageContext.request.contextPath}/admin/categories/new" class="btn btn-primary">Thêm danh mục</a>
    </div>
    <div class="card">
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-striped table-hover align-middle">
              <thead><tr><th>ID</th><th>Tên</th><th>Slug</th><th>Kích hoạt</th><th>Thao tác</th></tr></thead>
              <tbody>
              <c:forEach var="c" items="${categories}">
                  <tr>
                      <td>${c.id}</td>
                      <td>${c.name}</td>
                      <td>${c.slug}</td>
                      <td><c:choose><c:when test="${c.active}">Có</c:when><c:otherwise>Không</c:otherwise></c:choose></td>
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
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>
