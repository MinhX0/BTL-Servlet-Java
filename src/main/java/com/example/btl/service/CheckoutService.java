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
        // Delegate to the overload without address
        return placeOrder(userId, items, null);
    }

    public Order placeOrder(int userId, List<CartItem> items, String address) {
        if (items == null || items.isEmpty()) return null;
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernateUtil.getSession();
            tx = session.beginTransaction();

            // Compute total
            BigDecimal total = BigDecimal.ZERO;
            for (CartItem ci : items) {
                // Use product's base price as price (since variants removed)
                BigDecimal price = ci.getProduct().getBasePrice();
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
            if (address != null && !address.isBlank()) {
                order.setAddress(address);
            }
            session.persist(order);

            // Create order items
            for (CartItem ci : items) {
                OrderItem oi = new OrderItem();
                oi.setOrder(order);
                // Reattach/load product in this session
                Product product = session.get(Product.class, ci.getProduct().getId());
                oi.setProduct(product);
                oi.setQuantity(ci.getQuantity());
                oi.setPriceAtPurchase(product.getBasePrice());
                session.persist(oi);
            }

            // Clear cart for user
            session.createMutationQuery("DELETE FROM CartItem WHERE user.id = :uid")
                    .setParameter("uid", userId)
                    .executeUpdate();

            tx.commit();
            return order;
        } catch (Exception e) {
            // Rollback only if tx is active and session is open
            try {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }
            } catch (Exception ignored) {
                // ignore rollback failures
            }
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}
