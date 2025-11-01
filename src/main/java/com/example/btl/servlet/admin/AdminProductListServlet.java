package com.example.btl.servlet.admin;

import com.example.btl.dao.ProductDAO;
import com.example.btl.model.Product;
import com.example.btl.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProductListServlet", urlPatterns = {"/admin/products"})
public class AdminProductListServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        List<Product> products = productDAO.listAll();
        request.setAttribute("products", products);
        try {
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

