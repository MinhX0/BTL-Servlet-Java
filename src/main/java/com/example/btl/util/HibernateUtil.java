package com.example.btl.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.Session;
import org.hibernate.HibernateException;
import com.example.btl.model.User;
import com.example.btl.model.Category;
import com.example.btl.model.Product;
import com.example.btl.model.ProductVariant;
import com.example.btl.model.CartItem;
import com.example.btl.model.Order;
import com.example.btl.model.OrderItem;

public class HibernateUtil {
    private static SessionFactory sessionFactory;

    static {
        try {
            // Create the SessionFactory from hibernate.cfg.xml
            sessionFactory = new Configuration()
                    .configure("hibernate.cfg.xml")
                    .addAnnotatedClass(User.class)
                    .addAnnotatedClass(Category.class)
                    .addAnnotatedClass(Product.class)
                    .addAnnotatedClass(ProductVariant.class)
                    .addAnnotatedClass(CartItem.class)
                    .addAnnotatedClass(Order.class)
                    .addAnnotatedClass(OrderItem.class)
                    .buildSessionFactory();
        } catch (HibernateException e) {
            System.err.println("SessionFactory creation failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static Session getSession() throws HibernateException {
        return sessionFactory.openSession();
    }

    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
