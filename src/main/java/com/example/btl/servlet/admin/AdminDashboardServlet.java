package com.example.btl.servlet.admin;

import com.example.btl.dao.OrderDAO;
import com.example.btl.dao.ProductDAO;
import com.example.btl.dao.UserDAO;
import com.example.btl.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin", "/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        // KPIs (totals only)
        long users = userDAO.countAll();
        long products = productDAO.countAll();
        long orders = orderDAO.countAll();
        BigDecimal revenue = orderDAO.sumRevenue();

        request.setAttribute("kpiUsers", users);
        request.setAttribute("kpiProducts", products);
        request.setAttribute("kpiOrders", orders);
        request.setAttribute("kpiRevenue", revenue);

        try {
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (ServletException e) {
            throw new IOException(e);
        }
    }
}
