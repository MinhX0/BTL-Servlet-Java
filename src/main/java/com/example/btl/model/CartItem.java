package com.example.btl.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Carts",
       uniqueConstraints = @UniqueConstraint(name = "idx_user_product", columnNames = {"user_id", "product_id"}))
public class CartItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cart_item_id")
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(nullable = false)
    private int quantity;

    @Column(name = "date_added")
    private java.time.LocalDateTime dateAdded;

    public CartItem() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public java.time.LocalDateTime getDateAdded() { return dateAdded; }
    public void setDateAdded(java.time.LocalDateTime dateAdded) { this.dateAdded = dateAdded; }
}
