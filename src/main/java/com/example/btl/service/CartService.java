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
            // default size 42 for legacy flow
            item.setItemSize("42");
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

    // Change size for a cart item; merge if there's an existing line with same product and newSize.
    public boolean changeSize(int cartItemId, String newSize, int userId) {
        CartItem item = cartItemDAO.getById(cartItemId);
        if (item == null) return false;
        String size = (newSize == null || newSize.isBlank()) ? null : (newSize.length() > 10 ? newSize.substring(0,10) : newSize);
        int productId = item.getProduct().getId();
        // Check if a line with same product+size exists for this user
        CartItem target = cartItemDAO.findByUserProductSize(userId, productId, size);
        if (target != null && target.getId() != item.getId()) {
            // merge quantities into target, delete current
            target.setQuantity(target.getQuantity() + item.getQuantity());
            cartItemDAO.update(target);
            return cartItemDAO.delete(item.getId());
        }
        item.setItemSize(size);
        return cartItemDAO.update(item);
    }

    public boolean clearCart(int userId) { return cartItemDAO.deleteByUser(userId); }
}
