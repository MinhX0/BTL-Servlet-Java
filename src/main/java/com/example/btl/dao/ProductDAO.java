package com.example.btl.dao;

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

    // New: find by name (case-insensitive, partial match)
    public List<Product> findByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return List.of();
        }
        String pattern = "%" + name.trim().toLowerCase() + "%";
        try (Session session = HibernateUtil.getSession()) {
            Query<Product> q = session.createQuery(
                    "FROM Product WHERE lower(name) LIKE :pattern ORDER BY dateAdded DESC",
                    Product.class
            );
            q.setParameter("pattern", pattern);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error finding products by name: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    // Flexible search: combine filters (category and/or name)
    public List<Product> search(Integer categoryId, String name) {
        StringBuilder hql = new StringBuilder("FROM Product WHERE 1=1");
        boolean hasName = name != null && !name.trim().isEmpty();
        if (categoryId != null) {
            hql.append(" AND category.id = :cid");
        }
        if (hasName) {
            hql.append(" AND lower(name) LIKE :pattern");
        }
        hql.append(" ORDER BY dateAdded DESC");

        try (Session session = HibernateUtil.getSession()) {
            Query<Product> q = session.createQuery(hql.toString(), Product.class);
            if (categoryId != null) {
                q.setParameter("cid", categoryId);
            }
            if (hasName) {
                q.setParameter("pattern", "%" + name.trim().toLowerCase() + "%");
            }
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    // Count total products matching filters
    public long searchCount(Integer categoryId, String name) {
        StringBuilder hql = new StringBuilder("SELECT COUNT(p.id) FROM Product p WHERE 1=1");
        boolean hasName = name != null && !name.trim().isEmpty();
        if (categoryId != null) {
            hql.append(" AND p.category.id = :cid");
        }
        if (hasName) {
            hql.append(" AND lower(p.name) LIKE :pattern");
        }
        try (Session session = HibernateUtil.getSession()) {
            Query<Long> q = session.createQuery(hql.toString(), Long.class);
            if (categoryId != null) q.setParameter("cid", categoryId);
            if (hasName) q.setParameter("pattern", "%" + name.trim().toLowerCase() + "%");
            Long result = q.uniqueResult();
            return result != null ? result : 0L;
        } catch (HibernateException e) {
            System.out.println("Error counting products: " + e.getMessage());
            e.printStackTrace();
            return 0L;
        }
    }

    // Paged search with combined filters (legacy signature keeps default ordering)
    public List<Product> searchPaged(Integer categoryId, String name, int offset, int limit) {
        // Delegate to new method with default sort
        return searchPaged(categoryId, name, offset, limit, null);
    }

    // New: Paged search with sorting support (price/date asc/desc)
    public List<Product> searchPaged(Integer categoryId, String name, int offset, int limit, String sort) {
        StringBuilder hql = new StringBuilder("FROM Product p WHERE 1=1");
        boolean hasName = name != null && !name.trim().isEmpty();
        if (categoryId != null) {
            hql.append(" AND p.category.id = :cid");
        }
        if (hasName) {
            hql.append(" AND lower(p.name) LIKE :pattern");
        }
        String orderBy;
        String s = sort == null ? "" : sort.trim().toLowerCase();
        switch (s) {
            case "price_asc":
                orderBy = "p.basePrice ASC";
                break;
            case "price_desc":
                orderBy = "p.basePrice DESC";
                break;
            case "date_asc":
                orderBy = "p.dateAdded ASC";
                break;
            default:
                orderBy = "p.dateAdded DESC"; // default newest first
        }
        hql.append(" ORDER BY ").append(orderBy);
        try (Session session = HibernateUtil.getSession()) {
            Query<Product> q = session.createQuery(hql.toString(), Product.class);
            if (categoryId != null) q.setParameter("cid", categoryId);
            if (hasName) q.setParameter("pattern", "%" + name.trim().toLowerCase() + "%");
            q.setFirstResult(Math.max(0, offset));
            q.setMaxResults(Math.max(1, limit));
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error fetching paged products: " + e.getMessage());
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
