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

@WebServlet(name = "AdminCategoryCreateServlet", urlPatterns = {"/admin/categories/new"})
public class AdminCategoryCreateServlet extends HttpServlet {
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

        try {
            request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String parentIdStr = request.getParameter("parentId");
        Integer parentId = null;
        try { if (parentIdStr != null && !parentIdStr.isBlank()) parentId = Integer.parseInt(parentIdStr); } catch (NumberFormatException ignored) {}

        Category c = new Category();
        c.setName(name);
        c.setSlug(slug);
        c.setActive(Boolean.TRUE);
        if (parentId != null) {
            Category parent = categoryDAO.getById(parentId);
            c.setParent(parent);
        }
        categoryDAO.create(c);
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}

