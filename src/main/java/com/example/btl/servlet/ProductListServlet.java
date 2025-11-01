package com.example.btl.servlet;

import com.example.btl.dao.ProductDAO;
import com.example.btl.dao.CategoryDAO;
import com.example.btl.model.Product;
import com.example.btl.model.Category;
import com.example.btl.model.User;
import com.example.btl.service.CategoryService;
import com.example.btl.service.ProductService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductListServlet", urlPatterns = {"/products"})
public class ProductListServlet extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;
    @Override
    public void init() {
        // In a larger app, use DI or a ContextListener to share services
        this.productService = new ProductService(new ProductDAO());
        this.categoryService = new CategoryService(new CategoryDAO());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user != null && user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }
        // Simple optional filtering & pagination params (no-op defaults)
        String categoryParam = request.getParameter("categoryId");
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        String keyWordParam = request.getParameter("keyword"); // also accept 'q' alias
        if (keyWordParam == null || keyWordParam.isBlank()) {
            keyWordParam = request.getParameter("q");
        }
        // Sorting param: price_asc | price_desc | date_asc | date_desc (default)
        String sortParam = request.getParameter("sort");

        int page = 1;
        int size = 20;
        try { if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) {}
        try { if (sizeParam != null) size = Math.max(1, Integer.parseInt(sizeParam)); } catch (NumberFormatException ignored) {}

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.isBlank()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException ignored) { }
        }

        // Load categories for sidebar
        List<Category> categories = categoryService.listActive();

        // Count total and fetch a page
        long total = productService.searchCount(categoryId, keyWordParam);
        int totalPages = (int) Math.max(1, Math.ceil(total / (double) size));
        int currentPage = Math.min(page, totalPages);
        int offset = (currentPage - 1) * size;
        List<Product> products = productService.searchPaged(categoryId, keyWordParam, offset, size, sortParam);

        // Attributes for view
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("page", currentPage);
        request.setAttribute("size", size);
        request.setAttribute("total", total);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyWordParam);
        if (categoryId != null) request.setAttribute("categoryId", categoryId);
        if (sortParam != null) request.setAttribute("sort", sortParam);

        try {
            request.getRequestDispatcher("/product-list.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
