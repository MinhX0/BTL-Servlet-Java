package com.example.btl.servlet;

import com.example.btl.dao.OtpTokenDAO;
import com.example.btl.dao.UserDAO;
import com.example.btl.model.User;
import com.example.btl.service.EmailService;
import com.example.btl.service.OtpService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "VerifyOtpServlet", urlPatterns = {"/verify-otp"})
public class VerifyOtpServlet extends HttpServlet {
    private OtpService otpService;
    private UserDAO userDAO;

    @Override
    public void init() {
        this.otpService = new OtpService(new OtpTokenDAO(), new EmailService());
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.getRequestDispatcher("/WEB-INF/jsp/otp/verify.jsp").forward(request, response);
        } catch (ServletException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        User user = (User) session.getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        String purpose = request.getParameter("purpose");
        String code = request.getParameter("code");
        if (purpose == null || purpose.isBlank()) purpose = "REGISTER";
        if (code != null) code = code.trim();

        // Server-side format validation (must be exactly 6 digits)
        if (code == null || !code.matches("^[0-9]{6}$")) {
            request.setAttribute("otpError", "Mã OTP phải gồm đúng 6 chữ số.");
            try {
                request.getRequestDispatcher("/WEB-INF/jsp/otp/verify.jsp").forward(request, response);
            } catch (ServletException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        boolean ok = otpService.verifyAndConsume(user, purpose, code);
        if (!ok) {
            request.setAttribute("otpError", "Mã OTP không hợp lệ hoặc đã hết hạn.");
            try {
                request.getRequestDispatcher("/WEB-INF/jsp/otp/verify.jsp").forward(request, response);
            } catch (ServletException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            return;
        }

        // On success, mark verification flags in session for the flow controller to act on
        session.setAttribute("otpVerified:" + purpose, Boolean.TRUE);
        String next = (String) session.getAttribute("otpNext:" + purpose);
        session.removeAttribute("otpNext:" + purpose);
        response.sendRedirect(next != null ? next : (request.getContextPath() + "/index"));
    }
}
