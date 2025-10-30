package com.example.btl.service;

import com.example.btl.dao.CartItemDAO;
import com.example.btl.model.CartItem;
import com.example.btl.model.Product;
import com.example.btl.model.User;

import java.util.List;

public class CartService {
    private final CartItemDAO cartItemDAO;

    public CartService(CartItemDAO cartItemDAO) { this.cartItemDAO = cartItemDAO; }

    public List<CartItem> listByUser(int userId) { return cartItemDAO.listByUser(userId); }
    public List<CartItem> listByUserDetailed(int userId) { return cartItemDAO.listByUserDetailed(userId); }

    public boolean addOrIncrement(int userId, int productId, int delta) {
        CartItem existing = cartItemDAO.findByUserAndProduct(userId, productId);
        if (existing == null) {
            CartItem item = new CartItem();
            item.setQuantity(Math.max(1, delta));
            User u = new User();
            u.setId(userId);
            item.setUser(u);
            Product p = new Product();
            p.setId(productId);
            item.setProduct(p);
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
