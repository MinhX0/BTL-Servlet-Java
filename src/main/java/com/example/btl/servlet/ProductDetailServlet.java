package com.example.btl.servlet;

import com.example.btl.dao.ProductDAO;
import com.example.btl.dao.ReviewDAO;
import com.example.btl.model.Product;
import com.example.btl.model.Review;
import com.example.btl.model.User;
import com.example.btl.service.ProductService;
import com.example.btl.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {
    private ProductService productService;
    private ReviewService reviewService;

    @Override
    public void init() {
        this.productService = new ProductService(new ProductDAO());
        this.reviewService = new ReviewService(new ReviewDAO());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("user") : null;
        if (currentUser != null && (currentUser.isAdmin() || currentUser.isSeller())) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }
        String idParam = req.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (Exception ex) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }
        Product product = productService.get(id);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }
        req.setAttribute("product", product);
        // Simple related products: same category, exclude self, limit 8
        List<Product> related;
        try {
            related = productService.listByCategory(product.getCategory().getId());
        } catch (Exception e) {
            related = Collections.emptyList();
        }
        related.removeIf(p -> p.getId() == product.getId());
        if (related.size() > 8) {
            related = related.subList(0, 8);
        }
        req.setAttribute("relatedProducts", related);
        // Reviews data
        try {
            List<Review> reviews = reviewService.listRecent(product, 50);
            req.setAttribute("reviews", reviews);
            double avg = reviewService.averageRating(product);
            req.setAttribute("avgRating", avg);
            req.setAttribute("reviewCount", reviewService.totalReviews(product));
            // Rounded (nearest) for simpler star fill decisions if needed
            req.setAttribute("avgRatingRounded", Math.round(avg));
            // Detect current user's review
            HttpSession httpSession = req.getSession(false);
            User current = httpSession != null ? (User) httpSession.getAttribute("user") : null;
            Integer userReviewRating = null;
            if (current != null) {
                for (Review r : reviews) {
                    if (r.getUser().getId() == current.getId()) {
                        userReviewRating = r.getRating();
                        break;
                    }
                }
            }
            req.setAttribute("userReviewRating", userReviewRating);
        } catch (Exception ignored) {
            req.setAttribute("reviews", java.util.Collections.emptyList());
            req.setAttribute("avgRating", 0.0);
            req.setAttribute("avgRatingRounded", 0);
            req.setAttribute("reviewCount", 0L);
            req.setAttribute("userReviewRating", null);
        }
        // For JSP date format placeholder
        req.setAttribute("nowDate", new Date());
        try {
            req.getRequestDispatcher("/product-detail.jsp").forward(req, resp);
        } catch (ServletException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
