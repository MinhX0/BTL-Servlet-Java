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
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "AdminPromotionEditServlet", urlPatterns = {"/admin/promotions/edit"})
public class AdminPromotionEditServlet extends HttpServlet {
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

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Promotion promotion = promotionService.getPromotionById(id);
                if (promotion != null) {
                    request.setAttribute("promotion", promotion);
                    request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/promotions");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
                return;
            }

            int id = Integer.parseInt(idStr);
            Promotion promotion = promotionService.getPromotionById(id);

            if (promotion == null) {
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
                return;
            }

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String discountTypeStr = request.getParameter("discountType");
            String discountValueStr = request.getParameter("discountValue");
            String minOrderAmountStr = request.getParameter("minOrderAmount");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String isActiveStr = request.getParameter("isActive");

            // Update fields
            promotion.setName(name.trim());
            promotion.setDescription(description != null ? description.trim() : "");
            promotion.setDiscountType(Promotion.DiscountType.valueOf(discountTypeStr));
            promotion.setDiscountValue(new BigDecimal(discountValueStr));
            promotion.setMinOrderAmount(minOrderAmountStr != null && !minOrderAmountStr.trim().isEmpty()
                ? new BigDecimal(minOrderAmountStr) : BigDecimal.ZERO);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            promotion.setStartDate(LocalDateTime.parse(startDateStr, formatter));
            promotion.setEndDate(LocalDateTime.parse(endDateStr, formatter));
            promotion.setActive(isActiveStr != null && isActiveStr.equals("on"));

            boolean success = promotionService.updatePromotion(promotion);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
            } else {
                request.setAttribute("error", "Failed to update promotion");
                request.setAttribute("promotion", promotion);
                request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
        }
    }
}

