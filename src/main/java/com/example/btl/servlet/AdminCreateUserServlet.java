package com.example.btl.servlet;

import com.example.btl.dao.UserDAO;
import com.example.btl.dto.UserCreateRequest;
import com.example.btl.model.Role;
import com.example.btl.model.User;
import com.example.btl.service.UserService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminCreateUserServlet", value = "/admin/add-user")
public class AdminCreateUserServlet extends HttpServlet {
    private UserService userService;
    private static final Logger logger = Logger.getLogger(AdminCreateUserServlet.class.getName());

    @Override
    public void init() {
        userService = new UserService(new UserDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User actor = session != null ? (User) session.getAttribute("user") : null;
        if (actor == null || actor.getRole() != Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            request.getRequestDispatcher("/admin/add-user.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error forwarding to add-user.jsp", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User actor = session != null ? (User) session.getAttribute("user") : null;
        if (actor == null || actor.getRole() != Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roleParam = request.getParameter("role");

        UserCreateRequest req = new UserCreateRequest();
        req.setUsername(username);
        req.setEmail(email);
        req.setName(name);
        req.setPassword(password);
        req.setPhoneNumber(phone);
        req.setAddress(address);
        req.setRole(Role.fromCode(roleParam));

        try {
            boolean ok = userService.createUserAsAdmin(actor, req);
            if (ok) {
                request.setAttribute("success", "User created successfully");
            } else {
                request.setAttribute("error", "Failed to create user");
            }
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            logger.log(Level.SEVERE, "Unexpected error creating user", ex);
            request.setAttribute("error", "Unexpected error: " + ex.getMessage());
        }
        try {
            request.getRequestDispatcher("/admin/add-user.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error forwarding back to add-user.jsp", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
