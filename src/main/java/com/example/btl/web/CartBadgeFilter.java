package com.example.btl.web;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebFilter(filterName = "CartBadgeFilter", urlPatterns = {"/*"})
public class CartBadgeFilter implements Filter {
    private CartItemDAO cartItemDAO;

    @Override
    public void init(FilterConfig filterConfig) {
        this.cartItemDAO = new CartItemDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        try {
            if (request instanceof HttpServletRequest req) {
                HttpSession session = req.getSession(false);
                Integer userId = session != null ? (Integer) session.getAttribute("userId") : null;
                if (userId != null) {
                    List<CartItem> items = cartItemDAO.listByUser(userId);
                    int count = 0;
                    for (CartItem ci : items) {
                        count += ci.getQuantity();
                    }
                    request.setAttribute("cartCount", count);
                }
            }
        } catch (Exception ignored) {
            // fail silently; badge will default to 0
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}

