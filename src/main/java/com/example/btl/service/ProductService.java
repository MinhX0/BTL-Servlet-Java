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
    public boolean create(Product p) { return productDAO.create(p); }
    public boolean update(Product p) { return productDAO.update(p); }
    public boolean delete(int id) { return productDAO.delete(id); }
}

