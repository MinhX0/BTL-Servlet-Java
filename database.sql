-- Create the database
CREATE DATABASE IF NOT EXISTS btl_java_web;
USE btl_java_web;

-- ----------------------------
-- 2. Users Table (Provided by the User)
-- ----------------------------
CREATE TABLE IF NOT EXISTS users
(
    id           INT AUTO_INCREMENT PRIMARY KEY,
    username     VARCHAR(50) UNIQUE                   NOT NULL,
    password     VARCHAR(255)                         NOT NULL,
    name         VARCHAR(100)                         NOT NULL,
    email        VARCHAR(100) UNIQUE                  NOT NULL,
    phone_number VARCHAR(20),
    address      VARCHAR(255),
    role         ENUM ('CUSTOMER', 'ADMIN', 'SELLER') NOT NULL DEFAULT 'CUSTOMER',
    created_at   TIMESTAMP                                     DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP                                     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ----------------------------
-- 3. Categories Table (Product classification and hierarchy)
-- ----------------------------
CREATE TABLE Categories
(
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)        NOT NULL,
    slug        VARCHAR(100) UNIQUE NOT NULL,
    parent_id   INT                 NULL,
    is_active   BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (parent_id) REFERENCES Categories (category_id)
);

-- 4. Products Table (Parent product details)
CREATE TABLE Products
(
    product_id     INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(255)   NOT NULL,
    description    TEXT,
    -- NEW COLUMN ADDED HERE
    main_image_url VARCHAR(255)   NULL,
    base_price     DECIMAL(10, 2) NOT NULL,
    date_added     DATETIME DEFAULT CURRENT_TIMESTAMP,
    category_id    INT            NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories (category_id)
);

-- ----------------------------
-- 5. Product_Variants Table (Specific items, stock, and variant pricing)
-- ----------------------------
CREATE TABLE Product_Variants
(
    variant_id          INT AUTO_INCREMENT PRIMARY KEY,
    product_id          INT                NOT NULL,
    SKU                 VARCHAR(50) UNIQUE NOT NULL,
    size                VARCHAR(20),
    color               VARCHAR(20),
    final_variant_price DECIMAL(10, 2)     NOT NULL,
    quantity_on_hand    INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES Products (product_id),
    UNIQUE KEY idx_variant_attributes (product_id, size, color)
);

-- ----------------------------
-- 6. Carts Table (Temporary holding for user selections)
-- ----------------------------
CREATE TABLE Carts
(
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    -- FK now references the 'id' column in the Users table
    user_id      INT NOT NULL,
    variant_id   INT NOT NULL,
    quantity     INT NOT NULL CHECK (quantity > 0),
    date_added   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id),
    FOREIGN KEY (variant_id) REFERENCES Product_Variants (variant_id),
    UNIQUE KEY idx_user_variant (user_id, variant_id)
);

-- ----------------------------
-- 7. Orders Table (Header for a finalized transaction)
-- ----------------------------
CREATE TABLE Orders
(
    order_id     INT AUTO_INCREMENT PRIMARY KEY,
    -- FK now references the 'id' column in the Users table
    user_id      INT                                                                             NOT NULL,
    order_date   DATETIME                                                                                 DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2)                                                                  NOT NULL,
    status       ENUM ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Refunded') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES Users (id)
);

-- ----------------------------
-- 8. Order_Items Table (Details of what was sold in the order)
-- ----------------------------
CREATE TABLE Order_Items
(
    order_item_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT            NOT NULL,
    variant_id        INT            NOT NULL,
    quantity          INT            NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders (order_id),
    FOREIGN KEY (variant_id) REFERENCES Product_Variants (variant_id)
);