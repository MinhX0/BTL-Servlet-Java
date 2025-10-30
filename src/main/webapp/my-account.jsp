<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>E Shop - My Account</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<c:if test="${empty sessionScope.user}">
    <c:url var="loginUrl" value="/login.jsp">
        <c:param name="#" value="login"/>
    </c:url>
    <c:redirect url="/login.jsp#login"/>
</c:if>

<div class="breadcrumb-wrap">
    <div class="container">
        <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index">Home</a></li>
            <li class="breadcrumb-item active">My Account</li>
        </ul>
    </div>
</div>

<div class="container py-5">
    <div class="row">
        <div class="col-md-4">
            <div class="sidebar-widget">
                <h2 class="title">Account</h2>
                <ul style="list-style:none; padding-left:0;">
                    <li class="mb-2">
                        <c:url var="ordersUrl" value="/orders"/>
                        <a href="${ordersUrl}"><i class="fa fa-list"></i> My Orders</a>
                    </li>
                    <li class="mb-2">
                        <c:url var="cartUrl" value="/cart"/>
                        <a href="${cartUrl}"><i class="fa fa-shopping-cart"></i> My Cart</a>
                    </li>
                    <li class="mb-2">
                        <c:url var="logoutUrl" value="/logout"/>
                        <a href="${logoutUrl}"><i class="fa fa-sign-out"></i> Logout</a>
                    </li>
                </ul>
            </div>

            <div class="sidebar-widget">
                <h2 class="title">Overview</h2>
                <div>
                    <p><strong>Name:</strong> <c:out value="${sessionScope.user.name}" default="-"/></p>
                    <p><strong>Username:</strong> <c:out value="${sessionScope.user.username}" default="-"/></p>
                    <p><strong>Email:</strong> <c:out value="${sessionScope.user.email}" default="-"/></p>
                    <c:if test="${not empty sessionScope.user.phoneNumber}">
                        <p><strong>Phone:</strong> <c:out value="${sessionScope.user.phoneNumber}"/></p>
                    </c:if>
                    <c:if test="${not empty sessionScope.user.address}">
                        <p><strong>Address:</strong> <c:out value="${sessionScope.user.address}"/></p>
                    </c:if>
                    <c:if test="${not empty sessionScope.user.role}">
                        <p><strong>Role:</strong> <c:out value="${sessionScope.user.role}"/></p>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-12 mb-4">
                    <div class="sidebar-widget">
                        <h2 class="title">Update Profile</h2>
                        <c:if test="${not empty requestScope.profileSuccess}">
                            <div class="alert alert-success" role="alert"><c:out value="${requestScope.profileSuccess}"/></div>
                        </c:if>
                        <c:if test="${not empty requestScope.profileError}">
                            <div class="alert alert-danger" role="alert"><c:out value="${requestScope.profileError}"/></div>
                        </c:if>
                        <c:url var="profileAction" value="/account/profile"/>
                        <form method="post" action="${profileAction}">
                            <div class="form-group">
                                <label for="name">Full Name</label>
                                <input type="text" id="name" name="name" class="form-control" value="${fn:escapeXml(empty sessionScope.user.name ? '' : sessionScope.user.name)}" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control" value="${fn:escapeXml(empty sessionScope.user.email ? '' : sessionScope.user.email)}" required>
                            </div>
                            <div class="form-group">
                                <label for="phoneNumber">Phone Number</label>
                                <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" value="${fn:escapeXml(empty sessionScope.user.phoneNumber ? '' : sessionScope.user.phoneNumber)}">
                            </div>
                            <div class="form-group">
                                <label for="address">Address</label>
                                <input type="text" id="address" name="address" class="form-control" value="${fn:escapeXml(empty sessionScope.user.address ? '' : sessionScope.user.address)}">
                            </div>
                            <button type="submit" class="btn">Save Changes</button>
                        </form>
                    </div>
                </div>

                <div class="col-12">
                    <div class="sidebar-widget">
                        <h2 class="title">Change Password</h2>
                        <c:if test="${not empty requestScope.passwordSuccess}">
                            <div class="alert alert-success" role="alert"><c:out value="${requestScope.passwordSuccess}"/></div>
                        </c:if>
                        <c:if test="${not empty requestScope.passwordError}">
                            <div class="alert alert-danger" role="alert"><c:out value="${requestScope.passwordError}"/></div>
                        </c:if>
                        <c:url var="passwordAction" value="/account/password"/>
                        <form method="post" action="${passwordAction}">
                            <div class="form-group">
                                <label for="currentPassword">Current Password</label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" minlength="8" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="8" required>
                            </div>
                            <button type="submit" class="btn">Change Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
