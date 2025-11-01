package com.example.btl.servlet.admin;

import com.example.btl.dao.OrderDAO;
import com.example.btl.model.OrderStatus;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminOrderActionServlet", urlPatterns = {"/admin/orders/action"})
public class AdminOrderActionServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        String orderIdStr = request.getParameter("orderId");
        String action = request.getParameter("action"); // confirm|cancel|ship|deliver|refund

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderStatus status;
            switch (action == null ? "" : action.toLowerCase()) {
                case "confirm": status = OrderStatus.Processing; break;
                case "cancel": status = OrderStatus.Cancelled; break;
                case "ship": status = OrderStatus.Shipped; break;
                case "deliver": status = OrderStatus.Delivered; break;
                case "refund": status = OrderStatus.Refunded; break;
                default: status = null;
            }
            if (status != null) {
                orderDAO.updateStatus(orderId, status);
            }
        } catch (Exception ignored) {}
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}

