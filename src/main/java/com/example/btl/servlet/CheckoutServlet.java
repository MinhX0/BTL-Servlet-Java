package com.example.btl.servlet;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.model.CartItem;
import com.example.btl.model.Order;
import com.example.btl.model.User;
import com.example.btl.model.Product;
import com.example.btl.model.Promotion;
import com.example.btl.service.CheckoutService;
import com.example.btl.service.PromotionService;
import com.example.btl.servlet.payment.vnpay.Config;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    private CartItemDAO cartItemDAO;
    private CheckoutService checkoutService;
    private PromotionService promotionService;

    @Override
    public void init() {
        this.cartItemDAO = new CartItemDAO();
        this.checkoutService = new CheckoutService();
        this.promotionService = new PromotionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user != null && (user.isAdmin() || user.isSeller())) { // include seller
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // If specific selected ids come from cart via query string, show only those in summary; else show all
        String[] selectedParam = request.getParameterValues("item");
        List<CartItem> items;
        if (selectedParam != null && selectedParam.length > 0) {
            List<Integer> ids = Arrays.stream(selectedParam)
                    .map(s -> { try { return Integer.parseInt(s); } catch (Exception e) { return null; } })
                    .filter(Objects::nonNull)
                    .toList();
            items = cartItemDAO.listByUserSelectedDetailed(userId, ids);
            request.setAttribute("selectedIds", ids); // keep for the form hidden inputs
        } else {
            items = cartItemDAO.listByUserDetailed(userId);
        }

        long subTotalVnd = 0L;
        for (CartItem ci : items) {
            Product p = ci.getProduct();
            long unit = (p.getSalePrice() != null && p.getSalePrice() > 0 && p.getBasePrice() > p.getSalePrice())
                    ? p.getSalePrice()
                    : p.getBasePrice();
            subTotalVnd += unit * (long) ci.getQuantity();
        }

        // Find best applicable promotion
        BigDecimal subtotal = BigDecimal.valueOf(subTotalVnd);
        Promotion bestPromotion = promotionService.getBestApplicablePromotion(subtotal);
        BigDecimal discountAmount = BigDecimal.ZERO;
        BigDecimal totalAmount = subtotal;

        if (bestPromotion != null) {
            discountAmount = bestPromotion.calculateDiscount(subtotal);
            totalAmount = subtotal.subtract(discountAmount);
        }

        request.setAttribute("cartItems", items);
        request.setAttribute("subTotal", subTotalVnd);
        request.setAttribute("promotion", bestPromotion);
        request.setAttribute("discountAmount", discountAmount.longValue());
        request.setAttribute("totalAmount", totalAmount.longValue());

        try {
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user != null && (user.isAdmin() || user.isSeller())) { // include seller
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String payment = Optional.ofNullable(request.getParameter("payment")).orElse("COD");
        String address = request.getParameter("address");

        // Collect selected cart item ids from hidden inputs named selectedItem
        String[] selectedIdsRaw = request.getParameterValues("selectedItem");
        List<Integer> selectedIds = selectedIdsRaw == null ? List.of() : Arrays.stream(selectedIdsRaw)
                .map(s -> { try { return Integer.parseInt(s); } catch (Exception e) { return null; } })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        List<CartItem> items;
        boolean partialCheckout = false;
        if (!selectedIds.isEmpty()) {
            items = cartItemDAO.listByUserSelectedDetailed(userId, selectedIds);
            partialCheckout = true;
        } else {
            // fallback: all items
            items = cartItemDAO.listByUserDetailed(userId);
        }
        if (items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Order order = checkoutService.placeOrderSelected(userId, items, address, partialCheckout);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=1");
            return;
        }

        if ("VNPAY".equalsIgnoreCase(payment)) {
            try {
                String redirectUrl = buildVnPayRedirectUrl(request, order);
                response.sendRedirect(redirectUrl);
                return;
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/vnpay_return?error=init_failed&orderId=" + order.getId());
                return;
            }
        }

        // Default: COD flow → show success screen
        request.setAttribute("orderId", order.getId());
        request.setAttribute("totalAmount", order.getTotalAmount().toBigInteger());
        request.setAttribute("orderDate", order.getOrderDate());
        request.setAttribute("address", order.getAddress());
        try {
            request.getRequestDispatcher("/order-success.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    private String buildVnPayRedirectUrl(HttpServletRequest request, Order order) {
        // Compute amount in minor units (x100)
        BigDecimal total = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
        long amountMinor = total.multiply(BigDecimal.valueOf(100)).setScale(0, RoundingMode.HALF_UP).longValue();

        String vnp_ReturnUrl = request.getScheme() + "://" + request.getServerName() +
                (request.getServerPort() != 80 && request.getServerPort() != 443 ? (":" + request.getServerPort()) : "") +
                request.getContextPath() + "/vnpay_return";
        String vnp_IpAddr = Config.getIpAddress(request);

        Map<String, String> fields = new HashMap<>();
        fields.put("vnp_Version", "2.1.0");
        fields.put("vnp_Command", "pay");
        fields.put("vnp_TmnCode", Config.vnp_TmnCode);
        fields.put("vnp_Amount", String.valueOf(amountMinor));
        fields.put("vnp_CurrCode", "VND");
        fields.put("vnp_ExpireDate", LocalDateTime.now().plusMinutes(15).format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        fields.put("vnp_TxnRef", String.valueOf(order.getId()));
        fields.put("vnp_OrderInfo", "Payment for order #" + order.getId());
        fields.put("vnp_OrderType", "other");
        fields.put("vnp_Locale", "vn");
        fields.put("vnp_ReturnUrl", vnp_ReturnUrl);
        fields.put("vnp_IpAddr", vnp_IpAddr);
        String createDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        fields.put("vnp_CreateDate", createDate);

        // Encode and sign
        Map<String, String> encoded = new HashMap<>();
        for (Map.Entry<String, String> e : fields.entrySet()) {
            String k = URLEncoder.encode(e.getKey(), java.nio.charset.StandardCharsets.US_ASCII);
            String v = URLEncoder.encode(e.getValue(), java.nio.charset.StandardCharsets.US_ASCII);
            encoded.put(k, v);
        }
        String secureHash = Config.hashAllFields(encoded);

        // Build query string with encoded keys/values + hash
        List<String> parts = new ArrayList<>();
        encoded.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .forEach(en -> parts.add(en.getKey() + "=" + en.getValue()));
        parts.add(URLEncoder.encode("vnp_SecureHash", java.nio.charset.StandardCharsets.US_ASCII) + "=" + URLEncoder.encode(secureHash, java.nio.charset.StandardCharsets.US_ASCII));

        return Config.vnp_PayUrl + "?" + String.join("&", parts);
    }
}
