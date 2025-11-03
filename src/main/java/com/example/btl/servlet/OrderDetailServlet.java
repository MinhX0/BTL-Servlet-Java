package com.example.btl.servlet;

import com.example.btl.model.Order;
import com.example.btl.model.OrderItem;
import com.example.btl.model.User;
import com.example.btl.service.OrderService;
import com.example.btl.dao.OrderDAO;
import com.example.btl.dao.OrderItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/orders/detail"})
public class OrderDetailServlet extends HttpServlet {
    private OrderService orderService;

    @Override
    public void init() {
        this.orderService = new OrderService(new OrderDAO(), new OrderItemDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user != null && user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idParam = request.getParameter("orderId");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        int orderId;
        try {
            orderId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        Order order = orderService.get(orderId);
        if (order == null || order.getUser() == null || order.getUser().getId() != userId) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        List<OrderItem> items = orderService.items(orderId);
        request.setAttribute("order", order);
        request.setAttribute("items", items);
        // Pre-format LocalDateTime for JSP
        String orderDateStr = order.getOrderDate() != null
                ? order.getOrderDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                : "-";
        request.setAttribute("orderDateStr", orderDateStr);
        try {
            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
        } catch (ServletException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
