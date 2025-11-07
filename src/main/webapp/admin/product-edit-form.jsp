<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị - Sửa sản phẩm</title>
    <%@ include file="/WEB-INF/jsp/admin/layout/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/jsp/admin/layout/header.jspf" %>
<%@ include file="/WEB-INF/jsp/admin/layout/sidebar.jspf" %>
<div class="admin-content">
  <div class="container-fluid">
    <h3>Sửa sản phẩm</h3>
    <div class="card mt-3">
      <div class="card-body">
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">Có lỗi xảy ra khi lưu. Vui lòng thử lại.</div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/admin/products/edit" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${product.id}" />
            <div class="mb-3">
                <label class="form-label">Tên</label>
                <input type="text" name="name" class="form-control" value="${product.name}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mô tả</label>
                <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Ảnh hiện tại</label><br>
                <c:choose>
                    <c:when test="${empty product.mainImageUrl}">
                        <span class="text-muted">(Không có - sẽ dùng placeholder)</span>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${fn:startsWith(product.mainImageUrl,'http://') || fn:startsWith(product.mainImageUrl,'https://')}">
                                <img src="${product.mainImageUrl}" alt="${product.name}" style="max-height:100px;" />
                            </c:when>
                            <c:otherwise>
                                <c:url var="imgPreview" value="/product-image">
                                    <c:param name="file" value="${product.mainImageUrl}" />
                                </c:url>
                                <img src="${imgPreview}" alt="${product.name}" style="max-height:100px;" />
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="mb-3">
                <label class="form-label">Đổi ảnh (tải lên mới)</label>
                <input type="file" name="mainImageFile" accept="image/*" class="form-control">
            </div>
            <div class="mb-3">
                <label class="form-label">Hoặc URL ảnh mới (tuỳ chọn)</label>
                <input type="text" name="mainImageUrl" class="form-control" placeholder="https://...">
                <div class="form-text">Nếu tải lên & URL cùng có, ưu tiên ảnh tải lên.</div>
            </div>
            <div class="mb-3">
                <label class="form-label">Giá gốc (VND)</label>
                <input type="number" step="1" min="0" name="basePrice" class="form-control" value="${product.basePrice}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Giá giảm (VND) - tuỳ chọn</label>
                <input type="number" step="1" min="0" name="salePrice" class="form-control" value="${product.salePrice}" placeholder="Để trống nếu không giảm giá">
            </div>
            <div class="mb-3">
                <label class="form-label">Danh mục</label>
                <select name="categoryId" class="form-select" required>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}" <c:if test='${c.id == product.category.id}'>selected</c:if>>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Cập nhật</button>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Hủy</a>
        </form>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/jsp/admin/layout/footer.jspf" %>
</body>
</html>
