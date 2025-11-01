package com.example.btl.web;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Use startup time as a simple cache-busting version for static assets
        sce.getServletContext().setAttribute("assetVersion", String.valueOf(System.currentTimeMillis()));
    }
}

