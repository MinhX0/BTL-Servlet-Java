<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Users</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Users</h3>
        <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin/users">
            <select class="form-select me-2" name="role">
                <option value="">All Roles</option>
                <option value="CUSTOMER">Customer</option>
                <option value="SELLER">Seller</option>
                <option value="ADMIN">Admin</option>
            </select>
            <select class="form-select me-2" name="active">
                <option value="">All</option>
                <option value="1">Active</option>
                <option value="0">Inactive</option>
            </select>
            <button class="btn btn-outline-primary" type="submit">Filter</button>
        </form>
    </div>

    <table class="table table-striped align-middle">
        <thead>
        <tr>
            <th>ID</th><th>Username</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.id}</td>
                <td>${u.username}</td>
                <td>${u.name}</td>
                <td>${u.email}</td>
                <td>${u.role}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.active}"><span class="badge bg-success">Active</span></c:when>
                        <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/action" class="d-inline">
                        <input type="hidden" name="userId" value="${u.id}">
                        <c:choose>
                            <c:when test="${u.active}">
                                <button name="action" value="deactivate" class="btn btn-sm btn-warning">Deactivate</button>
                            </c:when>
                            <c:otherwise>
                                <button name="action" value="activate" class="btn btn-sm btn-success">Activate</button>
                            </c:otherwise>
                        </c:choose>
                        <button name="action" value="delete" class="btn btn-sm btn-danger" onclick="return confirm('Delete this user?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>

