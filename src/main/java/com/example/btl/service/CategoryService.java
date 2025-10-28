package com.example.btl.service;

import com.example.btl.dao.CategoryDAO;
import com.example.btl.model.Category;

import java.util.List;

public class CategoryService {
    private final CategoryDAO categoryDAO;

    public CategoryService(CategoryDAO categoryDAO) {
        this.categoryDAO = categoryDAO;
    }

    public Category get(int id) { return categoryDAO.getById(id); }
    public Category getBySlug(String slug) { return categoryDAO.getBySlug(slug); }
    public List<Category> listAll() { return categoryDAO.listAll(); }
    public List<Category> listActive() { return categoryDAO.listActive(); }
    public List<Category> listChildren(int parentId) { return categoryDAO.listChildren(parentId); }
    public boolean create(Category c) { return categoryDAO.create(c); }
    public boolean update(Category c) { return categoryDAO.update(c); }
    public boolean delete(int id) { return categoryDAO.delete(id); }
}

