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

            // Validate stock before creating order
            for (CartItem ci : items) {
                Product p = session.get(Product.class, ci.getProduct().getId());
                if (p == null || !p.isActive() || p.getStock() < ci.getQuantity()) {
                    throw new IllegalStateException("Insufficient stock for product id=" + (p!=null?p.getId():-1));
                }
            }

            // Compute total in VND (long) using effective price per item
            long totalVnd = 0L;
            for (CartItem ci : items) {
                Product p = session.get(Product.class, ci.getProduct().getId());
                long unit = (p.getSalePrice() != null && p.getSalePrice() > 0) ? p.getSalePrice() : p.getBasePrice();
                totalVnd += unit * (long) ci.getQuantity();
            }

            // Create order
            Order order = new Order();
            User userRef = session.get(User.class, userId);
            order.setUser(userRef);
            order.setOrderDate(LocalDateTime.now());
            order.setTotalAmount(BigDecimal.valueOf(totalVnd));
            order.setStatus(OrderStatus.Pending);
            if (address != null && !address.isBlank()) {
                order.setAddress(address);
            }
            session.persist(order);

            // Create order items and deduct stock atomically
            for (CartItem ci : items) {
                Product product = session.get(Product.class, ci.getProduct().getId());
                // deduct stock
                int newStock = product.getStock() - ci.getQuantity();
                if (newStock < 0) {
                    throw new IllegalStateException("Stock underflow for product id=" + product.getId());
                }
                product.setStock(newStock);
                session.merge(product);

                OrderItem oi = new OrderItem();
                oi.setOrder(order);
                oi.setProduct(product);
                oi.setQuantity(ci.getQuantity());
                long unit = (product.getSalePrice() != null && product.getSalePrice() > 0) ? product.getSalePrice() : product.getBasePrice();
                oi.setPriceAtPurchase(BigDecimal.valueOf(unit));
                // copy size from cart to order item
                oi.setItemSize(ci.getItemSize());
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

    // NEW: version that accepts selected cart item IDs; only those items become order items.
    public Order placeOrderSelected(int userId, List<CartItem> selectedItems, String address, boolean removeSelectedOnly) {
        if (selectedItems == null || selectedItems.isEmpty()) return null;
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernateUtil.getSession();
            tx = session.beginTransaction();

            // Validate stock
            for (CartItem ci : selectedItems) {
                Product p = session.get(Product.class, ci.getProduct().getId());
                if (p == null || !p.isActive() || p.getStock() < ci.getQuantity()) {
                    throw new IllegalStateException("Insufficient stock for product id=" + (p != null ? p.getId() : -1));
                }
            }

            long totalVnd = 0L;
            for (CartItem ci : selectedItems) {
                Product p = session.get(Product.class, ci.getProduct().getId());
                long unit = (p.getSalePrice() != null && p.getSalePrice() > 0) ? p.getSalePrice() : p.getBasePrice();
                totalVnd += unit * (long) ci.getQuantity();
            }

            Order order = new Order();
            User userRef = session.get(User.class, userId);
            order.setUser(userRef);
            order.setOrderDate(LocalDateTime.now());
            order.setTotalAmount(BigDecimal.valueOf(totalVnd));
            order.setStatus(OrderStatus.Pending);
            if (address != null && !address.isBlank()) {
                order.setAddress(address);
            }
            session.persist(order);

            for (CartItem ci : selectedItems) {
                Product product = session.get(Product.class, ci.getProduct().getId());
                int newStock = product.getStock() - ci.getQuantity();
                if (newStock < 0) throw new IllegalStateException("Stock underflow for product id=" + product.getId());
                product.setStock(newStock);
                session.merge(product);

                OrderItem oi = new OrderItem();
                oi.setOrder(order);
                oi.setProduct(product);
                oi.setQuantity(ci.getQuantity());
                long unit = (product.getSalePrice() != null && product.getSalePrice() > 0) ? product.getSalePrice() : product.getBasePrice();
                oi.setPriceAtPurchase(BigDecimal.valueOf(unit));
                oi.setItemSize(ci.getItemSize());
                session.persist(oi);
            }

            // Remove only selected items if requested; else clear all
            if (removeSelectedOnly) {
                session.createMutationQuery("DELETE FROM CartItem WHERE id in (:ids)")
                        .setParameterList("ids", selectedItems.stream().map(CartItem::getId).toList())
                        .executeUpdate();
            } else {
                session.createMutationQuery("DELETE FROM CartItem WHERE user.id = :uid")
                        .setParameter("uid", userId)
                        .executeUpdate();
            }

            tx.commit();
            return order;
        } catch (Exception e) {
            try { if (tx != null && tx.isActive()) tx.rollback(); } catch (Exception ignored) {}
            return null;
        } finally {
            if (session != null && session.isOpen()) session.close();
        }
    }
}
