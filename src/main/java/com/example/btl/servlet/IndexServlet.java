package com.example.btl.servlet;

import com.example.btl.dao.ProductDAO;
import com.example.btl.dao.CategoryDAO;
import com.example.btl.model.Product;
import com.example.btl.model.Category;
import com.example.btl.model.User;
import com.example.btl.service.ProductService;
import com.example.btl.service.CategoryService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "IndexServlet", urlPatterns = {"/index"})
public class IndexServlet extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;

    @Override
    public void init() {
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
        int limit = 8; // number of items per row
        List<Product> featured = productService.searchPaged(null, null, 0, limit, "date_desc");
        List<Product> onSale = productService.listOnSale(limit);
        List<Product> newest = productService.listNewest(limit);
        List<Category> categories = categoryService.listActive();
        request.setAttribute("featuredProducts", featured);
        request.setAttribute("onSaleProducts", onSale);
        request.setAttribute("newestProducts", newest);
        request.setAttribute("categories", categories);
        try {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
