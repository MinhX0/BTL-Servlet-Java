package com.example.btl.web;

import com.example.btl.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Set;
import java.util.logging.Logger;

/**
 * Restrict SELLER role from accessing storefront pages.
 * Sellers may only access admin area, chat endpoints, auth pages, static assets, and websockets.
 */
@WebFilter(filterName = "SellerAccessFilter", urlPatterns = {"/*"})
public class SellerAccessFilter implements Filter {

    private static final Logger LOG = Logger.getLogger(SellerAccessFilter.class.getName());

    private static final Set<String> ALLOW_PREFIX = Set.of(
            "/admin",        // admin area
            "/assets",       // static assets
            "/chat",         // chat endpoints (poll/send)
            "/ws",           // websocket endpoints
            "/login",        // auth
            "/register",     // allow register page just in case
            "/verify-otp",   // otp verification
            "/logout",       // logout
            "/product-image" // image servlet
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (request instanceof HttpServletRequest req && response instanceof HttpServletResponse resp) {
            HttpSession session = req.getSession(false);
            User user = session != null ? (User) session.getAttribute("user") : null;
            if (user != null && user.isSeller() && !user.isAdmin()) {
                String ctx = req.getContextPath();
                String uri = req.getRequestURI(); // includes context path
                String path = uri.substring(ctx.length()); // path relative to context root
                boolean allowed = ALLOW_PREFIX.stream().anyMatch(path::startsWith);
                if (!allowed) {
                    LOG.fine(() -> "[SellerAccessFilter] Block SELLER path=" + path + ", redirect -> " + ctx + "/admin");
                    resp.sendRedirect(ctx + "/admin");
                    return;
                } else {
                    LOG.fine(() -> "[SellerAccessFilter] Allow SELLER path=" + path);
                }
            }
        }
        chain.doFilter(request, response);
    }
}
