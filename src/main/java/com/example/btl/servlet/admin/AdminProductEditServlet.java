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
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminProductEditServlet", urlPatterns = {"/admin/products/edit"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, fileSizeThreshold = 256 * 1024)
public class AdminProductEditServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private String imageBaseDir;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        ServletContext ctx = getServletContext();
        String cfg = ctx.getInitParameter("productImageBaseDir");
        if (cfg == null || cfg.isBlank()) {
            cfg = System.getProperty("user.home") + File.separator + "product-images";
        }
        imageBaseDir = cfg;
        File base = new File(imageBaseDir);
        if (!base.exists()) {
            boolean created = base.mkdirs();
            if (!created) {
                ctx.log("[AdminProductEditServlet] WARNING: Could not create image base dir: " + imageBaseDir);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { resp.sendRedirect(req.getContextPath() + "/index"); return; }
        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Product p = productDAO.getById(id);
            if (p == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            List<Category> categories = categoryDAO.listAll();
            req.setAttribute("product", p);
            req.setAttribute("categories", categories);
            try {
                req.getRequestDispatcher("/admin/product-edit-form.jsp").forward(req, resp);
            } catch (Exception e) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (NumberFormatException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { resp.sendRedirect(req.getContextPath() + "/index"); return; }

        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String manualUrl = req.getParameter("mainImageUrl");
        String basePriceStr = req.getParameter("basePrice");
        String salePriceStr = req.getParameter("salePrice");
        String categoryIdStr = req.getParameter("categoryId");
        Part imagePart = null;
        try { imagePart = req.getPart("mainImageFile"); } catch (ServletException ignored) {}

        try {
            int id = Integer.parseInt(idStr);
            Product p = productDAO.getById(id);
            if (p == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }

            p.setName(name);
            p.setDescription(description);
            p.setBasePrice(Long.parseLong(basePriceStr));
            Long salePrice = null;
            if (salePriceStr != null && !salePriceStr.isBlank()) {
                try { long sp = Long.parseLong(salePriceStr.trim()); if (sp > 0) salePrice = sp; } catch (NumberFormatException ignored) {}
            }
            p.setSalePrice(salePrice);
            int categoryId = Integer.parseInt(categoryIdStr);
            Category c = categoryDAO.getById(categoryId);
            p.setCategory(c);
            // Image handling: optional new upload overwrites filename.
            if (imagePart != null && imagePart.getSize() > 0) {
                String submitted = imagePart.getSubmittedFileName();
                String ext = "";
                if (submitted != null && submitted.contains(".")) {
                    ext = submitted.substring(submitted.lastIndexOf('.')).toLowerCase();
                }
                if (!ext.matches("\\.(png|jpg|jpeg|gif|webp)")) ext = ".jpg";
                String newName = UUID.randomUUID() + ext;
                Path target = new File(imageBaseDir, newName).toPath();
                try { Files.copy(imagePart.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING); } catch (Exception ioex) {
                    getServletContext().log("[AdminProductEdit] Failed saving image: " + ioex.getMessage(), ioex);
                }
                p.setMainImageUrl(newName);
            } else if (manualUrl != null && !manualUrl.isBlank()) {
                p.setMainImageUrl(manualUrl.trim());
            }

            productDAO.update(p);
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } catch (Exception ex) {
            getServletContext().log("[AdminProductEdit] Error: " + ex.getMessage(), ex);
            resp.sendRedirect(req.getContextPath() + "/admin/products/edit?id=" + idStr + "&error=1");
        }
    }
}
