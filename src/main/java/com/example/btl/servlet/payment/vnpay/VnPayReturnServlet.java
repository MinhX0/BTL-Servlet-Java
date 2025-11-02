package com.example.btl.servlet.payment.vnpay;

import com.example.btl.dao.OrderDAO;
import com.example.btl.model.Order;
import com.example.btl.model.OrderStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "VnPayReturnServlet", urlPatterns = {"/vnpay_return"})
public class VnPayReturnServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleReturn(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleReturn(request, response);
    }

    private void handleReturn(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Build field map for signature verification (URL-encoded values, sorted by name)
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
        // Remove hash fields before computing signature
        fields.remove(URLEncoder.encode("vnp_SecureHashType", StandardCharsets.US_ASCII));
        fields.remove(URLEncoder.encode("vnp_SecureHash", StandardCharsets.US_ASCII));

        String signValue = Config.hashAllFields(fields);

        // Extract relevant parameters
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_BankCode = request.getParameter("vnp_BankCode");
        String vnp_PayDate = request.getParameter("vnp_PayDate");
        String vnp_TransactionStatusParam = request.getParameter("vnp_TransactionStatus");

        boolean signatureValid = signValue != null && signValue.equals(vnp_SecureHash);
        boolean responseOk = "00".equals(vnp_ResponseCode);
        boolean txnStatusOk = "00".equals(vnp_TransactionStatusParam);
        boolean txnSuccess = signatureValid && (responseOk || txnStatusOk);
        String vnp_TransactionStatusText;
        if (!signatureValid) {
            vnp_TransactionStatusText = "invalid signature";
        } else {
            vnp_TransactionStatusText = txnSuccess ? "Thành công" : "Không thành công";
        }

        // Amount from VNPay is in minor units (x100). Prepare a display value.
        String amountDisplay = null;
        try {
            long minor = Long.parseLong(vnp_Amount != null ? vnp_Amount : "0");
            long majorInt = minor / 100;
            long cents = Math.abs(minor % 100);
            amountDisplay = String.format("%d.%02d", majorInt, cents);
        } catch (NumberFormatException ignored) { amountDisplay = vnp_Amount; }

        // Also check server-side order status using vnp_TxnRef as internal orderId
        boolean orderExists = false;
        boolean orderPaid = false;
        boolean updatedByReturn = false;
        String orderStatusStr = null;
        Integer orderId = null;
        try {
            if (vnp_TxnRef != null) {
                orderId = Integer.valueOf(vnp_TxnRef);
                Order order = orderDAO.getById(orderId);
                if (order != null) {
                    orderExists = true;
                    OrderStatus st = order.getStatus();
                    orderStatusStr = st != null ? st.name() : null;
                    orderPaid = (st == OrderStatus.Processing || st == OrderStatus.Shipped || st == OrderStatus.Delivered);
                    // Fallback for dev: if payment success and not yet marked paid, update now
                    if (txnSuccess && !orderPaid) {
                        if (orderDAO.updateStatus(orderId, OrderStatus.Processing)) {
                            updatedByReturn = true;
                            orderPaid = true;
                            orderStatusStr = OrderStatus.Processing.name();
                        }
                    }
                }
            }
        } catch (Exception ignored) { }

        // Set attributes for JSP rendering
        request.setAttribute("vnp_TxnRef", vnp_TxnRef);
        request.setAttribute("vnp_Amount", vnp_Amount);
        request.setAttribute("amountDisplay", amountDisplay);
        request.setAttribute("vnp_ResponseCode", vnp_ResponseCode);
        request.setAttribute("vnp_OrderInfo", vnp_OrderInfo);
        request.setAttribute("vnp_TransactionNo", vnp_TransactionNo);
        request.setAttribute("vnp_BankCode", vnp_BankCode);
        request.setAttribute("vnp_PayDate", vnp_PayDate);
        request.setAttribute("vnp_TransactionStatus", vnp_TransactionStatusText);
        request.setAttribute("signatureValid", signatureValid);
        request.setAttribute("computedHash", signValue);
        // Server-side status
        request.setAttribute("orderId", orderId);
        request.setAttribute("orderExists", orderExists);
        request.setAttribute("orderStatus", orderStatusStr);
        request.setAttribute("orderPaid", orderPaid);
        request.setAttribute("updatedByReturn", updatedByReturn);

        // Forward to a result page
        try {
            request.getRequestDispatcher("/payment/vnpay/result.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
