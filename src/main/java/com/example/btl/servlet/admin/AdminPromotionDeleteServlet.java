package com.example.btl.servlet.admin;

import com.example.btl.model.User;
import com.example.btl.service.PromotionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AdminPromotionDeleteServlet", urlPatterns = {"/admin/promotions/delete"})
public class AdminPromotionDeleteServlet extends HttpServlet {
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                promotionService.deletePromotion(id);
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/promotions");
    }
}

