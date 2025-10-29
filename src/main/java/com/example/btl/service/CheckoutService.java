package com.example.btl.service;

import com.example.btl.model.*;
import com.example.btl.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class CheckoutService {

    public Order placeOrder(int userId, List<CartItem> items) {
        if (items == null || items.isEmpty()) return null;
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();

            // Compute total
            BigDecimal total = BigDecimal.ZERO;
            for (CartItem ci : items) {
                BigDecimal price = ci.getVariant().getFinalVariantPrice();
                BigDecimal line = price.multiply(BigDecimal.valueOf(ci.getQuantity()));
                total = total.add(line);
            }

            // Create order
            Order order = new Order();
            User userRef = session.get(User.class, userId);
            order.setUser(userRef);
            order.setOrderDate(LocalDateTime.now());
            order.setTotalAmount(total);
            order.setStatus(OrderStatus.Pending);
            session.persist(order);

            // Create order items
            for (CartItem ci : items) {
                OrderItem oi = new OrderItem();
                oi.setOrder(order);
                // Reattach/load variant in this session
                ProductVariant variant = session.get(ProductVariant.class, ci.getVariant().getId());
                oi.setVariant(variant);
                oi.setQuantity(ci.getQuantity());
                oi.setPriceAtPurchase(variant.getFinalVariantPrice());
                session.persist(oi);
            }

            // Clear cart for user
            session.createMutationQuery("DELETE FROM CartItem WHERE user.id = :uid")
                    .setParameter("uid", userId)
                    .executeUpdate();

            tx.commit();
            return order;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return null;
        }
    }
}

