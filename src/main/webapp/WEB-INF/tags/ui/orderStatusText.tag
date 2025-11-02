<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="defaultText" required="false" %>
<c:choose>
    <c:when test="${empty value}">
        <c:out value="${empty defaultText ? '-' : defaultText}" />
    </c:when>
    <c:otherwise>
        <c:set var="code" value="${fn:toUpperCase(value)}" />
        <c:choose>
            <c:when test="${code == 'PROCESSING'}">Đang xử lý</c:when>
            <c:when test="${code == 'PENDING'}">Đang chờ</c:when>
            <c:when test="${code == 'AWAITING_PAYMENT' || code == 'AWAITING_IPN'}">Chờ xác nhận thanh toán</c:when>
            <c:when test="${code == 'PAID' || code == 'SUCCESS' || code == 'COMPLETED'}">Đã thanh toán</c:when>
            <c:when test="${code == 'SHIPPED'}">Đã gửi hàng</c:when>
            <c:when test="${code == 'DELIVERING'}">Đang giao</c:when>
            <c:when test="${code == 'DELIVERED'}">Đã giao</c:when>
            <c:when test="${code == 'REFUNDED'}">Đã hoàn tiền</c:when>
            <c:when test="${code == 'CANCELLED' || code == 'CANCELED'}">Đã hủy</c:when>
            <c:when test="${code == 'FAILED' || code == 'ERROR'}">Thất bại</c:when>
            <c:otherwise>
                <c:out value="${empty defaultText ? value : defaultText}" />
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
