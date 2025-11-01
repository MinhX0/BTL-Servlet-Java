package com.example.btl.servlet;

import com.example.btl.dao.UserDAO;
import com.example.btl.model.User;
import com.example.btl.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AccountServlet", urlPatterns = {"/account", "/account/*"})
public class AccountServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp#login");
            return;
        }
        User u = (User) session.getAttribute("user");
        if (u.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }
        try {
            request.getRequestDispatcher("/my-account.jsp").forward(request, response);
        } catch (ServletException e) {
            // Forwarding failed
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo();
        if (path == null) path = "";
        switch (path) {
            case "/profile":
                handleProfileUpdate(request, response);
                break;
            case "/password":
                handleChangePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp#login");
            return;
        }
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        String name = trimOrNull(request.getParameter("name"));
        String email = trimOrNull(request.getParameter("email"));
        String phoneNumber = trimOrNull(request.getParameter("phoneNumber"));
        String address = trimOrNull(request.getParameter("address"));

        if (name == null || email == null) {
            request.setAttribute("profileError", "Name and email are required.");
            forwardAccount(request, response);
            return;
        }

        // If email changed, ensure uniqueness
        User existingByEmail = userDAO.getUserByEmail(email);
        if (existingByEmail != null && existingByEmail.getId() != sessionUser.getId()) {
            request.setAttribute("profileError", "Email is already in use.");
            forwardAccount(request, response);
            return;
        }

        // Update fields
        sessionUser.setName(name);
        sessionUser.setEmail(email);
        sessionUser.setPhoneNumber(phoneNumber);
        sessionUser.setAddress(address);

        boolean ok = userDAO.updateUser(sessionUser);
        if (ok) {
            // Refresh session user from DB to reflect latest state
            User refreshed = userDAO.getUserById(sessionUser.getId());
            if (refreshed != null) {
                session.setAttribute("user", refreshed);
                session.setAttribute("name", refreshed.getName());
                session.setAttribute("username", refreshed.getUsername());
                session.setAttribute("role", refreshed.getRole());
            }
            request.setAttribute("profileSuccess", "Profile updated successfully.");
        } else {
            request.setAttribute("profileError", "Failed to update profile. Please try again.");
        }
        forwardAccount(request, response);
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp#login");
            return;
        }
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            request.setAttribute("passwordError", "All password fields are required.");
            forwardAccount(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("passwordError", "New passwords do not match.");
            forwardAccount(request, response);
            return;
        }
        // Verify current password
        if (!PasswordUtil.verifyPassword(currentPassword, sessionUser.getPassword())) {
            request.setAttribute("passwordError", "Current password is incorrect.");
            forwardAccount(request, response);
            return;
        }

        // Hash new password and update
        String hashed = PasswordUtil.hashPassword(newPassword);
        sessionUser.setPassword(hashed);
        boolean ok = userDAO.updateUser(sessionUser);
        if (ok) {
            request.setAttribute("passwordSuccess", "Password changed successfully.");
        } else {
            request.setAttribute("passwordError", "Failed to change password. Please try again.");
        }
        forwardAccount(request, response);
    }

    private void forwardAccount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.getRequestDispatcher("/my-account.jsp").forward(request, response);
        } catch (ServletException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private static String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
        }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
