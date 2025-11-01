package com.example.btl.servlet.admin;

import com.example.btl.dao.UserDAO;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminUserActionServlet", urlPatterns = {"/admin/users/action"})
public class AdminUserActionServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User actor = session != null ? (User) session.getAttribute("user") : null;
        if (actor == null || !actor.isAdmin()) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String idStr = request.getParameter("userId");
        String action = request.getParameter("action");
        try {
            int userId = Integer.parseInt(idStr);
            if ("deactivate".equalsIgnoreCase(action)) {
                userDAO.setActive(userId, false);
            } else if ("activate".equalsIgnoreCase(action)) {
                userDAO.setActive(userId, true);
            } else if ("delete".equalsIgnoreCase(action)) {
                userDAO.deleteUser(userId);
            }
        } catch (Exception ignored) {}
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}

