package com.example.btl.servlet;

import com.example.btl.model.Order;
import com.example.btl.model.OrderItem;
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
        try {
            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
        } catch (ServletException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

