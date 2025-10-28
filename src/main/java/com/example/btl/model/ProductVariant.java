package com.example.btl.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "Product_Variants",
       uniqueConstraints = @UniqueConstraint(name = "idx_variant_attributes", columnNames = {"product_id", "size", "color"}))
public class ProductVariant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "variant_id")
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name = "SKU", unique = true, length = 50, nullable = false)
    private String sku;

    @Column(length = 20)
    private String size;

    @Column(length = 20)
    private String color;

    @Column(name = "final_variant_price", precision = 10, scale = 2, nullable = false)
    private BigDecimal finalVariantPrice;

    @Column(name = "quantity_on_hand")
    private Integer quantityOnHand = 0;

    public ProductVariant() { }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public BigDecimal getFinalVariantPrice() { return finalVariantPrice; }
    public void setFinalVariantPrice(BigDecimal finalVariantPrice) { this.finalVariantPrice = finalVariantPrice; }
    public Integer getQuantityOnHand() { return quantityOnHand; }
    public void setQuantityOnHand(Integer quantityOnHand) { this.quantityOnHand = quantityOnHand; }
}

