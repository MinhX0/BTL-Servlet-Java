package com.example.btl.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private int id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "main_image_url")
    private String mainImageUrl;

    // VND stored as BIGINT (no decimals)
    @Column(name = "base_price", nullable = false)
    private long basePrice;

    // Optional sale price (if null/<=0 => not discounted)
    @Column(name = "sale_price")
    private Long salePrice;

    @Column(name = "date_added")
    private LocalDateTime dateAdded;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    // New: inventory stock (total units available across sizes)
    @Column(name = "stock", nullable = false)
    private int stock = 0;

    public Product() { }

    // getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getMainImageUrl() { return mainImageUrl; }
    public void setMainImageUrl(String mainImageUrl) { this.mainImageUrl = mainImageUrl; }
    public long getBasePrice() { return basePrice; }
    public void setBasePrice(long basePrice) { this.basePrice = basePrice; }
    public Long getSalePrice() { return salePrice; }
    public void setSalePrice(Long salePrice) { this.salePrice = salePrice; }
    public void setSalePrice(long salePrice) { this.salePrice = salePrice; }
    public LocalDateTime getDateAdded() { return dateAdded; }
    public void setDateAdded(LocalDateTime dateAdded) { this.dateAdded = dateAdded; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = Math.max(0, stock); }

    // Alias for JSP usage: imgsrc -> maps to mainImageUrl
    @Transient
    public String getImgsrc() { return mainImageUrl; }
    public void setImgsrc(String imgsrc) { this.mainImageUrl = imgsrc; }

    // Effective price for UI/logic
    @Transient
    public long getEffectivePrice() { return (salePrice != null && salePrice > 0) ? salePrice : basePrice; }

    @Transient
    public boolean isInStock() { return active && stock > 0; }
}
