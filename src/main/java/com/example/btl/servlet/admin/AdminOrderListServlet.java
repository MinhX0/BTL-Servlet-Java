package com.example.btl.servlet.admin;

import com.example.btl.dao.OrderDAO;
import com.example.btl.model.Order;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderListServlet", urlPatterns = {"/admin/orders"})
public class AdminOrderListServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        List<Order> orders = orderDAO.listAll();
        request.setAttribute("orders", orders);
        try {
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

