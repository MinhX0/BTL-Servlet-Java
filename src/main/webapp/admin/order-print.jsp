<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>In đơn hàng #${order.id}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background: #f6f7fb; }
    .invoice-box { max-width: 980px; margin: 24px auto; padding: 24px; border: 1px solid #e5e7eb; background: #fff; }
    .invoice-header { display: flex; justify-content: space-between; align-items: center; }
    .brand { font-weight: 700; font-size: 1.25rem; }
    .meta small { color: #6c757d; }
    .table th, .table td { vertical-align: middle; }
    @media print {
      .no-print { display: none !important; }
      body { background: #fff; }
      .invoice-box { border: none; box-shadow: none; margin: 0; padding: 0; }
    }
  </style>
</head>
<body>
<div class="invoice-box">
  <div class="d-flex justify-content-between align-items-start mb-3">
    <div>
      <div class="brand">Anh em cay khe Corporation</div>
      <div class="text-muted">Chuyên bán dép nữ cao cấp</div>
    </div>
    <div class="text-end meta">
      <div><strong>Đơn hàng:</strong> #${order.id}</div>
      <div><strong>Ngày đặt:</strong> ${order.orderDate}</div>
      <div><strong>Trạng thái:</strong> ${order.status}</div>
    </div>
  </div>

  <div class="row mb-3">
    <div class="col-6">
      <h6>Khách hàng</h6>
      <div>${order.user.name}</div>
      <div>Email: ${order.user.email}</div>
      <c:if test="${not empty order.user.phoneNumber}"><div>Điện thoại: ${order.user.phoneNumber}</div></c:if>
      <c:if test="${not empty order.address}"><div>Địa chỉ giao: ${order.address}</div></c:if>
    </div>
    <div class="col-6 text-end">
      <h6>Cửa hàng</h6>
      <div>Anh em cay khe Corporation</div>
      <div>support@example.com</div>
      <div>+84 123 456 789</div>
    </div>
  </div>

  <div class="table-responsive">
    <table class="table table-bordered">
      <thead class="table-light">
      <tr>
        <th>#</th>
        <th>Sản phẩm</th>
        <th>Kích cỡ</th>
        <th class="text-end">Đơn giá</th>
        <th class="text-end">Số lượng</th>
        <th class="text-end">Thành tiền</th>
      </tr>
      </thead>
      <tbody>
      <c:set var="sum" value="0"/>
      <c:forEach var="it" items="${items}" varStatus="s">
        <c:set var="unit" value="${it.priceAtPurchase}"/>
        <c:set var="line" value="${unit * it.quantity}"/>
        <tr>
          <td>${s.index + 1}</td>
          <td>${it.product.name}</td>
          <td>${empty it.itemSize ? '-' : it.itemSize}</td>
          <td class="text-end"><fmt:formatNumber value="${unit}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</td>
          <td class="text-end">${it.quantity}</td>
          <td class="text-end"><fmt:formatNumber value="${line}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</td>
        </tr>
        <c:set var="sum" value="${sum + line}"/>
      </c:forEach>
      </tbody>
      <tfoot>
      <tr>
        <th colspan="5" class="text-end">Tổng cộng</th>
        <th class="text-end"><fmt:formatNumber value="${sum}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0"/> đ</th>
      </tr>
      </tfoot>
    </table>
  </div>

  <div class="d-flex justify-content-between mt-3">
    <a class="btn btn-secondary no-print" href="${pageContext.request.contextPath}/admin/orders">Quay lại</a>
    <button class="btn btn-primary no-print" onclick="window.print()">In</button>
  </div>
</div>
</body>
</html>
