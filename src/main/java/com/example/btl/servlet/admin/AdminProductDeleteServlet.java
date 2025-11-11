package com.example.btl.servlet.admin;

import com.example.btl.dao.ProductDAO;
import com.example.btl.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminProductDeleteServlet", urlPatterns = {"/admin/products/delete"})
public class AdminProductDeleteServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index"); return; }

        String idParam = request.getParameter("id");
        boolean ok = false;
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                ok = productDAO.delete(id); // soft delete (sets active=false)
            } catch (NumberFormatException ignored) { }
        }
        String redirect = request.getContextPath() + "/admin/products" + (ok ? "?deleted=1" : "?deleted=0");
        response.sendRedirect(redirect);
    }
}

