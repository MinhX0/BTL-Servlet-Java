<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
    if (!user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/index");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Báo cáo - Quản trị</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <div class="d-flex align-items-center justify-content-between mb-3">
      <h3 class="mb-0">Báo cáo tổng quan năm ${year}</h3>
      <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin/reports">
        <input class="form-control form-control-sm me-2" type="number" name="year" min="2000" max="2100" value="${year}">
        <button class="btn btn-sm btn-primary" type="submit">Xem</button>
      </form>
    </div>

    <div class="row g-3">
      <div class="col-lg-8">
        <div class="card">
          <div class="card-header">Doanh thu theo tháng</div>
          <div class="card-body">
            <canvas id="chartRevenue" height="120"></canvas>
          </div>
        </div>
      </div>
      <div class="col-lg-4">
        <div class="card">
          <div class="card-header">Số đơn theo tháng</div>
          <div class="card-body">
            <canvas id="chartOrders" height="120"></canvas>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-3 mt-1">
      <div class="col-12">
        <div class="card">
          <div class="card-header">Top 10 sản phẩm theo doanh thu</div>
          <div class="card-body table-responsive">
            <table class="table table-sm align-middle">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Tên sản phẩm</th>
                  <th class="text-end">Số lượng</th>
                  <th class="text-end">Doanh thu</th>
                </tr>
              </thead>
              <tbody>
              <c:forEach var="row" items="${topProducts}" varStatus="s">
                <tr>
                  <td>${s.index + 1}</td>
                  <td>${row.name}</td>
                  <td class="text-end">${row.qty}</td>
                  <td class="text-end" data-revenue="${row.revenue}"></td>
                </tr>
              </c:forEach>
              <c:if test="${empty topProducts}">
                <tr><td colspan="4" class="text-center text-muted">Không có dữ liệu</td></tr>
              </c:if>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script>
  const MONTHS = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];
</script>
<script>
  // Serialize arrays from server attributes into JS
  (function(){
    const rev = [
      ${revenueByMonth[0]}, ${revenueByMonth[1]}, ${revenueByMonth[2]}, ${revenueByMonth[3]}, ${revenueByMonth[4]}, ${revenueByMonth[5]},
      ${revenueByMonth[6]}, ${revenueByMonth[7]}, ${revenueByMonth[8]}, ${revenueByMonth[9]}, ${revenueByMonth[10]}, ${revenueByMonth[11]}
    ];
    const cnt = [
      ${countByMonth[0]}, ${countByMonth[1]}, ${countByMonth[2]}, ${countByMonth[3]}, ${countByMonth[4]}, ${countByMonth[5]},
      ${countByMonth[6]}, ${countByMonth[7]}, ${countByMonth[8]}, ${countByMonth[9]}, ${countByMonth[10]}, ${countByMonth[11]}
    ];

    // Chart: Revenue
    const ctx1 = document.getElementById('chartRevenue');
    if (ctx1) {
      new Chart(ctx1, {
        type: 'line',
        data: {
          labels: MONTHS,
          datasets: [{
            label: 'Doanh thu (VNĐ)',
            data: rev,
            borderColor: 'rgba(54,162,235,1)',
            backgroundColor: 'rgba(54,162,235,.2)',
            tension: .25,
            fill: true
          }]
        },
        options: { scales: { y: { beginAtZero: true } } }
      });
    }

    // Chart: Orders count
    const ctx2 = document.getElementById('chartOrders');
    if (ctx2) {
      new Chart(ctx2, {
        type: 'bar',
        data: {
          labels: MONTHS,
          datasets: [{
            label: 'Số đơn',
            data: cnt,
            backgroundColor: 'rgba(255,99,132,.5)',
            borderColor: 'rgba(255,99,132,1)'
          }]
        },
        options: { scales: { y: { beginAtZero: true } } }
      });
    }

    // Format currency cells
    document.querySelectorAll('[data-revenue]').forEach(td => {
      const v = td.getAttribute('data-revenue');
      try {
        const num = Number(v);
        td.textContent = new Intl.NumberFormat('vi-VN').format(num) + ' đ';
      } catch (e) {
        td.textContent = v;
      }
    });
  })();
</script>
</body>
</html>
