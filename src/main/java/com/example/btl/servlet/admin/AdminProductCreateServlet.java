package com.example.btl.servlet.admin;

import com.example.btl.dao.CategoryDAO;
import com.example.btl.dao.ProductDAO;
import com.example.btl.model.Category;
import com.example.btl.model.Product;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProductCreateServlet", urlPatterns = {"/admin/products/new"})
public class AdminProductCreateServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
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

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String mainImageUrl = request.getParameter("mainImageUrl");
        String basePriceStr = request.getParameter("basePrice");
        String categoryIdStr = request.getParameter("categoryId");

        try {
            long basePrice = Long.parseLong(basePriceStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            Category category = categoryDAO.getById(categoryId);

            Product p = new Product();
            p.setName(name);
            p.setDescription(description);
            p.setMainImageUrl(mainImageUrl);
            p.setBasePrice(basePrice);
            p.setCategory(category);

            productDAO.create(p);
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/admin/products/new?error=1");
        }
    }
}
