package com.example.btl.servlet;

import com.example.btl.dao.ProductDAO;
import com.example.btl.model.Product;
import com.example.btl.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() {
        this.productService = new ProductService(new ProductDAO());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (Exception ex) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }
        Product product = productService.get(id);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }
        req.setAttribute("product", product);
        // Simple related products: same category, exclude self, limit 8
        List<Product> related;
        try {
            related = productService.listByCategory(product.getCategory().getId());
        } catch (Exception e) {
            related = Collections.emptyList();
        }
        related.removeIf(p -> p.getId() == product.getId());
        if (related.size() > 8) {
            related = related.subList(0, 8);
        }
        req.setAttribute("relatedProducts", related);
        // For JSP date format placeholder
        req.setAttribute("nowDate", new Date());
        try {
            req.getRequestDispatcher("/product-detail.jsp").forward(req, resp);
        } catch (ServletException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
