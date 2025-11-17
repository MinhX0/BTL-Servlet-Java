<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Giỏ hàng</title>
    <%@ include file="/WEB-INF/jsp/layout/head.jspf" %>
    <style>
        .size-select {
            max-height: 120px;
            overflow-y: auto;
        }

        .price-old {
            color: #888;
            text-decoration: line-through;
            font-size: .9rem;
        }

        .price-new {
            color: #d0021b;
            font-weight: 600;
        }

        .select-col {
            width: 40px;
        }

        .product-name-col {
            max-width: 200px;
            word-wrap: break-word;
            white-space: normal;
        }
    </style>
    <script>
        function toggleAll(src) {
            document.querySelectorAll('.cart-select-item').forEach(cb => {
                cb.checked = src.checked
            });
            recomputeSelected();
        }

        function recomputeSelected() {
            const rows = [...document.querySelectorAll('tr[data-line]')];
            let sum = 0;
            let count = 0;
            rows.forEach(r => {
                const cb = r.querySelector('.cart-select-item');
                if (cb && cb.checked) {
                    const lineTotal = parseInt(r.getAttribute('data-line-total')) || 0;
                    sum += lineTotal;
                    count++;
                }
            });
            const totalSpan = document.getElementById('finalTotal');
            const tempTotalSpan=document.getElementById('tempTotal');
            if (totalSpan) {
                totalSpan.textContent = new Intl.NumberFormat('vi-VN').format(sum) + ' đ';
            }
            if(tempTotalSpan){
                tempTotalSpan.textContent = new Intl.NumberFormat('vi-VN').format(sum) + ' đ';

            }
            document.getElementById('checkoutSelectedBtn').disabled = count === 0;
            document.getElementById('clearSelectedBtn').disabled = count === 0;
        }

        function submitSelected() {
            const form = document.getElementById('selectedCheckoutForm');
            // remove old hidden inputs
            [...form.querySelectorAll('input[name=\"item\"]')].forEach(e => e.remove());
            document.querySelectorAll('.cart-select-item:checked').forEach(cb => {
                const hid = document.createElement('input');
                hid.type = 'hidden';
                hid.name = 'item';
                hid.value = cb.value;
                form.appendChild(hid);
            });
            form.submit();
        }

        function submitClearSelected() {
            if (!confirm('Xóa các sản phẩm đã chọn?')) return;
            const form = document.getElementById('clearSelectedForm');
            [...form.querySelectorAll('input[name=\"cartItemId\"]')].forEach(e => e.remove());
            document.querySelectorAll('.cart-select-item:checked').forEach(cb => {
                const hid = document.createElement('input');
                hid.type = 'hidden';
                hid.name = 'cartItemId';
                hid.value = cb.value;
                form.appendChild(hid);
            });
            form.submit();
        }

        function updateQuantity(cartItemId, newQty) {
            if (newQty < 1) return;
            const row = document.querySelector('tr[data-line="' + cartItemId + '"]');
            if (!row) return;

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=updateAjax&cartItemId=' + cartItemId + '&qty=' + newQty
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        const input = row.querySelector('input[name="qty"]');
                        if (input) input.value = newQty;
                        const unitPrice = parseInt(row.getAttribute('data-unit-price'));
                        const lineTotal = unitPrice * newQty;
                        row.setAttribute('data-line-total', lineTotal);
                        const totalCell = row.querySelector('.line-total');
                        if (totalCell) totalCell.textContent = new Intl.NumberFormat('vi-VN').format(lineTotal) + ' đ';
                        recomputeSelected();
                    } else {
                        alert(data.message || 'Cập nhật thất bại');
                    }
                })
                .catch(err => {
                    console.error('Error updating quantity:', err);
                    alert('Lỗi khi cập nhật số lượng');
                });
        }

        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('.cart-select-item').forEach(cb => cb.addEventListener('change', recomputeSelected));
            recomputeSelected();

            document.querySelectorAll('.btn-minus').forEach(btn => {
                btn.addEventListener('click', function () {
                    const row = this.closest('tr');
                    const cartItemId = row.getAttribute('data-line');
                    const input = row.querySelector('input[name="qty"]');
                    const currentQty = parseInt(input.value);
                    if (currentQty > 1) {
                        updateQuantity(cartItemId, currentQty - 1);
                    }
                });
            });

            document.querySelectorAll('.btn-plus').forEach(btn => {
                btn.addEventListener('click', function () {
                    const row = this.closest('tr');
                    const cartItemId = row.getAttribute('data-line');
                    const input = row.querySelector('input[name="qty"]');
                    const currentQty = parseInt(input.value);
                    updateQuantity(cartItemId, currentQty + 1);
                });
            });
        });
    </script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/layout/header.jspf" %>

