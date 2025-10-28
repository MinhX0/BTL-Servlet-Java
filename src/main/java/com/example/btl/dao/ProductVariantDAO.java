package com.example.btl.dao;

import com.example.btl.model.ProductVariant;
import com.example.btl.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class ProductVariantDAO {

    public ProductVariant getById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            return session.get(ProductVariant.class, id);
        } catch (HibernateException e) {
            System.out.println("Error fetching product variant by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public ProductVariant getBySku(String sku) {
        try (Session session = HibernateUtil.getSession()) {
            Query<ProductVariant> q = session.createQuery("FROM ProductVariant WHERE sku = :sku", ProductVariant.class);
            q.setParameter("sku", sku);
            return q.uniqueResult();
        } catch (HibernateException e) {
            System.out.println("Error fetching product variant by SKU: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<ProductVariant> listByProduct(int productId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<ProductVariant> q = session.createQuery("FROM ProductVariant WHERE product.id = :pid", ProductVariant.class);
            q.setParameter("pid", productId);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing variants by product: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean create(ProductVariant variant) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.persist(variant);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error creating product variant: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(ProductVariant variant) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.merge(variant);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error updating product variant: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            ProductVariant v = session.get(ProductVariant.class, id);
            if (v != null) {
                session.remove(v);
                tx.commit();
                return true;
            }
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error deleting product variant: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}

