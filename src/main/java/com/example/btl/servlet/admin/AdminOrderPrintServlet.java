package com.example.btl.servlet.admin;

import com.example.btl.dao.OrderDAO;
import com.example.btl.dao.OrderItemDAO;
import com.example.btl.model.Order;
import com.example.btl.model.OrderItem;
import com.example.btl.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderPrintServlet", urlPatterns = {"/admin/orders/print"})
public class AdminOrderPrintServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAO();
        this.orderItemDAO = new OrderItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        String id = request.getParameter("id");
        int orderId;
        try { orderId = Integer.parseInt(id); } catch (Exception e) { response.sendRedirect(request.getContextPath() + "/admin/orders"); return; }

        Order order = orderDAO.getById(orderId);
        if (order == null) { response.sendRedirect(request.getContextPath() + "/admin/orders"); return; }
        List<OrderItem> items = orderItemDAO.listByOrder(orderId);

        request.setAttribute("order", order);
        request.setAttribute("items", items);
        try {
            request.getRequestDispatcher("/admin/order-print.jsp").forward(request, response);
        } catch (ServletException e) {
            throw new IOException(e);
        }
    }
}

