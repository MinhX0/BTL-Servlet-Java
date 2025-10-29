package com.example.btl.servlet;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.model.CartItem;
import com.example.btl.model.Order;
import com.example.btl.service.CheckoutService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    private CartItemDAO cartItemDAO;
    private CheckoutService checkoutService;

    @Override
    public void init() {
        this.cartItemDAO = new CartItemDAO();
        this.checkoutService = new CheckoutService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<CartItem> items = cartItemDAO.listByUserDetailed(userId);
        BigDecimal subTotal = BigDecimal.ZERO;
        for (CartItem ci : items) {
            BigDecimal line = ci.getVariant().getFinalVariantPrice().multiply(BigDecimal.valueOf(ci.getQuantity()));
            subTotal = subTotal.add(line);
        }
        request.setAttribute("cartItems", items);
        request.setAttribute("subTotal", subTotal);
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
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<CartItem> items = cartItemDAO.listByUserDetailed(userId);
        if (items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        Order order = checkoutService.placeOrder(userId, items);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=1");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/order-success.jsp?orderId=" + order.getId());
    }
}

