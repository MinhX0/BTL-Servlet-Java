package com.example.btl.service;

import com.example.btl.dao.ProductDAO;
import com.example.btl.model.Product;

import java.util.List;

public class ProductService {
    private final ProductDAO productDAO;

    public ProductService(ProductDAO productDAO) { this.productDAO = productDAO; }

    public Product get(int id) { return productDAO.getById(id); }
    public List<Product> listAll() { return productDAO.listAll(); }
    public List<Product> listByCategory(int categoryId) { return productDAO.listByCategory(categoryId); }

    // Find products by (partial) name
    public List<Product> findByName(String name) { return productDAO.findByName(name); }

    // Flexible search
    public List<Product> search(Integer categoryId, String name) { return productDAO.search(categoryId, name); }

    // Pagination support
    public long searchCount(Integer categoryId, String name) { return productDAO.searchCount(categoryId, name); }
    public List<Product> searchPaged(Integer categoryId, String name, int offset, int limit) {
        return productDAO.searchPaged(categoryId, name, offset, limit);
    }
    public List<Product> searchPaged(Integer categoryId, String name, int offset, int limit, String sort) {
        return productDAO.searchPaged(categoryId, name, offset, limit, sort);
    }

    public boolean create(Product p) { return productDAO.create(p); }
    public boolean update(Product p) { return productDAO.update(p); }
    public boolean delete(int id) { return productDAO.delete(id); }
}
