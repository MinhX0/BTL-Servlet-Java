<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - New Product</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="container mt-4">
    <h3>Create Product</h3>
    <form method="post" action="${pageContext.request.contextPath}/admin/products/new">
        <div class="mb-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea name="description" class="form-control" rows="3"></textarea>
        </div>
        <div class="mb-3">
            <label class="form-label">Main Image URL</label>
            <input type="text" name="mainImageUrl" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">Base Price</label>
            <input type="number" step="0.01" name="basePrice" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Category</label>
            <select name="categoryId" class="form-select" required>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.id}">${c.name}</option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-success">Save</button>
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Cancel</a>
    </form>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>

