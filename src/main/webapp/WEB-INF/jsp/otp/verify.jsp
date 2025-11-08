<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <title>Xác thực OTP</title>
  <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
  <style>
    .otp-card { max-width: 440px; margin: 0 auto; }
    .otp-card .card { border-radius: 8px; }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<!-- Breadcrumb Start -->
<div class="breadcrumb-wrap">
  <div class="container">
    <ul class="breadcrumb">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index">Trang chủ</a></li>
      <li class="breadcrumb-item active">Xác thực OTP</li>
    </ul>
  </div>
</div>
<!-- Breadcrumb End -->

<div class="content">
  <div class="container py-4">
    <div class="otp-card">
      <div class="card shadow-sm">
        <div class="card-body p-4">
          <h4 class="mb-3">Nhập mã OTP</h4>
          <c:if test="${not empty otpError}">
            <div class="alert alert-danger" role="alert">${otpError}</div>
          </c:if>
          <c:url var="verifyAction" value="/verify-otp"/>
          <form id="otpForm" method="post" action="${verifyAction}" novalidate>
            <input type="hidden" name="purpose" value="${param.purpose != null ? param.purpose : 'REGISTER'}" />
            <div class="form-group mb-3">
              <label class="form-label" for="otpCode">Mã OTP</label>
              <input class="form-control" id="otpCode" type="text" name="code" maxlength="6" required pattern="[0-9]{6}" inputmode="numeric" autocomplete="one-time-code" placeholder="Nhập 6 chữ số" />
              <small class="form-text text-muted">Vui lòng nhập đúng 6 chữ số được gửi tới email của bạn.</small>
            </div>
            <div class="d-flex justify-content-between align-items-center">
              <c:url var="homeUrl" value="/index"/>
              <a class="btn btn-outline-secondary" href="${homeUrl}">Hủy</a>
              <button class="btn btn-primary" type="submit">Xác nhận</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
<script>
(function(){
  const input = document.getElementById('otpCode');
  const form = document.getElementById('otpForm');
  if (input) {
    input.addEventListener('input', () => {
      // keep only digits
      input.value = input.value.replace(/\D+/g,'');
    });
  }
  if (form) {
    form.addEventListener('submit', (e) => {
      if (!input) return;
      input.value = input.value.trim();
      if(!/^[0-9]{6}$/.test(input.value)){
        e.preventDefault();
        input.classList.add('is-invalid');
        // Add feedback if not present
        if(!input.nextElementSibling || !input.nextElementSibling.classList.contains('invalid-feedback')){
          const fb = document.createElement('div');
          fb.className='invalid-feedback';
          fb.textContent='Mã OTP phải gồm đúng 6 chữ số.';
          input.parentNode.appendChild(fb);
        }
        input.focus();
      } else {
        input.classList.remove('is-invalid');
      }
    });
  }
})();
</script>
</body>
</html>
