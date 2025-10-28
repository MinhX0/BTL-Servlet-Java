package com.example.btl.service;

import com.example.btl.dao.ProductVariantDAO;
import com.example.btl.model.ProductVariant;

import java.util.List;

public class ProductVariantService {
    private final ProductVariantDAO variantDAO;

    public ProductVariantService(ProductVariantDAO variantDAO) { this.variantDAO = variantDAO; }

    public ProductVariant get(int id) { return variantDAO.getById(id); }
    public ProductVariant getBySku(String sku) { return variantDAO.getBySku(sku); }
    public List<ProductVariant> listByProduct(int productId) { return variantDAO.listByProduct(productId); }
    public boolean create(ProductVariant v) { return variantDAO.create(v); }
    public boolean update(ProductVariant v) { return variantDAO.update(v); }
    public boolean delete(int id) { return variantDAO.delete(id); }
}

