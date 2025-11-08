package com.example.btl.service;

import com.example.btl.dao.ReviewDAO;
import com.example.btl.model.Product;
import com.example.btl.model.Review;
import com.example.btl.model.User;

import java.util.List;

public class ReviewService {
    private final ReviewDAO reviewDAO;

    public ReviewService(ReviewDAO reviewDAO) {
        this.reviewDAO = reviewDAO;
    }

    public List<Review> listRecent(Product product, int limit) {
        return reviewDAO.listForProduct(product.getId(), limit);
    }

    public double averageRating(Product product) {
        return reviewDAO.averageRating(product.getId());
    }

    public long totalReviews(Product product) {
        return reviewDAO.countForProduct(product.getId());
    }

    public Review submit(Product product, User user, int rating, String content) {
        if (rating < 1) rating = 1; if (rating > 5) rating = 5;
        Review existing = reviewDAO.findByUserAndProduct(user.getId(), product.getId());
        if (existing == null) {
            existing = new Review();
            existing.setProduct(product);
            existing.setUser(user);
        }
        existing.setRating(rating);
        existing.setContent(content != null ? content.trim() : null);
        reviewDAO.saveOrUpdate(existing);
        return existing;
    }
}

