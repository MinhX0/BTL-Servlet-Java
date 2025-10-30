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
            response.sendRedirect(request.getContextPath() + "/index");
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

        // Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // Authenticate user
        User user = userDAO.authenticateUser(username, password);

        if (user != null) {
            // Create session and store user
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("name", user.getName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Navigate back to index screen
            response.sendRedirect(request.getContextPath() + "/index");
        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid username or password");
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}
