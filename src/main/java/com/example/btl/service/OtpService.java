package com.example.btl.service;

import com.example.btl.dao.OtpTokenDAO;
import com.example.btl.model.OtpToken;
import com.example.btl.model.User;

import java.security.SecureRandom;
import java.time.LocalDateTime;

public class OtpService {
    private final OtpTokenDAO otpTokenDAO;
    private final EmailService emailService;
    private final SecureRandom random = new SecureRandom();

    public OtpService(OtpTokenDAO otpTokenDAO, EmailService emailService) {
        this.otpTokenDAO = otpTokenDAO;
        this.emailService = emailService;
    }

    public String generateCode() {
        int code = 100000 + random.nextInt(900000); // 6 digits
        return String.valueOf(code);
    }

    public boolean sendOtp(User user, String purpose, int ttlMinutes, String appBaseUrl) {
        // delete old tokens of same purpose
        otpTokenDAO.deleteByUserPurpose(user.getId(), purpose);
        String code = generateCode();
        OtpToken token = new OtpToken();
        token.setUser(user);
        token.setPurpose(purpose);
        token.setCode(code);
        token.setExpiresAt(LocalDateTime.now().plusMinutes(ttlMinutes));
        if (otpTokenDAO.create(token) == null) return false;
        String subject = "Mã xác thực OTP";
        String html = "<p>Xin chào " + escape(user.getName()) + ",</p>" +
                "<p>Mã OTP của bạn là: <strong>" + code + "</strong> (hết hạn sau " + ttlMinutes + " phút).</p>" +
                (appBaseUrl != null && !appBaseUrl.isBlank() ? "<p>Hoặc bấm liên kết: <a href='" + appBaseUrl + "/verify-otp?purpose=" + purpose + "&code=" + code + "'>Xác nhận</a></p>" : "") +
                "<p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>" +
                "<p>— Anh em cay khe Corporation</p>";
        return emailService.send(user.getEmail(), subject, html);
    }

    public boolean verifyAndConsume(User user, String purpose, String code) {
        if (user == null || code == null || code.isBlank()) return false;
        OtpToken t = otpTokenDAO.findByUserCodePurpose(user.getId(), code.trim(), purpose);
        if (t == null) return false;
        if (t.isConsumed() || t.isExpired()) return false;
        return otpTokenDAO.consume(t);
    }

    public OtpToken verifyAndConsumeByCode(String purpose, String code) {
        if (code == null || code.isBlank()) return null;
        OtpToken t = otpTokenDAO.findByCodeAndPurpose(code.trim(), purpose);
        if (t == null) return null;
        if (t.isConsumed() || t.isExpired()) return null;
        return otpTokenDAO.consume(t) ? t : null;
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
