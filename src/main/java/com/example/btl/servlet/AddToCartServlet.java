package com.example.btl.servlet;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.dao.ProductDAO;
import com.example.btl.model.CartItem;
import com.example.btl.model.Product;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/add-to-cart"})
public class AddToCartServlet extends HttpServlet {
    private CartItemDAO cartItemDAO = new CartItemDAO();
    private ProductDAO productDAO = new ProductDAO();

    private boolean isAjax(HttpServletRequest request) {
        String header = request.getHeader("X-Requested-With");
        if (header != null && header.equalsIgnoreCase("XMLHttpRequest")) return true;
        String ajaxParam = request.getParameter("ajax");
        return ajaxParam != null && ("1".equals(ajaxParam) || "true".equalsIgnoreCase(ajaxParam));
    }

    private int computeCartCount(int userId) {
        List<CartItem> items = cartItemDAO.listByUser(userId);
        int count = 0;
        for (CartItem ci : items) {
            count += ci.getQuantity();
        }
        return count;
    }

    private int parseQuantity(HttpServletRequest request) {
        String qtyStr = request.getParameter("quantity");
        int qty = 1;
        if (qtyStr != null) {
            try {
                qty = Integer.parseInt(qtyStr.trim());
            } catch (NumberFormatException ignored) { }
        }
        if (qty < 1) qty = 1;
        if (qty > 1000) qty = 1000; // simple upper bound to avoid abuse
        return qty;
    }

    private String normalizeSize(String raw) {
        if (raw == null) return null;
        String s = raw.trim();
        if (s.isEmpty()) return null;
        return s.length() > 10 ? s.substring(0, 10) : s;
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String prodIdStr = request.getParameter("productId");
        String size = normalizeSize(request.getParameter("size"));
        if (size == null) size = "42"; // default size when not provided
        if (prodIdStr == null || prodIdStr.isBlank()) {
            if (isAjax(request)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"message\":\"Missing productId\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(prodIdStr);
        } catch (NumberFormatException e) {
            if (isAjax(request)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"message\":\"Invalid productId\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        // Fetch including inactive so we can return a meaningful message
        Product product = productDAO.getByIdIncludingInactive(productId);
        if (product == null) {
            if (isAjax(request)) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"message\":\"Product not found\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }
        if (!product.isActive()) {
            if (isAjax(request)) {
                response.setStatus(409); // Conflict: unavailable
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"message\":\"Sản phẩm đã ngừng bán\"}");
                return;
            }
            // Redirect back to product detail with a hint param
            String url = request.getContextPath() + "/product-detail?id=" + product.getId() + "&unavailable=1";
            response.sendRedirect(url);
            return;
        }
        if (product.getStock() <= 0) {
            if (isAjax(request)) {
                response.setStatus(409);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"message\":\"Sản phẩm tạm hết hàng\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + product.getId() + "&outOfStock=1");
            return;
        }

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            if (isAjax(request)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"auth\":false}");
                return;
            }
            // not logged in -> redirect to login with original URL so they can be sent back
            String current = request.getHeader("Referer");
            String loginUrl = request.getContextPath() + "/login";
            if (current != null) loginUrl += "?returnTo=" + java.net.URLEncoder.encode(current, java.nio.charset.StandardCharsets.UTF_8);
            response.sendRedirect(loginUrl);
            return;
        }

        // Block admin users from buying
        if (user.isAdmin()) {
            if (isAjax(request)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"message\":\"Admin cannot add to cart\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        int qty = parseQuantity(request);

        // Clamp qty to available stock minus existing qty in cart
        CartItem existing = cartItemDAO.findByUserProductSize(user.getId(), productId, size);
        int already = existing != null ? existing.getQuantity() : 0;
        int available = Math.max(0, product.getStock() - already);
        if (available <= 0) {
            if (isAjax(request)) {
                response.setStatus(409);
                response.setContentType("application/json");
                response.getWriter().write("{\"ok\":false,\"message\":\"Số lượng vượt quá tồn kho\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/cart?error=outofstock");
            return;
        }
        if (qty > available) qty = available;

        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + qty);
            cartItemDAO.update(existing);
        } else {
            CartItem newItem = new CartItem();
            newItem.setUser(user);
            newItem.setProduct(product);
            newItem.setQuantity(qty);
            newItem.setDateAdded(LocalDateTime.now());
            newItem.setItemSize(size);
            cartItemDAO.create(newItem);
        }

        if (isAjax(request)) {
            int count = computeCartCount(user.getId());
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.write("{\"ok\":true,\"count\":" + count + ",\"size\":\"" + size + "\"}");
            out.flush();
            return;
        }

        // Redirect back to referer or cart
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/cart");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        handleAdd(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        handleAdd(request, response);
    }
}
