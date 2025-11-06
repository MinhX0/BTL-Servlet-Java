package com.example.btl.servlet;

import com.example.btl.model.User;
import com.example.btl.dao.UserDAO;
import com.example.btl.dao.OtpTokenDAO;
import com.example.btl.service.EmailService;
import com.example.btl.service.OtpService;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;
    private OtpService otpService;

    @Override
    public void init() {
        userDAO = new UserDAO();
        otpService = new OtpService(new OtpTokenDAO(), new EmailService());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }
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

        if (isBlank(name) || isBlank(username) || isBlank(email) || isBlank(password) || isBlank(confirmPassword)) {
            setErrorsAndBack(request, response, "All required fields must be filled", name, username, email, phoneNumber, address);
            return;
        }
        if (!password.equals(confirmPassword)) {
            setErrorsAndBack(request, response, "Passwords do not match", name, username, email, phoneNumber, address);
            return;
        }
        if (userDAO.usernameExists(username)) {
            setErrorsAndBack(request, response, "Username already exists", name, null, email, phoneNumber, address);
            return;
        }
        if (userDAO.emailExists(email)) {
            setErrorsAndBack(request, response, "Email already exists", name, username, null, phoneNumber, address);
            return;
        }

        // Create new user as inactive until OTP is verified
        User newUser = new User(username, password, name, email, phoneNumber, address);
        newUser.setActive(Boolean.FALSE);
        if (!userDAO.registerUser(newUser)) {
            setErrorsAndBack(request, response, "Registration failed. Please try again.", name, username, email, phoneNumber, address);
            return;
        }

        // Fire OTP to email
        HttpSession session = request.getSession(true);
        session.setAttribute("user", newUser);
        session.setAttribute("userId", newUser.getId());
        String base = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
        otpService.sendOtp(newUser, "REGISTER", 10, base);
        // After verify, go to index
        session.setAttribute("otpNext:REGISTER", request.getContextPath() + "/index");
        response.sendRedirect(request.getContextPath() + "/verify-otp?purpose=REGISTER");
    }

    private void setErrorsAndBack(HttpServletRequest request, HttpServletResponse response, String msg,
                                  String name, String username, String email, String phone, String address) throws IOException {
        request.setAttribute("registerError", msg);
        request.setAttribute("name", name);
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        try { request.getRequestDispatcher("/login.jsp").forward(request, response); }
        catch (Exception e) { e.printStackTrace(); response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); }
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
