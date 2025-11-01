package com.example.btl.servlet.admin;

import com.example.btl.dao.CategoryDAO;
import com.example.btl.model.Category;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryListServlet", urlPatterns = {"/admin/categories"})
public class AdminCategoryListServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        this.categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        List<Category> categories = categoryDAO.listAll();
        request.setAttribute("categories", categories);
        try {
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

