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
            // Eagerly fetch category to avoid LazyInitializationException in JSP
            Query<Product> q = session.createQuery(
                    "SELECT p FROM Product p JOIN FETCH p.category WHERE p.id = :id",
                    Product.class
            );
            q.setParameter("id", id);
            Product p = q.uniqueResult();
            if (p == null) {
                // Fallback just in case (should rarely happen)
                p = session.get(Product.class, id);
            }
            return p;
        } catch (HibernateException e) {
            System.out.println("Error fetching product by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public List<Product> listAll() {
        try (Session session = HibernateUtil.getSession()) {
            // Join fetch category so JSP can access p.category.name without an open session
            return session.createQuery(
                    "SELECT p FROM Product p LEFT JOIN FETCH p.category ORDER BY p.dateAdded DESC, p.id DESC",
                    Product.class
            ).getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing products: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public List<Product> listByCategory(int categoryId) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Product> q = session.createQuery(
                    "SELECT p FROM Product p JOIN FETCH p.category WHERE p.category.id = :cid ORDER BY p.dateAdded DESC, p.id DESC",
                    Product.class
            );
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
                    "SELECT p FROM Product p LEFT JOIN FETCH p.category WHERE lower(p.name) LIKE :pattern ORDER BY p.dateAdded DESC, p.id DESC",
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
        StringBuilder hql = new StringBuilder("SELECT p FROM Product p LEFT JOIN FETCH p.category WHERE 1=1");
        boolean hasName = name != null && !name.trim().isEmpty();
        if (categoryId != null) {
            hql.append(" AND p.category.id = :cid");
        }
        if (hasName) {
            hql.append(" AND lower(p.name) LIKE :pattern");
        }
        hql.append(" ORDER BY p.dateAdded DESC, p.id DESC");

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
        StringBuilder hql = new StringBuilder("SELECT p FROM Product p LEFT JOIN FETCH p.category WHERE 1=1");
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
                orderBy = "COALESCE(p.salePrice, p.basePrice) ASC";
                break;
            case "price_desc":
                orderBy = "COALESCE(p.salePrice, p.basePrice) DESC";
                break;
            case "date_asc":
                orderBy = "p.dateAdded ASC";
                break;
            default:
                orderBy = "p.dateAdded DESC"; // default newest first
        }
        hql.append(" ORDER BY ").append(orderBy).append(", p.id DESC");
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

    public List<Product> listOnSale(int limit) {
        try (Session session = HibernateUtil.getSession()) {
            String hql = "SELECT p FROM Product p LEFT JOIN FETCH p.category " +
                    "WHERE COALESCE(p.salePrice, 0) > 0 AND COALESCE(p.basePrice, 0) > COALESCE(p.salePrice, 0) " +
                    "ORDER BY (COALESCE(p.basePrice,0) - COALESCE(p.salePrice,0)) DESC, p.dateAdded DESC, p.id DESC";
            Query<Product> q = session.createQuery(hql, Product.class);
            q.setMaxResults(Math.max(1, limit));
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing on-sale products: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public List<Product> listNewest(int limit) {
        try (Session session = HibernateUtil.getSession()) {
            Query<Product> q = session.createQuery(
                    "SELECT p FROM Product p LEFT JOIN FETCH p.category ORDER BY p.dateAdded DESC, p.id DESC",
                    Product.class
            );
            q.setMaxResults(Math.max(1, limit));
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error listing newest products: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }
}
