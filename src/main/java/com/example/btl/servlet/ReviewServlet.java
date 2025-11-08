package com.example.btl.servlet;

import com.example.btl.dao.ProductDAO;
import com.example.btl.dao.ReviewDAO;
import com.example.btl.model.Product;
import com.example.btl.model.User;
import com.example.btl.service.ReviewService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/reviews"})
public class ReviewServlet extends HttpServlet {
    private ProductDAO productDAO;
    private ReviewService reviewService;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        reviewService = new ReviewService(new ReviewDAO());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String pidStr = req.getParameter("productId");
        String ratingStr = req.getParameter("rating");
        String content = req.getParameter("content");
        int pid;
        try { pid = Integer.parseInt(pidStr); } catch (Exception e) { resp.sendRedirect(req.getContextPath() + "/products"); return; }
        Product p = productDAO.getById(pid);
        if (p == null) { resp.sendRedirect(req.getContextPath() + "/products"); return; }
        int rating = 5;
        try { rating = Integer.parseInt(ratingStr); } catch (Exception ignored) {}
        reviewService.submit(p, user, rating, content);
        resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + pid + "#reviews");
    }
}

