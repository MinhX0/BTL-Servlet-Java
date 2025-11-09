package com.example.btl.web;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.Instant;
import java.util.List;

@WebFilter(filterName = "CartBadgeFilter", urlPatterns = {"/*"})
public class CartBadgeFilter implements Filter {
    private CartItemDAO cartItemDAO;
    // Refresh cooldown in seconds to reduce DB load
    private static final long REFRESH_INTERVAL_SEC = 30;

    @Override
    public void init(FilterConfig filterConfig) {
        this.cartItemDAO = new CartItemDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (request instanceof HttpServletRequest req) {
            String uri = req.getRequestURI();
            // Skip badge load for admin area to avoid unnecessary queries on admin pages (like chat)
            if (!uri.startsWith(req.getContextPath() + "/admin")) {
                HttpSession session = req.getSession(false);
                Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
                if (userId != null) {
                    try {
                        Long lastFetch = (Long) session.getAttribute("cartCount:lastFetch");
                        Integer cached = (Integer) session.getAttribute("cartCount:value");
                        long now = Instant.now().getEpochSecond();
                        if (cached == null || lastFetch == null || (now - lastFetch) > REFRESH_INTERVAL_SEC) {
                            List<CartItem> items = cartItemDAO.listByUser(userId);
                            int count = 0;
                            for (CartItem ci : items) { count += ci.getQuantity(); }
                            session.setAttribute("cartCount:value", count);
                            session.setAttribute("cartCount:lastFetch", now);
                            request.setAttribute("cartCount", count);
                        } else {
                            request.setAttribute("cartCount", cached);
                        }
                    } catch (Exception ignored) {
                        // Fail silently; do not block request
                    }
                }
            }
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}
