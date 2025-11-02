<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>VNPAY - Kết quả giao dịch</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
    <c:if test="${signatureValid && orderExists && !orderPaid}">
        <meta http-equiv="refresh" content="5">
    </c:if>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card">
                <div class="card-header">
                    <h4>Kết quả giao dịch</h4>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${signatureValid}">
                            <p><strong>Trạng thái cổng thanh toán:</strong>
                                <span class="${vnp_TransactionStatus == 'Thành công' ? 'text-success' : 'text-warning'}">
                                    ${vnp_TransactionStatus}
                                </span>
                            </p>
                            <c:choose>
                                <c:when test="${orderExists}">
                                    <p><strong>Đơn hàng:</strong> #${orderId}</p>
                                    <p><strong>Trạng thái đơn hàng:</strong>
                                        <span class="${orderPaid ? 'text-success' : 'text-warning'}">
                                            <ui:orderStatusText value="${orderStatus}" />
                                        </span>
                                        <c:if test="${!orderPaid}">
                                            <small class="text-muted">(Chờ xác nhận IPN... trang sẽ tự động làm mới)</small>
                                        </c:if>
                                        <c:if test="${updatedByReturn}">
                                            <small class="text-info d-block">Trạng thái đã được cập nhật theo dữ liệu trả về (dự phòng).</small>
                                        </c:if>
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">Không tìm thấy đơn hàng.</div>
                                </c:otherwise>
                            </c:choose>
                            <hr/>
                            <p><strong>Mã tham chiếu:</strong> ${fn:escapeXml(vnp_TxnRef)}</p>
                            <p><strong>Thông tin đơn hàng:</strong> ${fn:escapeXml(vnp_OrderInfo)}</p>
                            <p><strong>Số tiền:</strong> ${amountDisplay}</p>
                            <p><strong>Mã giao dịch VNPAY:</strong> ${fn:escapeXml(vnp_TransactionNo)}</p>
                            <p><strong>Ngân hàng:</strong> ${fn:escapeXml(vnp_BankCode)}</p>
                            <p><strong>Thời gian thanh toán:</strong> ${fn:escapeXml(vnp_PayDate)}</p>
                            <p><strong>Mã phản hồi:</strong> ${fn:escapeXml(vnp_ResponseCode)}</p>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger">Chữ ký không hợp lệ. Dữ liệu giao dịch có thể đã bị thay đổi.</div>
                            <p><strong>Hash tính được:</strong> ${computedHash}</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-footer d-flex justify-content-between">
                    <c:url var="homeUrl" value="/index"/>
                    <a class="btn btn-outline-secondary" href="${homeUrl}">Về trang chủ</a>
                    <c:url var="cartUrl" value="/cart"/>
                    <a class="btn btn-primary" href="${cartUrl}">Tới giỏ hàng</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
