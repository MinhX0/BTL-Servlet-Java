package com.example.btl.servlet;

import com.example.btl.model.User;
import com.example.btl.dao.UserDAO;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");
            String redirect;
            if (u.isAdmin()) redirect = "/admin"; // admin root (dashboard area)
            else if (u.isSeller()) redirect = "/admin"; // changed: send seller to dashboard
            else redirect = "/index";
            response.sendRedirect(request.getContextPath() + redirect);
            return;
        }

        // Redirect to combined login/register page
        try {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            try { request.getRequestDispatcher("/login.jsp").forward(request, response);} catch (Exception e) { e.printStackTrace(); response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);} return; }

        // Try normal authentication (only returns active users)
        User user = userDAO.authenticateUser(username, password);
        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("name", user.getName());
            session.setMaxInactiveInterval(30 * 60);
            String redirect;
            if (user.isAdmin()) redirect = "/admin";
            else if (user.isSeller()) redirect = "/admin/dashboard.jsp"; // changed seller redirect
            else redirect = "/index";
            response.sendRedirect(request.getContextPath() + redirect);
            return;
        }

        // If authentication failed, check if the account exists but is inactive (disabled)
        User inactive = userDAO.findByUsernameOrEmail(username);
        if (inactive != null && (inactive.getActive() != null && !inactive.getActive())) {
            // Do NOT attempt OTP resend for disabled accounts. Inform the user instead.
            request.setAttribute("error", "Your account has been disabled. Please contact the administrator or support.");
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // Authentication failed normally
        request.setAttribute("error", "Invalid username or password");
        try { request.getRequestDispatcher("/login.jsp").forward(request, response);} catch (Exception e) { e.printStackTrace(); response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);} }
}
