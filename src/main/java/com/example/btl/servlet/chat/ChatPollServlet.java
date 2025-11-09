package com.example.btl.servlet.chat;

import com.example.btl.model.User;
import com.example.btl.service.ChatStore;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ChatPollServlet", urlPatterns = {"/chat/poll"})
public class ChatPollServlet extends HttpServlet {
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendError(HttpServletResponse.SC_UNAUTHORIZED); return; }

        String afterStr = req.getParameter("after");
        long after = 0L;
        if (afterStr != null) {
            try { after = Long.parseLong(afterStr); } catch (NumberFormatException ignored) {}
        }
        if (user.isCustomer()) {
            // ensure online
            ChatStore.customerOnline(user.getUsername());
            var msgs = ChatStore.pollForCustomer(user.getUsername(), after);
            Map<String,Object> out = new HashMap<>();
            out.put("messages", msgs);
            out.put("activeCustomers", ChatStore.getActiveCustomers());
            resp.setContentType("application/json");
            try (PrintWriter pw = resp.getWriter()) { pw.write(gson.toJson(out)); }
        } else if (user.isSeller() || user.isAdmin()) {
            // sellers poll active customers list optionally specifying customer
            String customer = req.getParameter("customer");
            if (customer != null && !customer.isBlank()) {
                var msgs = ChatStore.pollForCustomer(customer.trim(), after);
                Map<String,Object> out = new HashMap<>();
                out.put("messages", msgs);
                out.put("activeCustomers", ChatStore.getActiveCustomers());
                resp.setContentType("application/json");
                try (PrintWriter pw = resp.getWriter()) { pw.write(gson.toJson(out)); }
            } else {
                Map<String,Object> out = new HashMap<>();
                out.put("messages", new Object[0]);
                out.put("activeCustomers", ChatStore.getActiveCustomers());
                resp.setContentType("application/json");
                try (PrintWriter pw = resp.getWriter()) { pw.write(gson.toJson(out)); }
            }
        } else {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }
}