<div class="cart-page">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead class="thead-dark">
                        <tr>
                            <th class="select-col"><input type="checkbox" onclick="toggleAll(this)" title="Chọn tất cả">
                            </th>
                            <th>Ảnh</th>
                            <th>Tên</th>
                            <th>Kích cỡ</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Tổng</th>
                            <th>Xóa</th>
                        </tr>
                        </thead>
                        <tbody class="align-middle">
                        <c:choose>
                            <c:when test="${not empty cartItems}">
                                <c:set var="subTotal" value="0"/>
                                <c:forEach var="ci" items="${cartItems}" varStatus="st">
                                    <c:set var="unitPrice" value="${ci.product.effectivePrice}"/>
                                    <c:set var="lineTotal" value="${unitPrice * ci.quantity}"/>
                                    <tr data-line="${ci.id}" data-line-total="${lineTotal}"
                                        data-unit-price="${unitPrice}">
                                        <td class="select-col">
                                            <input type="checkbox" class="cart-select-item" value="${ci.id}"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty ci.product.mainImageUrl}">
                                                    <c:set var="resolvedImg" value="/product-image"/>
                                                </c:when>
                                                <c:when test="${fn:startsWith(ci.product.mainImageUrl,'http://') || fn:startsWith(ci.product.mainImageUrl,'https://') || fn:startsWith(ci.product.mainImageUrl,'/')}">
                                                    <c:set var="resolvedImg" value="${ci.product.mainImageUrl}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="resolvedImg" value="/product-image">
                                                        <c:param name="file" value="${ci.product.mainImageUrl}"/>
                                                    </c:url>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:url var="phUrl" value="/assets/img/placeholder.jpg"/>
                                            <a href="#"><img src="${resolvedImg}" alt="${fn:escapeXml(ci.product.name)}"
                                                             onerror="this.onerror=null;this.src='${phUrl}'"></a>
                                        </td>
                                        <td class="product-name-col">
                                            <c:url var="detailUrl" value="/product-detail">
                                                <c:param name="id" value="${ci.product.id}"/>
                                            </c:url>
                                            <a href="${detailUrl}">${ci.product.name}</a>
                                        </td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/cart"
                                                  class="mb-0">
                                                <input type="hidden" name="action" value="changeSize"/>
                                                <input type="hidden" name="cartItemId" value="${ci.id}"/>
                                                <select name="size" class="form-control size-select"
                                                        onchange="this.form.submit()">
                                                    <c:forEach var="opt" items="${[39,40,41,42,43,44,45]}">
                                                        <option value="${opt}" ${ci.itemSize == opt ? 'selected' : ''}>${opt}</option>
                                                    </c:forEach>
                                                </select>
                                            </form>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${ci.product.salePrice != null && ci.product.salePrice > 0}">
                                                    <div class="price-old"><fmt:formatNumber
                                                            value="${ci.product.basePrice}" type="number"
                                                            groupingUsed="true" maxFractionDigits="0"
                                                            minFractionDigits="0"/> đ
                                                    </div>
                                                    <div class="price-new"><fmt:formatNumber value="${unitPrice}"
                                                                                             type="number"
                                                                                             groupingUsed="true"
                                                                                             maxFractionDigits="0"
                                                                                             minFractionDigits="0"/> đ
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div><fmt:formatNumber value="${unitPrice}" type="number"
                                                                           groupingUsed="true" maxFractionDigits="0"
                                                                           minFractionDigits="0"/> đ
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="qty">
                                                <button type="button" class="btn-minus"><i class="fa fa-minus"></i>
                                                </button>
                                                <input type="text" name="qty" value="${ci.quantity}" min="1" readonly>
                                                <button type="button" class="btn-plus"><i class="fa fa-plus"></i>
                                                </button>
                                            </div>
                                        </td>
                                        <td class="line-total"><fmt:formatNumber value="${lineTotal}" type="number"
                                                                                 groupingUsed="true"
                                                                                 maxFractionDigits="0"
                                                                                 minFractionDigits="0"/> đ
                                        </td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/cart"
                                                  onsubmit="return confirm('Xóa sản phẩm này?');">
                                                <input type="hidden" name="action" value="remove"/>
                                                <input type="hidden" name="cartItemId" value="${ci.id}"/>
                                                <button class="btn btn-danger"><i class="fa fa-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                    <c:set var="subTotal" value="${subTotal + lineTotal}"/>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="text-center text-muted">Giỏ hàng trống.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <c:if test="${not empty cartItems}">
            <div class="row">
                <div class="col-md-6">
                    <div class="cart-summary">
                        <div class="cart-content">
                            <h3>Tóm tắt giỏ hàng</h3>
                            <p>Tạm tính<span id="tempTotal">0 đ</span>
                            </p>
                            <p>Phí vận chuyển<span>0đ</span></p>
                            <h4>Tổng cộng<span id="finalTotal">0 đ</span></h4>
                        </div>
                        <div class="cart-btn">
                            <form id="clearSelectedForm" method="post" action="${pageContext.request.contextPath}/cart"
                                  class="d-inline">
                                <input type="hidden" name="action" value="remove"/>
                                <button type="button" id="clearSelectedBtn" class="btn btn-secondary"
                                        onclick="submitClearSelected()" disabled>Xóa mục đã chọn
                                </button>
                            </form>
                            <form id="selectedCheckoutForm" method="get"
                                  action="${pageContext.request.contextPath}/checkout" class="d-inline">
                                <button type="button" id="checkoutSelectedBtn" class="btn btn-primary"
                                        onclick="submitSelected()" disabled>Thanh toán
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/layout/footer.jspf" %>
</body>
</html>
