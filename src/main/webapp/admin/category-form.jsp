<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Thêm danh mục</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <h3>Thêm danh mục</h3>
    <div class="card mt-3">
      <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/admin/categories/new">
            <div class="mb-3">
                <label class="form-label">Tên</label>
                <input type="text" name="name" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Slug</label>
                <input type="text" name="slug" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">ID danh mục cha (tùy chọn)</label>
                <input type="number" name="parentId" class="form-control">
            </div>
            <button type="submit" class="btn btn-success">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary">Hủy</a>
        </form>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>
