package com.example.btl.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailService {
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());

    private final String host;
    private final int port;
    private final String username;
    private final String password;
    private final String from;
    private final boolean debug;

    public EmailService() {
        Properties fileProps = loadFileProps();
        this.host = get("MAIL_HOST", fileProps, "smtp.gmail.com");
        this.port = parseInt(get("MAIL_PORT", fileProps, "587"), 587);
        this.username = get("MAIL_USERNAME", fileProps, "");
        this.password = get("MAIL_PASSWORD", fileProps, "");
        String fromCandidate = get("MAIL_FROM", fileProps, "");
        this.from = (fromCandidate == null || fromCandidate.isBlank()) ? this.username : fromCandidate;
        this.debug = Boolean.parseBoolean(get("MAIL_DEBUG", fileProps, "true"));
        if (password != null && password.contains(" ")) {
            LOGGER.warning("[EmailService] MAIL_PASSWORD contains spaces. For Gmail App Passwords it should be 16 chars without spaces. Current length=" + password.length());
        }
        if (isBlank(username) || isBlank(password)) {
            LOGGER.warning("[EmailService] MAIL_USERNAME or MAIL_PASSWORD not set. Email sending will be disabled.");
        }
    }

    private Properties loadFileProps() {
        Properties p = new Properties();
        // Priority 1: explicit file path via env/system property
        String path = or(System.getenv("MAIL_CONFIG_FILE"), System.getProperty("MAIL_CONFIG_FILE"));
        if (!isBlank(path)) {
            try (FileInputStream fis = new FileInputStream(path)) {
                p.load(fis);
                LOGGER.info("[EmailService] Loaded mail config from file: " + path);
                return p;
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "[EmailService] Failed to load MAIL_CONFIG_FILE='" + path + "': " + e.getMessage());
            }
        }
        // Priority 2: classpath local-only resource (ignored in VCS): mail.properties.local
        try (InputStream is = EmailService.class.getClassLoader().getResourceAsStream("mail.properties.local")) {
            if (is != null) {
                p.load(is);
                LOGGER.info("[EmailService] Loaded mail config from classpath: mail.properties.local");
                return p;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "[EmailService] Failed to load classpath mail.properties.local: " + e.getMessage());
        }
        return p; // empty
    }

    private String get(String key, Properties fileProps, String def) {
        String v = System.getenv(key);
        if (!isBlank(v)) return v;
        v = System.getProperty(key);
        if (!isBlank(v)) return v;
        v = fileProps.getProperty(key);
        if (!isBlank(v)) return v;
        return def;
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
    private String or(String a, String b) { return !isBlank(a) ? a : b; }
    private int parseInt(String s, int d) { try { return Integer.parseInt(s); } catch (Exception e) { return d; } }

    private Session buildSession() {
        Properties props = new Properties();
        // Core SMTP settings
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", String.valueOf(port != 465));
        props.put("mail.smtp.starttls.required", String.valueOf(port != 465));
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", String.valueOf(port));
        // Timeouts (millis)
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "15000");
        props.put("mail.smtp.writetimeout", "15000");
        // Trust server
        props.put("mail.smtp.ssl.trust", host);
        // SSL on 465 only
        props.put("mail.smtp.ssl.enable", String.valueOf(port == 465));

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        };
        Session session = Session.getInstance(props, auth);
        session.setDebug(debug);
        return session;
    }

    /**
     * Send HTML email. Returns true if sent successfully, false otherwise.
     */
    public boolean send(String to, String subject, String html) {
        if (to == null || to.isBlank()) {
            LOGGER.warning("[EmailService] 'to' address is blank");
            return false;
        }
        if (isBlank(username) || isBlank(password)) {
            LOGGER.severe("[EmailService] Missing MAIL_USERNAME/MAIL_PASSWORD. Aborting send.");
            return false;
        }
        try {
            Session session = buildSession();
            Properties p = session.getProperties();
            LOGGER.info("[EmailService] Attempting SMTP send host=" + p.getProperty("mail.smtp.host") + ":" + p.getProperty("mail.smtp.port") +
                    " starttls=" + p.getProperty("mail.smtp.starttls.enable") + " ssl=" + p.getProperty("mail.smtp.ssl.enable"));
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            // Support multiple recipients separated by comma / semicolon
            String normalized = to.replace(';', ',');
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(normalized));
            message.setSubject(subject == null ? "(No subject)" : subject, "UTF-8");
            message.setContent(html == null ? "" : html, "text/html; charset=UTF-8");
            // Explicit connect to log auth problems
            Transport transport = session.getTransport("smtp");
            try {
                transport.connect(host, port, username, password);
                transport.sendMessage(message, message.getAllRecipients());
            } finally {
                try { transport.close(); } catch (Exception ignore) {}
            }
            LOGGER.info("[EmailService] Sent email to: " + normalized + " subject='" + subject + "' length=" + (html == null ? 0 : html.length()));
            return true;
        } catch (AuthenticationFailedException ex) {
            LOGGER.log(Level.SEVERE, "[EmailService] Authentication failed for configured user: " + ex.getMessage(), ex);
            return false;
        } catch (SendFailedException ex) {
            LOGGER.log(Level.SEVERE, "[EmailService] Send failed: invalid addresses to=" + to + " err=" + ex.getMessage(), ex);
            return false;
        } catch (MessagingException ex) {
            LOGGER.log(Level.SEVERE, "[EmailService] Messaging exception: " + ex.getMessage(), ex);
            return false;
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "[EmailService] Unexpected error: " + ex.getMessage(), ex);
            return false;
        }
    }

    /**
     * Convenience method to send a plain-text email.
     */
    public boolean sendPlain(String to, String subject, String text) {
        return send(to, subject, text == null ? "" : ("<pre style='font-family:monospace'>" + escapeHtml(text) + "</pre>"));
    }

    /**
     * Send a simple OTP message (returns OTP used) or null if send failed.
     */
    public String sendOtp(String to, String actionLabel) {
        String otp = generateOtp(6);
        String safeAction = actionLabel == null ? "Xác thực" : actionLabel;
        String html = "<div style='font-family:Arial,sans-serif;font-size:14px'>" +
                "<p>Xin chào,</p>" +
                "<p>Mã OTP cho thao tác <strong>" + escapeHtml(safeAction) + "</strong> của bạn là:</p>" +
                "<p style='font-size:24px;letter-spacing:4px;font-weight:bold'>" + otp + "</p>" +
                "<p>Mã có hiệu lực trong 5 phút. Không chia sẻ mã này với bất kỳ ai.</p>" +
                "<hr><p>Trân trọng,<br/>Hệ thống Shoes Huong Sandals</p></div>";
        boolean sent = send(to, "Mã OTP xác thực", html);
        return sent ? otp : null;
    }

    private String generateOtp(int digits) {
        StringBuilder sb = new StringBuilder(digits);
        for (int i = 0; i < digits; i++) {
            sb.append((int) (Math.random() * 10));
        }
        return sb.toString();
    }

    private String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    // Getters (optional if needed externally)
    public String getHost() { return host; }
    public int getPort() { return port; }
    public String getUsername() { return username; }
    public String getFrom() { return from; }
    public boolean isDebug() { return debug; }
}
