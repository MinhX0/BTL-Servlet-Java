<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Thêm sản phẩm</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <h3>Thêm sản phẩm</h3>
    <div class="card mt-3">
      <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/admin/products/new">
            <div class="mb-3">
                <label class="form-label">Tên</label>
                <input type="text" name="name" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mô tả</label>
                <textarea name="description" class="form-control" rows="3"></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Ảnh chính (URL)</label>
                <input type="text" name="mainImageUrl" class="form-control">
            </div>
            <div class="mb-3">
                <label class="form-label">Giá gốc (VND)</label>
                <input type="number" step="1" min="0" name="basePrice" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Danh mục</label>
                <select name="categoryId" class="form-select" required>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Hủy</a>
        </form>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>
