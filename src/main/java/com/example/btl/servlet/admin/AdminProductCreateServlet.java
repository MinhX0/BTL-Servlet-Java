package com.example.btl.servlet.admin;

import com.example.btl.dao.CategoryDAO;
import com.example.btl.dao.ProductDAO;
import com.example.btl.model.Category;
import com.example.btl.model.Product;
import com.example.btl.model.User;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminProductCreateServlet", urlPatterns = {"/admin/products/new"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, fileSizeThreshold = 256 * 1024) // 5MB
public class AdminProductCreateServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private String imageBaseDir;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
        ServletContext ctx = getServletContext();
        String cfg = ctx.getInitParameter("productImageBaseDir");
        if (cfg == null || cfg.isBlank()) {
            cfg = System.getProperty("user.home") + File.separator + "product-images"; // fallback
        }
        imageBaseDir = cfg;
        File base = new File(imageBaseDir);
        if (!base.exists()) {
            boolean created = base.mkdirs();
            if (!created) {
                ctx.log("[AdminProductCreateServlet] WARNING: Could not create image base dir: " + imageBaseDir);
            }
        }
        ctx.log("[AdminProductCreateServlet] Using image base dir: " + imageBaseDir);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        List<Category> categories = categoryDAO.listAll();
        request.setAttribute("categories", categories);
        try {
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String manualUrl = request.getParameter("mainImageUrl");
        String basePriceStr = request.getParameter("basePrice");
        String salePriceStr = request.getParameter("salePrice");
        String categoryIdStr = request.getParameter("categoryId");

        Part imagePart = null;
        try { imagePart = request.getPart("mainImageFile"); } catch (ServletException ignored) {}

        try {
            long basePrice = Long.parseLong(basePriceStr);
            Long salePrice = null;
            if (salePriceStr != null && !salePriceStr.isBlank()) {
                try { long sp = Long.parseLong(salePriceStr.trim()); if (sp > 0) salePrice = sp; } catch (NumberFormatException ignored) {}
            }
            int categoryId = Integer.parseInt(categoryIdStr);
            Category category = categoryDAO.getById(categoryId);

            Product p = new Product();
            p.setName(name);
            p.setDescription(description);
            p.setBasePrice(basePrice);
            if (salePrice != null) p.setSalePrice(salePrice);
            p.setCategory(category);
            p.setDateAdded(LocalDateTime.now());

            // Decide image source: uploaded file first, otherwise manual URL.
            String storedFileName = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                String submitted = imagePart.getSubmittedFileName();
                String ext = "";
                if (submitted != null && submitted.contains(".")) {
                    ext = submitted.substring(submitted.lastIndexOf('.')).toLowerCase();
                }
                // basic whitelist
                if (!ext.matches("\\.(png|jpg|jpeg|gif|webp)")) {
                    ext = ".jpg"; // default
                }
                storedFileName = UUID.randomUUID() + ext;
                Path target = new File(imageBaseDir, storedFileName).toPath();
                try {
                    Files.copy(imagePart.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
                } catch (Exception ioex) {
                    getServletContext().log("[AdminProductCreate] Failed saving image: " + ioex.getMessage(), ioex);
                }
            }
            if (storedFileName != null) {
                p.setMainImageUrl(storedFileName); // only store filename; servlet prefixes base dir
            } else if (manualUrl != null && !manualUrl.isBlank()) {
                p.setMainImageUrl(manualUrl.trim());
            }

            productDAO.create(p);
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception ex) {
            getServletContext().log("[AdminProductCreate] Error: " + ex.getMessage(), ex);
            response.sendRedirect(request.getContextPath() + "/admin/products/new?error=1");
        }
    }
}
