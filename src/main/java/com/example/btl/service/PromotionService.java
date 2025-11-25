package com.example.btl.service;

import com.example.btl.model.Promotion;
import com.example.btl.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class PromotionService {

    /**
     * Get the best applicable promotion for the given order amount
     * Returns the promotion that gives the highest discount
     */
    public Promotion getBestApplicablePromotion(BigDecimal orderAmount) {
        try (Session session = HibernateUtil.getSession()) {
            LocalDateTime now = LocalDateTime.now();

            String hql = "FROM Promotion p WHERE p.isActive = true " +
                        "AND p.startDate <= :now AND p.endDate >= :now " +
                        "AND p.minOrderAmount <= :amount " +
                        "ORDER BY p.discountValue DESC";

            Query<Promotion> query = session.createQuery(hql, Promotion.class);
            query.setParameter("now", now);
            query.setParameter("amount", orderAmount);

            List<Promotion> promotions = query.list();

            if (promotions.isEmpty()) {
                return null;
            }

            // Find the promotion with the highest discount amount
            Promotion bestPromotion = null;
            BigDecimal maxDiscount = BigDecimal.ZERO;

            for (Promotion promo : promotions) {
                BigDecimal discount = promo.calculateDiscount(orderAmount);
                if (discount.compareTo(maxDiscount) > 0) {
                    maxDiscount = discount;
                    bestPromotion = promo;
                }
            }

            return bestPromotion;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get all active promotions currently running
     */
    public List<Promotion> getActivePromotions() {
        try (Session session = HibernateUtil.getSession()) {
            LocalDateTime now = LocalDateTime.now();

            String hql = "FROM Promotion p WHERE p.isActive = true " +
                        "AND p.startDate <= :now AND p.endDate >= :now " +
                        "ORDER BY p.startDate DESC";

            Query<Promotion> query = session.createQuery(hql, Promotion.class);
            query.setParameter("now", now);

            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Get all promotions (for admin management)
     */
    public List<Promotion> getAllPromotions() {
        try (Session session = HibernateUtil.getSession()) {
            String hql = "FROM Promotion p ORDER BY p.startDate DESC";
            Query<Promotion> query = session.createQuery(hql, Promotion.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Get promotion by ID
     */
    public Promotion getPromotionById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            return session.get(Promotion.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Create a new promotion
     */
    public boolean createPromotion(Promotion promotion) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.persist(promotion);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update an existing promotion
     */
    public boolean updatePromotion(Promotion promotion) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.merge(promotion);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a promotion (soft delete by setting isActive to false)
     */
    public boolean deletePromotion(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            Promotion promotion = session.get(Promotion.class, id);
            if (promotion != null) {
                promotion.setActive(false);
                session.merge(promotion);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Permanently delete a promotion
     */
    public boolean hardDeletePromotion(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            Promotion promotion = session.get(Promotion.class, id);
            if (promotion != null) {
                session.remove(promotion);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Calculate discount for a given order amount and promotion
     */
    public BigDecimal calculateDiscount(int promotionId, BigDecimal orderAmount) {
        Promotion promotion = getPromotionById(promotionId);
        if (promotion == null) {
            return BigDecimal.ZERO;
        }
        return promotion.calculateDiscount(orderAmount);
    }
}

