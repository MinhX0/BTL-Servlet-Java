<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tài khoản của tôi</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login.jsp#login"/>
</c:if>

<div class="breadcrumb-wrap">
    <div class="container">
        <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index">Trang chủ</a></li>
            <li class="breadcrumb-item active">Tài khoản của tôi</li>
        </ul>
    </div>
</div>

<div class="container py-5">
    <div class="row">
        <div class="col-md-4">
            <div class="sidebar-widget">
                <h2 class="title">Tài khoản</h2>
                <ul style="list-style:none; padding-left:0;">
                    <li class="mb-2">
                        <c:url var="ordersUrl" value="/orders"/>
                        <a href="${ordersUrl}"><i class="fa fa-list"></i> Đơn hàng của tôi</a>
                    </li>
                    <li class="mb-2">
                        <c:url var="cartUrl" value="/cart"/>
                        <a href="${cartUrl}"><i class="fa fa-shopping-cart"></i> Giỏ hàng của tôi</a>
                    </li>
                    <li class="mb-2">
                        <c:url var="logoutUrl" value="/logout"/>
                        <a href="${logoutUrl}"><i class="fa fa-sign-out"></i> Đăng xuất</a>
                    </li>
                </ul>
            </div>

            <div class="sidebar-widget">
                <h2 class="title">Tổng quan</h2>
                <div>
                    <p><strong>Họ tên:</strong> <c:out value="${sessionScope.user.name}" default="-"/></p>
                    <p><strong>Tên đăng nhập:</strong> <c:out value="${sessionScope.user.username}" default="-"/></p>
                    <p><strong>Email:</strong> <c:out value="${sessionScope.user.email}" default="-"/></p>
                    <c:if test="${not empty sessionScope.user.phoneNumber}">
                        <p><strong>Số điện thoại:</strong> <c:out value="${sessionScope.user.phoneNumber}"/></p>
                    </c:if>
                    <c:if test="${not empty sessionScope.user.address}">
                        <p><strong>Địa chỉ:</strong> <c:out value="${sessionScope.user.address}"/></p>
                    </c:if>
                    <c:if test="${not empty sessionScope.user.role}">
                        <p><strong>Vai trò:</strong> <c:out value="${sessionScope.user.role}"/></p>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-12 mb-4">
                    <div class="sidebar-widget">
                        <h2 class="title">Cập nhật hồ sơ</h2>
                        <c:if test="${not empty requestScope.profileSuccess}">
                            <div class="alert alert-success" role="alert"><c:out value="${requestScope.profileSuccess}"/></div>
                        </c:if>
                        <c:if test="${not empty requestScope.profileError}">
                            <div class="alert alert-danger" role="alert"><c:out value="${requestScope.profileError}"/></div>
                        </c:if>
                        <c:url var="profileAction" value="/account/profile"/>
                        <form method="post" action="${profileAction}">
                            <div class="form-group">
                                <label for="name">Họ tên</label>
                                <input type="text" id="name" name="name" class="form-control" value="${fn:escapeXml(empty sessionScope.user.name ? '' : sessionScope.user.name)}" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control" value="${fn:escapeXml(empty sessionScope.user.email ? '' : sessionScope.user.email)}" required>
                            </div>
                            <div class="form-group">
                                <label for="phoneNumber">Số điện thoại</label>
                                <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" value="${fn:escapeXml(empty sessionScope.user.phoneNumber ? '' : sessionScope.user.phoneNumber)}">
                            </div>
                            <div class="form-group">
                                <label for="address">Địa chỉ</label>
                                <input type="text" id="address" name="address" class="form-control" value="${fn:escapeXml(empty sessionScope.user.address ? '' : sessionScope.user.address)}">
                            </div>
                            <button type="submit" class="btn">Lưu thay đổi</button>
                        </form>
                    </div>
                </div>

                <div class="col-12">
                    <div class="sidebar-widget">
                        <h2 class="title">Đổi mật khẩu</h2>
                        <c:if test="${not empty requestScope.passwordSuccess}">
                            <div class="alert alert-success" role="alert"><c:out value="${requestScope.passwordSuccess}"/></div>
                        </c:if>
                        <c:if test="${not empty requestScope.passwordError}">
                            <div class="alert alert-danger" role="alert"><c:out value="${requestScope.passwordError}"/></div>
                        </c:if>
                        <c:url var="passwordAction" value="/account/password"/>
                        <form method="post" action="${passwordAction}" id="changePasswordForm">
                            <div class="form-group">
                                <label for="currentPassword">Mật khẩu hiện tại</label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="newPassword">Mật khẩu mới</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" minlength="7" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="7" required>
                            </div>
                            <button type="submit" class="btn">Đổi mật khẩu</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
<script>
  (function(){
    function setupChangePasswordValidation(){
      var form = document.getElementById('changePasswordForm');
      if(!form) return;
      var np = document.getElementById('newPassword');
      var cp = document.getElementById('confirmPassword');
      function validate(){
        if(np && np.value && np.value.length < 7){
          np.setCustomValidity('Mật khẩu tối thiểu 7 ký tự.');
        } else {
          np.setCustomValidity('');
        }
        if(cp && cp.value && np && np.value !== cp.value){
          cp.setCustomValidity('Mật khẩu xác nhận không khớp.');
        } else {
          cp.setCustomValidity('');
        }
      }
      np && np.addEventListener('input', validate);
      cp && cp.addEventListener('input', validate);
      form.addEventListener('submit', function(e){ validate(); if(!form.checkValidity()){ e.preventDefault(); e.stopPropagation(); }});
    }
    document.addEventListener('DOMContentLoaded', setupChangePasswordValidation);
  })();
</script>
</body>
</html>
