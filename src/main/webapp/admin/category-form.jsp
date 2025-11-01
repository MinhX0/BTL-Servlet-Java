<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - New Category</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="container mt-4">
    <h3>Create Category</h3>
    <form method="post" action="${pageContext.request.contextPath}/admin/categories/new">
        <div class="mb-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Slug</label>
            <input type="text" name="slug" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Parent Category ID (optional)</label>
            <input type="number" name="parentId" class="form-control">
        </div>
        <button type="submit" class="btn btn-success">Save</button>
        <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary">Cancel</a>
    </form>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>

