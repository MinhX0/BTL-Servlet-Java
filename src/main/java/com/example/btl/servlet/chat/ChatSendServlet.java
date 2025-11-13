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

@WebServlet(name = "ChatSendServlet", urlPatterns = {"/chat/send"})
public class ChatSendServlet extends HttpServlet {
    private static final Gson gson = new Gson();
    private static final Logger LOG = Logger.getLogger(ChatSendServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendError(HttpServletResponse.SC_UNAUTHORIZED); return; }

        String to = req.getParameter("to");
        String content = req.getParameter("content");
        if (content == null || content.isBlank()) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }

        boolean fromSeller = user.isSeller() || user.isAdmin();
        String target = fromSeller ? (to!=null?to.trim():null) : user.getUsername();
        if (target == null || target.isBlank()) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }

        ChatStore.Msg msg = new ChatStore.Msg(user.getUsername(), target, content, fromSeller);
        ChatStore.sendToCustomer(target, msg);

        Map<String,Object> out = new HashMap<>();
        out.put("status", "ok");
        out.put("ts", msg.ts);
        out.put("to", target);
        resp.setContentType("application/json");
        try (PrintWriter pw = resp.getWriter()) { pw.write(gson.toJson(out)); }
        LOG.fine(() -> "[ChatSend] from=" + user.getUsername() + ", to=" + target + ", len=" + content.length());
    }
}
