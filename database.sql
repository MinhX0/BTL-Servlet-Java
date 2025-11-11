-- Create the database
CREATE DATABASE IF NOT EXISTS btl_java_web_test;
USE btl_java_web_test;

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
    is_active    TINYINT(1)                           NOT NULL DEFAULT 1,
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
    sale_price     DECIMAL(10, 2) NULL,
    date_added     DATETIME                DEFAULT CURRENT_TIMESTAMP,
    category_id    INT            NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories (category_id),
    is_active      TINYINT        NOT NULL DEFAULT 1
);

-- ----------------------------
-- 6. Carts Table (Temporary holding for user selections)
-- ----------------------------
CREATE TABLE Carts
(
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    -- FK now references the 'id' column in the Users table
    user_id      INT         NOT NULL,
    product_id   INT         NOT NULL,
    quantity     INT         NOT NULL CHECK (quantity > 0),
    size         VARCHAR(10) NULL,
    date_added   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES Products (product_id),
    UNIQUE KEY idx_user_product_size (user_id, product_id, size)
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
    address      VARCHAR(500),
    FOREIGN KEY (user_id) REFERENCES Users (id)
);

-- ----------------------------
-- 8. Order_Items Table (Details of what was sold in the order)
-- ----------------------------
CREATE TABLE Order_Items
(
    order_item_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT            NOT NULL,
    product_id        INT            NOT NULL,
    quantity          INT            NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL,
    size              VARCHAR(10)    NULL,
    FOREIGN KEY (order_id) REFERENCES Orders (order_id),
    FOREIGN KEY (product_id) REFERENCES Products (product_id)
);

-- =============================
-- Soft Delete Cascade & Guards
-- Remove cart items when a product is soft-deleted (is_active set to 0)
-- Block adding/updating cart items that reference inactive products
-- =============================
DELIMITER $$

DROP TRIGGER IF EXISTS trg_products_soft_delete_carts_cleanup $$
CREATE TRIGGER trg_products_soft_delete_carts_cleanup
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
  IF NEW.is_active = 0 AND OLD.is_active <> 0 THEN
    DELETE FROM Carts WHERE product_id = NEW.product_id;
  END IF;
END $$

DROP TRIGGER IF EXISTS trg_carts_block_inactive_insert $$
CREATE TRIGGER trg_carts_block_inactive_insert
BEFORE INSERT ON Carts
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM Products p WHERE p.product_id = NEW.product_id AND p.is_active = 0) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add inactive product to cart';
  END IF;
END $$

DROP TRIGGER IF EXISTS trg_carts_block_inactive_update $$
CREATE TRIGGER trg_carts_block_inactive_update
BEFORE UPDATE ON Carts
FOR EACH ROW
BEGIN
  IF NEW.product_id <> OLD.product_id AND EXISTS (SELECT 1 FROM Products p WHERE p.product_id = NEW.product_id AND p.is_active = 0) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot reference inactive product in cart';
  END IF;
END $$

DELIMITER ;
-- =============================
-- End soft delete cascade triggers
-- =============================
