package com.example.btl.dao;

import com.example.btl.model.Category;
import com.example.btl.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class CategoryDAO {

    public Category getById(int id) {
        try (Session session = HibernateUtil.getSession()) {
            return session.get(Category.class, id);
        } catch (HibernateException e) {
            System.out.println("Error fetching category by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public Category getBySlug(String slug) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Category> q = session.createQuery("FROM Category WHERE slug = :slug", Category.class);
            q.setParameter("slug", slug);
            return q.uniqueResult();
        } catch (HibernateException e) {
            System.out.println("Error fetching category by slug: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<Category> listAll() {
        try (Session session = HibernateUtil.getSession()) {
            return session.createQuery("FROM Category ORDER BY name", Category.class).getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing categories: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public List<Category> listActive() {
        try (Session session = HibernateUtil.getSession()) {
            return session.createQuery("FROM Category WHERE active = true ORDER BY name", Category.class).getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing active categories: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public List<Category> listChildren(int parentId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Category> q = session.createQuery("FROM Category WHERE parent.id = :pid ORDER BY name", Category.class);
            q.setParameter("pid", parentId);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing child categories: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean create(Category category) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.persist(category);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error creating category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Category category) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            session.merge(category);
            tx.commit();
            return true;
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error updating category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            Category c = session.get(Category.class, id);
            if (c != null) {
                session.remove(c);
                tx.commit();
                return true;
            }
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error deleting category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}

