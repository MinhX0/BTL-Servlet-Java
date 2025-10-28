package com.example.btl.service;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.model.CartItem;

import java.util.List;

public class CartService {
    private final CartItemDAO cartItemDAO;

    public CartService(CartItemDAO cartItemDAO) { this.cartItemDAO = cartItemDAO; }

    public List<CartItem> listByUser(int userId) { return cartItemDAO.listByUser(userId); }

    public boolean addOrIncrement(int userId, int variantId, int delta) {
        CartItem existing = cartItemDAO.findByUserAndVariant(userId, variantId);
        if (existing == null) {
            CartItem item = new CartItem();
            item.setQuantity(Math.max(1, delta));
            com.example.btl.model.User u = new com.example.btl.model.User();
            u.setId(userId);
            item.setUser(u);
            com.example.btl.model.ProductVariant v = new com.example.btl.model.ProductVariant();
            v.setId(variantId);
            item.setVariant(v);
            item.setDateAdded(java.time.LocalDateTime.now());
            return cartItemDAO.create(item);
        } else {
            existing.setQuantity(existing.getQuantity() + delta);
            if (existing.getQuantity() <= 0) {
                return cartItemDAO.delete(existing.getId());
            }
            return cartItemDAO.update(existing);
        }
    }

    public boolean updateQuantity(int cartItemId, int quantity) {
        CartItem item = cartItemDAO.getById(cartItemId);
        if (item == null) return false;
        if (quantity <= 0) return cartItemDAO.delete(cartItemId);
        item.setQuantity(quantity);
        return cartItemDAO.update(item);
    }

    public boolean clearCart(int userId) { return cartItemDAO.deleteByUser(userId); }
}

