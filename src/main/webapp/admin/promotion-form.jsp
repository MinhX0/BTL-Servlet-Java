<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - ${promotion != null ? 'Sửa' : 'Tạo'} Khuyến mãi</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
    <div class="container-fluid">
        <div class="mb-3 d-flex justify-content-between align-items-center">
            <h3>${promotion != null ? 'Sửa' : 'Tạo'} Khuyến mãi</h3>
            <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-link">← Quay lại danh sách</a>
        </div>

        <div class="card">
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form method="post"
                      action="${promotion != null ? pageContext.request.contextPath.concat('/admin/promotions/edit') : pageContext.request.contextPath.concat('/admin/promotions/create')}">

                    <c:if test="${promotion != null}">
                        <input type="hidden" name="id" value="${promotion.id}" />
                    </c:if>

                    <div class="mb-3">
                        <label for="name" class="form-label">Tên khuyến mãi <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" name="name"
                               value="${promotion != null ? promotion.name : ''}" required maxlength="255" />
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả</label>
                        <textarea id="description" name="description" class="form-control" rows="3">${promotion != null ? promotion.description : ''}</textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="discountType" class="form-label">Loại giảm giá <span class="text-danger">*</span></label>
                                <select id="discountType" name="discountType" class="form-select" required onchange="updateDiscountLabel()">
                                    <option value="PERCENTAGE" ${promotion == null || promotion.discountType == 'PERCENTAGE' ? 'selected' : ''}>Phần trăm (%)</option>
                                    <option value="FIXED_AMOUNT" ${promotion != null && promotion.discountType == 'FIXED_AMOUNT' ? 'selected' : ''}>Số tiền cố định (VNĐ)</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label id="discountLabel" for="discountValue" class="form-label">Giá trị giảm giá <span class="text-danger">*</span></label>
                                <input id="discountValue" name="discountValue" class="form-control" type="number" min="0" step="0.01"
                                       value="${promotion != null ? promotion.discountValue : ''}" required />
                                <div class="form-text" id="discountHint">Nhập phần trăm (0-100) hoặc số tiền cố định</div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="minOrderAmount" class="form-label">Giá trị đơn hàng tối thiểu (VNĐ)</label>
                        <input id="minOrderAmount" name="minOrderAmount" class="form-control" type="number" min="0" step="1000"
                               value="${promotion != null ? promotion.minOrderAmount : 0}" />
                        <div class="form-text">Để 0 nếu áp dụng cho tất cả đơn hàng</div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="startDate" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                <c:choose>
                                    <c:when test="${promotion != null}">
                                        <fmt:formatDate value="${promotion.startDateAsDate}" pattern="yyyy-MM-dd" var="startDateFormatted"/>
                                        <fmt:formatDate value="${promotion.startDateAsDate}" pattern="HH:mm" var="startTimeFormatted"/>
                                        <input type="datetime-local" id="startDate" name="startDate" class="form-control" required
                                               value="${startDateFormatted}T${startTimeFormatted}" />
                                    </c:when>
                                    <c:otherwise>
                                        <input type="datetime-local" id="startDate" name="startDate" class="form-control" required value="" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="endDate" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                <c:choose>
                                    <c:when test="${promotion != null}">
                                        <fmt:formatDate value="${promotion.endDateAsDate}" pattern="yyyy-MM-dd" var="endDateFormatted"/>
                                        <fmt:formatDate value="${promotion.endDateAsDate}" pattern="HH:mm" var="endTimeFormatted"/>
                                        <input type="datetime-local" id="endDate" name="endDate" class="form-control" required
                                               value="${endDateFormatted}T${endTimeFormatted}" />
                                    </c:when>
                                    <c:otherwise>
                                        <input type="datetime-local" id="endDate" name="endDate" class="form-control" required value="" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="form-check mb-3">
                        <input type="checkbox" id="isActive" name="isActive" class="form-check-input"
                               ${promotion == null || promotion.active ? 'checked' : ''} />
                        <label class="form-check-label" for="isActive">Kích hoạt khuyến mãi</label>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">${promotion != null ? 'Cập nhật' : 'Tạo mới'}</button>
                        <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-secondary">Hủy</a>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function updateDiscountLabel() {
        var dt = document.getElementById('discountType').value;
        var label = document.getElementById('discountLabel');
        var hint = document.getElementById('discountHint');
        var input = document.getElementById('discountValue');
        if (dt === 'PERCENTAGE') {
            label.textContent = 'Giá trị giảm giá (%)';
            hint.textContent = 'Nhập giá trị từ 0 đến 100';
            input.setAttribute('max', '100');
        } else {
            label.textContent = 'Giá trị giảm giá (VNĐ)';
            hint.textContent = 'Nhập số tiền giảm giá cố định';
            input.removeAttribute('max');
        }
    }
    document.addEventListener('DOMContentLoaded', function() { try { updateDiscountLabel(); } catch(e){} });
</script>

<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>
