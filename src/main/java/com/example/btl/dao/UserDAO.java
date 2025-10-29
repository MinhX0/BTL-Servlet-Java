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
        String hql = "FROM User WHERE username = :identifier OR email = :identifier";

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
     * Get all users
     */
    public List<User> getAllUsers() {
        Session session = null;
        try {
            session = HibernateUtil.getSession();
            String hql = "FROM User";
            Query<User> query = session.createQuery(hql, User.class);
            return query.getResultList();
        } catch (HibernateException e) {
            System.out.println("Error fetching users: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return List.of();
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
}
