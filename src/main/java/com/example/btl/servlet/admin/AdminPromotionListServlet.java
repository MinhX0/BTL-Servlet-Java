package com.example.btl.servlet.admin;

import com.example.btl.model.Promotion;
import com.example.btl.model.User;
import com.example.btl.service.PromotionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminPromotionListServlet", urlPatterns = {"/admin/promotions"})
public class AdminPromotionListServlet extends HttpServlet {
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Promotion> promotions = promotionService.getAllPromotions();
        request.setAttribute("promotions", promotions);
        request.getRequestDispatcher("/admin/promotions.jsp").forward(request, response);
    }
}
