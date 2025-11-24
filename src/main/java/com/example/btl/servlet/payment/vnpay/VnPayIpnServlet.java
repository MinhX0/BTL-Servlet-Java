package com.example.btl.servlet.payment.vnpay;

import com.example.btl.dao.OrderDAO;
import com.example.btl.model.OrderStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "VnPayIpnServlet", urlPatterns = {"/vnpay_ipn"})
public class VnPayIpnServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleIpn(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // VNPay may call via GET in some setups
        handleIpn(request, response);
    }

    private void handleIpn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Build field map (URL-encoded) and verify signature
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String rawName = params.nextElement();
                String encodedName = URLEncoder.encode(rawName, StandardCharsets.US_ASCII.toString());
                String rawValue = request.getParameter(rawName);
                String encodedValue = rawValue != null ? URLEncoder.encode(rawValue, StandardCharsets.US_ASCII.toString()) : null;
                if (encodedValue != null && !encodedValue.isEmpty()) {
                    fields.put(encodedName, encodedValue);
                }
            }
            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            fields.remove(URLEncoder.encode("vnp_SecureHashType", StandardCharsets.US_ASCII));
            fields.remove(URLEncoder.encode("vnp_SecureHash", StandardCharsets.US_ASCII));

            String signValue = Config.hashAllFields(fields);
            boolean signatureValid = signValue != null && signValue.equals(vnp_SecureHash);
            if (!signatureValid) {
                out.print("{\"RspCode\":\"97\",\"Message\":\"Invalid signature\"}");
                return;
            }

            // Extract VNPay fields
            String vnp_TxnRef = request.getParameter("vnp_TxnRef"); // we use internal order_id here
            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");

            int orderId;
            try {
                orderId = Integer.parseInt(vnp_TxnRef);
            } catch (Exception e) {
                out.print("{\"RspCode\":\"01\",\"Message\":\"Invalid order reference\"}");
                return;
            }

            // vnp_ResponseCode: 00 = success, 24 = user cancelled, others = failed/cancelled
            OrderStatus newStatus;
            if ("00".equals(vnp_ResponseCode)) {
                newStatus = OrderStatus.Processing;
            } else {
                // Any non-success code (24 = user cancelled, 07 = suspicious transaction, etc.)
                newStatus = OrderStatus.Cancelled;
            }

            boolean updated = orderDAO.updateStatus(orderId, newStatus);
            if (updated) {
                out.print("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            } else {
                out.print("{\"RspCode\":\"02\",\"Message\":\"Order not found or not updated\"}");
            }
        }
    }
}
