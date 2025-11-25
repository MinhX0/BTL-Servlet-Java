package com.example.btl.util;

import com.example.btl.model.*;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

public class HibernateUtil {
    private static volatile SessionFactory sessionFactory;

    private static SessionFactory buildSessionFactory() {
        StandardServiceRegistry registry = null;
        try {
            StandardServiceRegistryBuilder builder = new StandardServiceRegistryBuilder()
                    .configure("hibernate.cfg.xml");

            // Optional: override JDBC settings via environment variables
            String dbUrl = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASSWORD");
            if (dbUrl != null && !dbUrl.isBlank()) builder.applySetting("hibernate.connection.url", dbUrl);
            if (dbUser != null && !dbUser.isBlank()) builder.applySetting("hibernate.connection.username", dbUser);
            if (dbPass != null) builder.applySetting("hibernate.connection.password", dbPass);

            registry = builder.build();

            MetadataSources sources = new MetadataSources(registry)
                    // Explicitly register annotated classes
                    .addAnnotatedClass(User.class)
                    .addAnnotatedClass(Category.class)
                    .addAnnotatedClass(Product.class)
                    .addAnnotatedClass(CartItem.class)
                    .addAnnotatedClass(Order.class)
                    .addAnnotatedClass(OrderItem.class)
                    .addAnnotatedClass(OtpToken.class)
                    .addAnnotatedClass(Review.class)
                    .addAnnotatedClass(Promotion.class);


            Metadata metadata = sources.buildMetadata();
            return metadata.getSessionFactoryBuilder().build();
        } catch (Throwable ex) {
            if (registry != null) {
                try { StandardServiceRegistryBuilder.destroy(registry); } catch (Exception ignore) {}
            }
            // Fail fast instead of leaving a null reference
            throw new ExceptionInInitializerError("SessionFactory creation failed: " + ex.getMessage());
        }
    }

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            synchronized (HibernateUtil.class) {
                if (sessionFactory == null) {
                    sessionFactory = buildSessionFactory();
                }
            }
        }
        return sessionFactory;
    }

    public static Session getSession() throws HibernateException {
        return getSessionFactory().openSession();
    }

    public static void shutdown() {
        SessionFactory sf = sessionFactory;
        if (sf != null) {
            sf.close();
            sessionFactory = null;
        }
    }
}
