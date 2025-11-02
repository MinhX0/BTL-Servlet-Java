<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>VNPAY - Transaction Result</title>
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
                    <h4>Transaction Result</h4>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${signatureValid}">
                            <p><strong>Gateway Status:</strong>
                                <span class="${vnp_TransactionStatus == 'Thành công' ? 'text-success' : 'text-warning'}">
                                    ${vnp_TransactionStatus}
                                </span>
                            </p>
                            <c:choose>
                                <c:when test="${orderExists}">
                                    <p><strong>Order:</strong> #${orderId}</p>
                                    <p><strong>Order Status:</strong>
                                        <span class="${orderPaid ? 'text-success' : 'text-warning'}">${orderStatus}</span>
                                        <c:if test="${!orderPaid}">
                                            <small class="text-muted">(Waiting IPN confirmation... page auto-refreshes)</small>
                                        </c:if>
                                        <c:if test="${updatedByReturn}">
                                            <small class="text-info d-block">Trạng thái đã được cập nhật theo kết quả trả về (fallback).</small>
                                        </c:if>
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">Order not found.</div>
                                </c:otherwise>
                            </c:choose>
                            <hr/>
                            <p><strong>Order Ref:</strong> ${fn:escapeXml(vnp_TxnRef)}</p>
                            <p><strong>Order Info:</strong> ${fn:escapeXml(vnp_OrderInfo)}</p>
                            <p><strong>Amount:</strong> ${amountDisplay}</p>
                            <p><strong>VNPAY Txn No:</strong> ${fn:escapeXml(vnp_TransactionNo)}</p>
                            <p><strong>Bank Code:</strong> ${fn:escapeXml(vnp_BankCode)}</p>
                            <p><strong>Pay Date:</strong> ${fn:escapeXml(vnp_PayDate)}</p>
                            <p><strong>Response Code:</strong> ${fn:escapeXml(vnp_ResponseCode)}</p>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger">Invalid signature. The transaction data may be tampered.</div>
                            <p><strong>Computed Hash:</strong> ${computedHash}</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-footer d-flex justify-content-between">
                    <c:url var="homeUrl" value="/index"/>
                    <a class="btn btn-outline-secondary" href="${homeUrl}">Back to Home</a>
                    <c:url var="cartUrl" value="/cart"/>
                    <a class="btn btn-primary" href="${cartUrl}">Go to Cart</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
