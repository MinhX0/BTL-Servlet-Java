package com.example.btl.dao;

import com.example.btl.model.Role;
import com.example.btl.model.User;
import com.example.btl.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.hibernate.HibernateException;
import java.util.List;

public class UserDAO {

    /**
     * Authenticate user by username (or email) and password
     * Compares plain password against hashed password in database
     */
    public User authenticateUser(String username, String password) {
        String hql = "FROM User WHERE (username = :identifier OR email = :identifier) AND (active IS NULL OR active = true)";

        try (Session session = HibernateUtil.getSession()) {
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("identifier", username);

            User user = query.uniqueResult();

            // Verify password if user exists
            if (user != null && com.example.btl.util.PasswordUtil.verifyPassword(password, user.getPassword())) {
                return user;
            }
        } catch (HibernateException e) {
            System.out.println("Error during authentication: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Register a new user
     */
    public boolean registerUser(User user) {
        Session session = null;
        Transaction transaction = null;
        try {
            // Hash password before saving
            String hashedPassword = com.example.btl.util.PasswordUtil.hashPassword(user.getPassword());
            user.setPassword(hashedPassword);
            if (user.getActive() == null) user.setActive(Boolean.TRUE);

            session = HibernateUtil.getSession();
            transaction = session.beginTransaction();
            session.persist(user);
            transaction.commit();
            return true;
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            System.out.println("Error during registration: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return false;
    }

    /**
     * Check if username already exists
     */
    public boolean usernameExists(String username) {
        Session session = null;
        try {
            session = HibernateUtil.getSession();
            String hql = "SELECT COUNT(*) FROM User WHERE username = :username";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("username", username);

            Long count = query.uniqueResult();
            return count != null && count > 0;
        } catch (HibernateException e) {
            System.out.println("Error checking username: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return false;
    }

    /**
     * Check if email already exists
     */
    public boolean emailExists(String email) {
        Session session = null;
        try {
            session = HibernateUtil.getSession();
            String hql = "SELECT COUNT(*) FROM User WHERE email = :email";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("email", email);

            Long count = query.uniqueResult();
            return count != null && count > 0;
        } catch (HibernateException e) {
            System.out.println("Error checking email: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return false;
    }

    /**
     * Get user by email
     */
    public User getUserByEmail(String email) {
        try (Session session = HibernateUtil.getSession()) {
            Query<User> q = session.createQuery("FROM User WHERE email = :email", User.class);
            q.setParameter("email", email);
            return q.uniqueResult();
        } catch (HibernateException e) {
            System.out.println("Error fetching user by email: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get user by ID
     */
    public User getUserById(int userId) {
        Session session = null;
        try {
            session = HibernateUtil.getSession();
            return session.get(User.class, userId);
        } catch (HibernateException e) {
            System.out.println("Error fetching user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return null;
    }

    /**
     * Get all users (optionally filtered by role/active)
     */
    public List<User> getAllUsers() {
        try (Session session = HibernateUtil.getSession()) {
            return session.createQuery("FROM User ORDER BY id DESC", User.class).getResultList();
        } catch (HibernateException e) {
            System.out.println("Error fetching users: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    public List<User> search(Role role, Boolean active) {
        StringBuilder hql = new StringBuilder("FROM User WHERE 1=1");
        if (role != null) hql.append(" AND role = :role");
        if (active != null) hql.append(" AND (active = :active OR (active IS NULL AND :active = true))");
        hql.append(" ORDER BY id DESC");
        try (Session session = HibernateUtil.getSession()) {
            Query<User> q = session.createQuery(hql.toString(), User.class);
            if (role != null) q.setParameter("role", role);
            if (active != null) q.setParameter("active", active);
            return q.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error searching users: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Update user
     */
    public boolean updateUser(User user) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSession();
            transaction = session.beginTransaction();
            session.merge(user);
            transaction.commit();
            return true;
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            System.out.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return false;
    }

    /**
     * Soft deactivate/activate user
     */
    public boolean setActive(int userId, boolean active) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSession()) {
            tx = session.beginTransaction();
            User u = session.get(User.class, userId);
            if (u != null) {
                u.setActive(active);
                session.merge(u);
                tx.commit();
                return true;
            }
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("Error toggling user active: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete user by ID
     */
    public boolean deleteUser(int userId) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSession();
            transaction = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null) {
                session.remove(user);
                transaction.commit();
                return true;
            }
        } catch (HibernateException e) {
            if (transaction != null) {
                transaction.rollback();
            }
            System.out.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return false;
    }

    /**
     * Count all users
     */
    public long countAll() {
        try (Session session = HibernateUtil.getSession()) {
            Query<Long> q = session.createQuery("SELECT COUNT(u.id) FROM User u", Long.class);
            Long r = q.uniqueResult();
            return r != null ? r : 0L;
        } catch (HibernateException e) {
            System.out.println("Error counting users: " + e.getMessage());
            e.printStackTrace();
            return 0L;
        }
    }

    /**
     * Count users by role
     */
    public long countByRole(Role role) {
        if (role == null) return 0L;
        try (Session session = HibernateUtil.getSession()) {
            Query<Long> q = session.createQuery("SELECT COUNT(u.id) FROM User u WHERE u.role = :role", Long.class);
            q.setParameter("role", role);
            Long r = q.uniqueResult();
            return r != null ? r : 0L;
        } catch (HibernateException e) {
            System.out.println("Error counting users by role: " + e.getMessage());
            e.printStackTrace();
            return 0L;
        }
    }

    /**
     * Find user by username or email without filtering by active flag.
     */
    public User findByUsernameOrEmail(String identifier) {
        try (Session session = HibernateUtil.getSession()) {
            Query<User> q = session.createQuery("FROM User WHERE username = :id OR email = :id", User.class);
            q.setParameter("id", identifier);
            return q.uniqueResult();
        } catch (HibernateException e) {
            System.out.println("Error fetching user by identifier: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
