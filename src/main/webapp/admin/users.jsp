<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Người dùng</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Người dùng</h3>
        <form class="row g-2" method="get" action="${pageContext.request.contextPath}/admin/users">
            <div class="col-auto">
                <select class="form-select" name="role">
                    <option value="">Tất cả vai trò</option>
                    <option value="CUSTOMER">Khách hàng</option>
                    <option value="ADMIN">Quản trị</option>
                </select>
            </div>
            <div class="col-auto">
                <select class="form-select" name="active">
                    <option value="">Tất cả</option>
                    <option value="1">Hoạt động</option>
                    <option value="0">Tạm khóa</option>
                </select>
            </div>
            <div class="col-auto">
                <button class="btn btn-outline-primary" type="submit">Lọc</button>
            </div>
        </form>
    </div>

    <div class="card">
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-striped align-middle">
              <thead>
              <tr>
                  <th>ID</th><th>Tên đăng nhập</th><th>Họ tên</th><th>Email</th><th>Vai trò</th><th>Trạng thái</th><th>Hành động</th>
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
                              <c:when test="${u.active}"><span class="badge bg-success">Hoạt động</span></c:when>
                              <c:otherwise><span class="badge bg-secondary">Tạm khóa</span></c:otherwise>
                          </c:choose>
                      </td>
                      <td>
                          <form method="post" action="${pageContext.request.contextPath}/admin/users/action" class="d-inline">
                              <input type="hidden" name="userId" value="${u.id}">
                              <c:choose>
                                  <c:when test="${u.active}">
                                      <button name="action" value="deactivate" class="btn btn-sm btn-warning">Khóa</button>
                                  </c:when>
                                  <c:otherwise>
                                      <button name="action" value="activate" class="btn btn-sm btn-success">Mở</button>
                                  </c:otherwise>
                              </c:choose>
                              <button name="action" value="delete" class="btn btn-sm btn-danger" onclick="return confirm('Xóa người dùng này?')">Xóa</button>
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
