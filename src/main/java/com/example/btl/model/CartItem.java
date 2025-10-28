package com.example.btl.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Carts",
       uniqueConstraints = @UniqueConstraint(name = "idx_user_variant", columnNames = {"user_id", "variant_id"}))
public class CartItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cart_item_id")
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariant variant;

    @Column(nullable = false)
    private int quantity;

    @Column(name = "date_added")
    private java.time.LocalDateTime dateAdded;

    public CartItem() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public ProductVariant getVariant() { return variant; }
    public void setVariant(ProductVariant variant) { this.variant = variant; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public java.time.LocalDateTime getDateAdded() { return dateAdded; }
    public void setDateAdded(java.time.LocalDateTime dateAdded) { this.dateAdded = dateAdded; }
}

