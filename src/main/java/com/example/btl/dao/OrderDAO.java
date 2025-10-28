package com.example.btl.dao;

import com.example.btl.model.Order;
import com.example.btl.model.OrderStatus;
import com.example.btl.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

public class OrderDAO {

    public Order getById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            return session.get(Order.class, id);
        } catch (HibernateException e) {
            System.out.println("Error fetching order by id: " + e.getMessage());
            e.printStackTrace();
            return null;
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
}

