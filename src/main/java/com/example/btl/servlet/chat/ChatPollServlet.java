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
import java.util.logging.Logger;

@WebServlet(name = "ChatPollServlet", urlPatterns = {"/chat/poll"})
public class ChatPollServlet extends HttpServlet {
    private static final Gson gson = new Gson();
    private static final Logger LOG = Logger.getLogger(ChatPollServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");

        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            LOG.fine(() -> "[ChatPoll] 401 no session user");
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

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
            String log = "[ChatPoll] customer=" + user.getUsername() + ", after=" + after + ", msgs=" + msgs.size();
            LOG.fine(log);
        } else if (user.isSeller() || user.isAdmin()) {
            // sellers poll active customers list optionally specifying customer
            String customer = req.getParameter("customer");
            if (customer != null && !customer.isBlank()) {
                customer = customer.trim();
                var msgs = ChatStore.pollForCustomer(customer, after);
                Map<String,Object> out = new HashMap<>();
                out.put("messages", msgs);
                out.put("activeCustomers", ChatStore.getActiveCustomers());
                resp.setContentType("application/json");
                try (PrintWriter pw = resp.getWriter()) { pw.write(gson.toJson(out)); }
                String log = "[ChatPoll] seller=" + user.getUsername() + ", customer=" + customer + ", after=" + after + ", msgs=" + msgs.size();
                LOG.fine(log);
            } else {
                Map<String,Object> out = new HashMap<>();
                out.put("messages", new Object[0]);
                out.put("activeCustomers", ChatStore.getActiveCustomers());
                resp.setContentType("application/json");
                try (PrintWriter pw = resp.getWriter()) { pw.write(gson.toJson(out)); }
                String log = "[ChatPoll] seller=" + user.getUsername() + ", list only, after=" + after;
                LOG.fine(log);
            }
        } else {
            LOG.fine(() -> "[ChatPoll] 403 role not allowed user=" + user.getUsername());
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }
}
