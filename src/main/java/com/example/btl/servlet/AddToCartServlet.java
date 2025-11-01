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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String prodIdStr = request.getParameter("productId");
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

        Product product = productDAO.getById(productId);
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

        // Check existing cart item for this user & product
        CartItem existing = cartItemDAO.findByUserAndProduct(user.getId(), productId);
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + 1);
            cartItemDAO.update(existing);
        } else {
            CartItem newItem = new CartItem();
            newItem.setUser(user);
            newItem.setProduct(product);
            newItem.setQuantity(1);
            newItem.setDateAdded(LocalDateTime.now());
            cartItemDAO.create(newItem);
        }

        if (isAjax(request)) {
            int count = computeCartCount(user.getId());
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.write("{\"ok\":true,\"count\":" + count + "}");
            out.flush();
            return;
        }

        // Redirect back to referer or products
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/cart");
    }
}
