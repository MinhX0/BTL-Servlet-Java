package com.example.btl.dao;

import com.example.btl.model.OtpToken;
import com.example.btl.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime;

public class OtpTokenDAO {

    public OtpToken create(OtpToken token) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSession()) {
            tx = s.beginTransaction();
            s.persist(token);
            tx.commit();
            return token;
        } catch (Exception e) {
            if (tx != null) try { tx.rollback(); } catch (Exception ignored) {}
            return null;
        }
    }

    public OtpToken findActiveByUserAndPurpose(int userId, String purpose) {
        try (Session s = HibernateUtil.getSession()) {
            Query<OtpToken> q = s.createQuery(
                    "FROM OtpToken WHERE user.id = :uid AND purpose = :p AND consumedAt IS NULL AND expiresAt > :now ORDER BY id DESC",
                    OtpToken.class
            );
            q.setParameter("uid", userId);
            q.setParameter("p", purpose);
            q.setParameter("now", LocalDateTime.now());
            q.setMaxResults(1);
            return q.uniqueResult();
        }
    }

    public OtpToken findByUserCodePurpose(int userId, String code, String purpose) {
        try (Session s = HibernateUtil.getSession()) {
            Query<OtpToken> q = s.createQuery(
                    "FROM OtpToken WHERE user.id = :uid AND code = :c AND purpose = :p ORDER BY id DESC",
                    OtpToken.class
            );
            q.setParameter("uid", userId);
            q.setParameter("c", code);
            q.setParameter("p", purpose);
            q.setMaxResults(1);
            return q.uniqueResult();
        }
    }

    public boolean consume(OtpToken token) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSession()) {
            tx = s.beginTransaction();
            token.setConsumedAt(LocalDateTime.now());
            s.merge(token);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) try { tx.rollback(); } catch (Exception ignored) {}
            return false;
        }
    }

    public boolean deleteByUserPurpose(int userId, String purpose) {
        Transaction tx = null;
        try (Session s = HibernateUtil.getSession()) {
            tx = s.beginTransaction();
            int rows = s.createMutationQuery("DELETE FROM OtpToken WHERE user.id = :uid AND purpose = :p")
                    .setParameter("uid", userId)
                    .setParameter("p", purpose)
                    .executeUpdate();
            tx.commit();
            return rows > 0;
        } catch (Exception e) {
            if (tx != null) try { tx.rollback(); } catch (Exception ignored) {}
            return false;
        }
    }
}

