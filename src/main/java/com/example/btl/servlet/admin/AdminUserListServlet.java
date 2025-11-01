package com.example.btl.servlet.admin;

import com.example.btl.dao.UserDAO;
import com.example.btl.model.Role;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserListServlet", urlPatterns = {"/admin/users"})
public class AdminUserListServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User actor = session != null ? (User) session.getAttribute("user") : null;
        if (actor == null || !actor.isAdmin()) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String role = request.getParameter("role");
        String active = request.getParameter("active");
        Role roleFilter = null;
        if (role != null && !role.isBlank()) {
            try { roleFilter = Role.valueOf(role.toUpperCase()); } catch (Exception ignored) {}
        }
        Boolean activeFilter = null;
        if (active != null && !active.isBlank()) {
            activeFilter = ("1".equals(active) || "true".equalsIgnoreCase(active));
        }
        List<User> users = (roleFilter == null && activeFilter == null) ? userDAO.getAllUsers() : userDAO.search(roleFilter, activeFilter);
        request.setAttribute("users", users);
        try {
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

