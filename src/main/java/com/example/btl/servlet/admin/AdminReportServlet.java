package com.example.btl.servlet.admin;

import com.example.btl.dao.OrderDAO;
import com.example.btl.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminReportServlet", urlPatterns = {"/admin/reports", "/admin/report"})
public class AdminReportServlet extends HttpServlet {
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

        int year;
        try {
            year = Integer.parseInt(request.getParameter("year"));
        } catch (Exception e) {
            year = LocalDate.now().getYear();
        }

        // Monthly revenue
        List<Object[]> revRows = orderDAO.monthlyRevenue(year);
        long[] revenueByMonth = new long[12];
        for (Object[] r : revRows) {
            int m = ((Number) r[0]).intValue();
            BigDecimal val = (BigDecimal) r[1];
            if (m >= 1 && m <= 12) revenueByMonth[m - 1] = val.longValue();
        }

        // Monthly order count
        List<Object[]> cntRows = orderDAO.monthlyOrderCount(year);
        long[] countByMonth = new long[12];
        for (Object[] r : cntRows) {
            int m = ((Number) r[0]).intValue();
            long val = ((Number) r[1]).longValue();
            if (m >= 1 && m <= 12) countByMonth[m - 1] = val;
        }

        // Top products by revenue
        List<Object[]> topRows = orderDAO.topProductsByRevenue(year, 10);
        List<Map<String, Object>> topProducts = new ArrayList<>();
        for (Object[] r : topRows) {
            Map<String, Object> row = new HashMap<>();
            row.put("productId", r[0]);
            row.put("name", r[1]);
            row.put("revenue", r[2]);
            row.put("qty", r[3]);
            topProducts.add(row);
        }

        request.setAttribute("year", year);
        request.setAttribute("revenueByMonth", revenueByMonth);
        request.setAttribute("countByMonth", countByMonth);
        request.setAttribute("topProducts", topProducts);

        try {
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        } catch (ServletException e) {
            throw new IOException(e);
        }
    }
}

