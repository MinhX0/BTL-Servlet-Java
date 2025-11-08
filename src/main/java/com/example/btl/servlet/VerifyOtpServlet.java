package com.example.btl.servlet;

import com.example.btl.dao.OtpTokenDAO;
import com.example.btl.dao.UserDAO;
import com.example.btl.model.OtpToken;
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
        HttpSession session = request.getSession(true); // create if missing to hold state
        String purpose = request.getParameter("purpose");
        String code = request.getParameter("code");
        if (purpose == null || purpose.isBlank()) purpose = "REGISTER";
        if (code != null) code = code.trim();

        // Server-side format validation (must be exactly 6 digits)
        if (code == null || !code.matches("^[0-9]{6}$")) {
            request.setAttribute("otpError", "Mã OTP phải gồm đúng 6 chữ số.");
            try { request.getRequestDispatcher("/WEB-INF/jsp/otp/verify.jsp").forward(request, response);} catch (ServletException e) {response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);} return; }

        // If we have a pending user, verify code belongs to that user to avoid stale/other-user codes
        Object pending = session.getAttribute("pendingUserId");
        User verifiedUser = null;
        if (pending instanceof Integer) {
            int uid = (Integer) pending;
            User u = userDAO.getUserById(uid);
            if (u != null) {
                boolean ok = otpService.verifyAndConsume(u, purpose, code);
                if (!ok) {
                    request.setAttribute("otpError", "Mã OTP không hợp lệ hoặc đã được thay thế. Vui lòng dùng mã mới.");
                    try { request.getRequestDispatcher("/WEB-INF/jsp/otp/verify.jsp").forward(request, response);} catch (ServletException e) {response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);} return; }
                verifiedUser = u;
            }
        }

        // If no pending user, fallback to code-based verification (e.g., user clicked email link)
        if (verifiedUser == null) {
            OtpToken consumed = otpService.verifyAndConsumeByCode(purpose, code);
            if (consumed == null) {
                request.setAttribute("otpError", "Mã OTP không hợp lệ hoặc đã hết hạn.");
                try { request.getRequestDispatcher("/WEB-INF/jsp/otp/verify.jsp").forward(request, response);} catch (ServletException e) {response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);} return; }
            verifiedUser = consumed.getUser();
            // Store pending user id now for consistent flow
            if (verifiedUser != null) {
                session.setAttribute("pendingUserId", verifiedUser.getId());
            }
        }

        // Activate user if it's a registration flow, then auto-login
        if ("REGISTER".equalsIgnoreCase(purpose)) {
            try {
                if (verifiedUser != null && (verifiedUser.getActive() == null || !verifiedUser.getActive())) {
                    verifiedUser.setActive(Boolean.TRUE);
                    userDAO.updateUser(verifiedUser);
                }
                session.setAttribute("user", verifiedUser);
            } catch (Exception ex) {
                request.setAttribute("otpError", "Không thể kích hoạt tài khoản. Vui lòng liên hệ hỗ trợ.");
                try { request.getRequestDispatcher("/WEB-INF/jsp/otp/verify.jsp").forward(request, response);} catch (ServletException e) {response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);} return; }
        }

        // Clear pending marker
        session.removeAttribute("pendingUserId");
        session.setAttribute("otpVerified:" + purpose, Boolean.TRUE);
        String next = (String) session.getAttribute("otpNext:" + purpose);
        session.removeAttribute("otpNext:" + purpose);
        response.sendRedirect(next != null ? next : (request.getContextPath() + "/index"));
    }
}
