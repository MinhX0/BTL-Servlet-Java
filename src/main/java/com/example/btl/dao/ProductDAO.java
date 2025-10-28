package com.example.btl.dao;

import com.example.btl.model.Category;
import com.example.btl.model.Product;
import com.example.btl.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class ProductDAO {

    public Product getById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            return session.get(Product.class, id);
        } catch (HibernateException e) {
            System.out.println("Error fetching product by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<Product> listAll() {
        try (Session session = HibernateUtil.getSession()) {
            return session.createQuery("FROM Product ORDER BY dateAdded DESC", Product.class).getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing products: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public List<Product> listByCategory(int categoryId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Product> q = session.createQuery("FROM Product WHERE category.id = :cid ORDER BY dateAdded DESC", Product.class);
            q.setParameter("cid", categoryId);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing products by category: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean create(Product product) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.persist(product);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Product product) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.merge(product);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            Product p = session.get(Product.class, id);
            if (p != null) {
                session.remove(p);
                tx.commit();
                return true;
            }
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}

