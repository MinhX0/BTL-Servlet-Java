<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Categories</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Categories</h3>
        <a href="${pageContext.request.contextPath}/admin/categories/new" class="btn btn-primary">Add Category</a>
    </div>
    <table class="table table-striped">
        <thead><tr><th>ID</th><th>Name</th><th>Slug</th><th>Active</th></tr></thead>
        <tbody>
        <c:forEach var="c" items="${categories}">
            <tr>
                <td>${c.id}</td>
                <td>${c.name}</td>
                <td>${c.slug}</td>
                <td><c:choose><c:when test="${c.active}">Yes</c:when><c:otherwise>No</c:otherwise></c:choose></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>

