<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Đơn hàng</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3>Đơn hàng</h3>
    </div>
    <div class="card">
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-striped">
              <thead>
              <tr>
                  <th>Mã đơn hàng</th>
                  <th>Người dùng</th>
                  <th>Ngày đặt</th>
                  <th>Tổng tiền</th>
                  <th>Trạng thái</th>
                  <th>Thao tác</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="o" items="${orders}">
                  <tr>
                      <td>${o.id}</td>
                      <td>${o.user.username}</td>
                      <td>${o.orderDate}</td>
                      <td>${o.totalAmount}</td>
                      <td><ui:orderStatusText value="${o.status}" /></td>
                      <td>
                          <div class="btn-group" role="group">
                            <a href="${pageContext.request.contextPath}/admin/orders/print?id=${o.id}" class="btn btn-sm btn-outline-dark" title="In đơn hàng">
                              <i class="fa fa-print"></i> In
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/admin/orders/action" class="d-inline">
                                <input type="hidden" name="orderId" value="${o.id}">
                                <button name="action" value="confirm" class="btn btn-sm btn-primary">Xác nhận</button>
                                <button name="action" value="ship" class="btn btn-sm btn-info">Giao hàng</button>
                                <button name="action" value="deliver" class="btn btn-sm btn-success">Đã giao</button>
                                <button name="action" value="cancel" class="btn btn-sm btn-warning">Hủy</button>
                                <button name="action" value="refund" class="btn btn-sm btn-secondary">Hoàn tiền</button>
                            </form>
                          </div>
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
