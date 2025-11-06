package com.example.btl.dao;

import com.example.btl.model.Order;
import com.example.btl.model.OrderStatus;
import com.example.btl.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;

public class OrderDAO {

    public Order getById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Order> q = session.createQuery(
                    "SELECT o FROM Order o JOIN FETCH o.user WHERE o.id = :id",
                    Order.class
            );
            q.setParameter("id", id);
            Order o = q.uniqueResult();
            if (o == null) {
                o = session.get(Order.class, id);
            }
            return o;
        } catch (HibernateException e) {
            System.out.println("Error fetching order by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<Order> listAll() {
        try (Session session = HibernateUtil.getSession()) {
            return session.createQuery("SELECT o FROM Order o JOIN FETCH o.user ORDER BY o.orderDate DESC", Order.class)
                    .getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing all orders: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public List<Order> listByUser(int userId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Order> q = session.createQuery("FROM Order WHERE user.id = :uid ORDER BY orderDate DESC", Order.class);
            q.setParameter("uid", userId);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing orders by user: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean create(Order order) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            if (order.getOrderDate() == null) {
                order.setOrderDate(LocalDateTime.now());
            }
            tx = session.beginTransaction();
            session.persist(order);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error creating order: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int orderId, OrderStatus status) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            Order o = session.get(Order.class, orderId);
            if (o != null) {
                o.setStatus(status);
                session.merge(o);
                tx.commit();
                return true;
            }
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error updating order status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public long countAll() {
        try (Session session = HibernateUtil.getSession()) {
            Query<Long> q = session.createQuery("SELECT COUNT(o.id) FROM Order o", Long.class);
            Long r = q.uniqueResult();
            return r != null ? r : 0L;
        } catch (HibernateException e) {
            System.out.println("Error counting orders: " + e.getMessage());
            e.printStackTrace();
            return 0L;
        }
    }

    /**
     * Sum revenue for orders that are considered completed (Delivered/Processing/Shipped)
     */
    public BigDecimal sumRevenue() {
        try (Session session = HibernateUtil.getSession()) {
            Query<BigDecimal> q = session.createQuery(
                "SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.status IN (:st1, :st2, :st3)",
                BigDecimal.class
            );
            q.setParameter("st1", OrderStatus.Delivered);
            q.setParameter("st2", OrderStatus.Shipped);
            q.setParameter("st3", OrderStatus.Processing);
            BigDecimal r = q.uniqueResult();
            return r != null ? r : BigDecimal.ZERO;
        } catch (HibernateException e) {
            System.out.println("Error summing revenue: " + e.getMessage());
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
    }

    /** Reporting: monthly revenue (BigDecimal) for a given year (1..12). */
    public List<Object[]> monthlyRevenue(int year) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Object[]> q = session.createQuery(
                "SELECT MONTH(o.orderDate), COALESCE(SUM(o.totalAmount), 0) " +
                "FROM Order o " +
                "WHERE YEAR(o.orderDate) = :y AND o.status IN (:s1, :s2, :s3) " +
                "GROUP BY MONTH(o.orderDate) ORDER BY MONTH(o.orderDate)",
                Object[].class
            );
            q.setParameter("y", year);
            q.setParameter("s1", OrderStatus.Delivered);
            q.setParameter("s2", OrderStatus.Shipped);
            q.setParameter("s3", OrderStatus.Processing);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error fetching monthly revenue: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    /** Reporting: monthly order count for a given year (1..12). */
    public List<Object[]> monthlyOrderCount(int year) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Object[]> q = session.createQuery(
                "SELECT MONTH(o.orderDate), COUNT(o.id) " +
                "FROM Order o " +
                "WHERE YEAR(o.orderDate) = :y AND o.status NOT IN (:c1, :c2) " +
                "GROUP BY MONTH(o.orderDate) ORDER BY MONTH(o.orderDate)",
                Object[].class
            );
            q.setParameter("y", year);
            q.setParameter("c1", OrderStatus.Cancelled);
            q.setParameter("c2", OrderStatus.Refunded);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error fetching monthly order count: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Reporting: top N products by revenue within a year.
     * Returns Object[] of {Integer productId, String name, BigDecimal revenue, Long qty}
     */
    public List<Object[]> topProductsByRevenue(int year, int limit) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Object[]> q = session.createQuery(
                "SELECT p.id, p.name, COALESCE(SUM(oi.priceAtPurchase * oi.quantity), 0), COALESCE(SUM(oi.quantity), 0) " +
                "FROM OrderItem oi JOIN oi.order o JOIN oi.product p " +
                "WHERE YEAR(o.orderDate) = :y AND o.status IN (:s1, :s2, :s3) " +
                "GROUP BY p.id, p.name " +
                "ORDER BY COALESCE(SUM(oi.priceAtPurchase * oi.quantity), 0) DESC",
                Object[].class
            );
            q.setParameter("y", year);
            q.setParameter("s1", OrderStatus.Delivered);
            q.setParameter("s2", OrderStatus.Shipped);
            q.setParameter("s3", OrderStatus.Processing);
            q.setMaxResults(Math.max(1, limit));
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error fetching top products by revenue: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }
}
