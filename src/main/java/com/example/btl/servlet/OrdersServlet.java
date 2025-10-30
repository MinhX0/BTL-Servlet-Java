package com.example.btl.servlet;

import com.example.btl.dao.OrderDAO;
import com.example.btl.dao.OrderItemDAO;
import com.example.btl.model.Order;
import com.example.btl.service.OrderService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {
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
        List<Order> orders = orderService.listByUser(userId);
        request.setAttribute("orders", orders);
        try {
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

