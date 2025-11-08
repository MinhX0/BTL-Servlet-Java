package com.example.btl.dao;

import com.example.btl.model.Review;
import com.example.btl.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class ReviewDAO {
    public List<Review> listForProduct(int productId, int limit) {
        try (Session s = HibernateUtil.getSession()) {
            Query<Review> q = s.createQuery(
                    "SELECT r FROM Review r JOIN FETCH r.user u WHERE r.product.id = :pid ORDER BY r.createdAt DESC",
                    Review.class);
            q.setParameter("pid", productId);
            if (limit > 0) q.setMaxResults(limit);
            return q.getResultList();
        }
    }

    public double averageRating(int productId) {
        try (Session s = HibernateUtil.getSession()) {
            Query<Double> q = s.createQuery(
                    "SELECT AVG(r.rating) FROM Review r WHERE r.product.id = :pid",
                    Double.class);
            q.setParameter("pid", productId);
            Double v = q.uniqueResult();
            return v != null ? v : 0.0;
        }
    }

    public long countForProduct(int productId) {
        try (Session s = HibernateUtil.getSession()) {
            Query<Long> q = s.createQuery(
                    "SELECT COUNT(r.id) FROM Review r WHERE r.product.id = :pid",
                    Long.class);
            q.setParameter("pid", productId);
            Long v = q.uniqueResult();
            return v != null ? v : 0L;
        }
    }

    public void saveOrUpdate(Review r) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSession()) {
            tx = s.beginTransaction();
            s.merge(r);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    public Review findByUserAndProduct(int userId, int productId) {
        try (Session s = HibernateUtil.getSession()) {
            Query<Review> q = s.createQuery(
                    "FROM Review r WHERE r.user.id = :uid AND r.product.id = :pid",
                    Review.class);
            q.setParameter("uid", userId);
            q.setParameter("pid", productId);
            return q.uniqueResult();
        }
    }
}

