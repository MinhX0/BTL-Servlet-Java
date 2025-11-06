<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <title>Xác thực OTP</title>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
</head>
<body class="bg-light">
<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-5">
      <div class="card">
        <div class="card-body">
          <h4 class="card-title mb-3">Nhập mã OTP</h4>
          <c:if test="${not empty otpError}">
            <div class="alert alert-danger">${otpError}</div>
          </c:if>
          <form method="post" action="${pageContext.request.contextPath}/verify-otp">
            <input type="hidden" name="purpose" value="${param.purpose != null ? param.purpose : 'REGISTER'}" />
            <div class="mb-3">
              <label class="form-label">Mã OTP</label>
              <input class="form-control" type="text" name="code" maxlength="6" required pattern="\\d{6}" placeholder="Nhập 6 chữ số" />
            </div>
            <div class="d-flex justify-content-between">
              <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/index">Hủy</a>
              <button class="btn btn-primary" type="submit">Xác nhận</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>

