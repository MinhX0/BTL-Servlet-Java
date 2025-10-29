package com.example.btl.servlet;

import com.example.btl.dao.ProductDAO;
import com.example.btl.dao.CategoryDAO;
import com.example.btl.model.Product;
import com.example.btl.model.Category;
import com.example.btl.service.ProductService;
import com.example.btl.service.CategoryService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
        int limit = 8; // number of featured products to show
        List<Product> featured = productService.searchPaged(null, null, 0, limit, "date_desc");
        List<Category> categories = categoryService.listActive();
        request.setAttribute("featuredProducts", featured);
        request.setAttribute("categories", categories);
        try {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
