package com.example.btl.servlet;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.service.CartService;
import com.example.btl.model.CartItem;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    private CartService cartService;

    @Override
    public void init() {
        this.cartService = new CartService(new CartItemDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<CartItem> items = cartService.listByUserDetailed(userId);
        request.setAttribute("cartItems", items);
        try {
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        boolean ok = false;
        try {
            if ("add".equalsIgnoreCase(action)) {
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                int qty = parseIntOr(request.getParameter("qty"), 1);
                ok = cartService.addOrIncrement(userId, variantId, Math.max(1, qty));
            } else if ("update".equalsIgnoreCase(action)) {
                int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
                int qty = parseIntOr(request.getParameter("qty"), 1);
                ok = cartService.updateQuantity(cartItemId, qty);
            } else if ("remove".equalsIgnoreCase(action)) {
                int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
                ok = cartService.updateQuantity(cartItemId, 0); // delete
            } else if ("clear".equalsIgnoreCase(action)) {
                ok = cartService.clearCart(userId);
            }
        } catch (Exception ignore) {
            ok = false;
        }

        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.isBlank()) {
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private int parseIntOr(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}

