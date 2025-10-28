package com.example.btl.servlet;

import com.example.btl.model.User;
import com.example.btl.dao.UserDAO;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/register")
public class RegisterServlet extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
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
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        String phoneNumber = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate input
        if (name == null || name.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("registerError", "All required fields must be filled");
            request.setAttribute("name", name);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phoneNumber);
            request.setAttribute("address", address);
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("registerError", "Passwords do not match");
            request.setAttribute("name", name);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phoneNumber);
            request.setAttribute("address", address);
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // Check if username already exists
        if (userDAO.usernameExists(username)) {
            request.setAttribute("registerError", "Username already exists");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phoneNumber);
            request.setAttribute("address", address);
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("registerError", "Email already exists");
            request.setAttribute("name", name);
            request.setAttribute("username", username);
            request.setAttribute("phone", phoneNumber);
            request.setAttribute("address", address);
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // Create new user (default CUSTOMER role)
        User newUser = new User(username, password, name, email, phoneNumber, address);

        if (userDAO.registerUser(newUser)) {
            request.setAttribute("registerSuccess", "Registration successful! Please login.");
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            request.setAttribute("registerError", "Registration failed. Please try again.");
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}
