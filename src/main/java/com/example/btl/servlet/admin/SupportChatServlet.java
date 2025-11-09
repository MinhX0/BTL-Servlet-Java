package com.example.btl.servlet.admin;

import com.example.btl.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SupportChatServlet", urlPatterns = {"/admin/support-chat"})
public class SupportChatServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!user.isSeller() && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }
        try {
            request.getRequestDispatcher("/admin/support-chat.jsp").forward(request, response);
        } catch (ServletException e) {
            throw new IOException(e);
        }
    }
}

