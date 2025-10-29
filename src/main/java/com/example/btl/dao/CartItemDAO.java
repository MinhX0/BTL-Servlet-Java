package com.example.btl.dao;

import com.example.btl.model.CartItem;
import com.example.btl.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class CartItemDAO {

    public CartItem getById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            return session.get(CartItem.class, id);
        } catch (HibernateException e) {
            System.out.println("Error fetching cart item by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<CartItem> listByUser(int userId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<CartItem> q = session.createQuery("FROM CartItem WHERE user.id = :uid ORDER BY dateAdded DESC", CartItem.class);
            q.setParameter("uid", userId);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing cart items by user: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    // New: fetch join variant and product for rendering
    public List<CartItem> listByUserDetailed(int userId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<CartItem> q = session.createQuery(
                    "select ci from CartItem ci " +
                    "join fetch ci.variant v " +
                    "join fetch v.product p " +
                    "where ci.user.id = :uid order by ci.dateAdded desc",
                    CartItem.class
            );
            q.setParameter("uid", userId);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing detailed cart items: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public CartItem findByUserAndVariant(int userId, int variantId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<CartItem> q = session.createQuery("FROM CartItem WHERE user.id = :uid AND variant.id = :vid", CartItem.class);
            q.setParameter("uid", userId);
            q.setParameter("vid", variantId);
            return q.uniqueResult();
        } catch (HibernateException e) {
            System.out.println("Error finding cart item by user and variant: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public boolean create(CartItem item) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.persist(item);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error creating cart item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(CartItem item) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.merge(item);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error updating cart item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            CartItem c = session.get(CartItem.class, id);
            if (c != null) {
                session.remove(c);
                tx.commit();
                return true;
            }
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error deleting cart item: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteByUser(int userId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            Query<?> q = session.createQuery("DELETE FROM CartItem WHERE user.id = :uid");
            q.setParameter("uid", userId);
            int rows = q.executeUpdate();
            tx.commit();
            return rows > 0;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error deleting cart items for user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
