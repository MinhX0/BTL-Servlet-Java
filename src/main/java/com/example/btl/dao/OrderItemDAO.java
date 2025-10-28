package com.example.btl.dao;

import com.example.btl.model.OrderItem;
import com.example.btl.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class OrderItemDAO {

    public OrderItem getById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            return session.get(OrderItem.class, id);
        } catch (HibernateException e) {
            System.out.println("Error fetching order item by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<OrderItem> listByOrder(int orderId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<OrderItem> q = session.createQuery("FROM OrderItem WHERE order.id = :oid", OrderItem.class);
            q.setParameter("oid", orderId);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing order items by order: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean create(OrderItem item) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.persist(item);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error creating order item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

