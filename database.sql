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
    is_active      TINYINT(1)        NOT NULL DEFAULT 1,
    stock          INT               NOT NULL DEFAULT 100,
    FOREIGN KEY (category_id) REFERENCES Categories (category_id)
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
    AFTER UPDATE
    ON Products
    FOR EACH ROW
BEGIN
    IF NEW.is_active = 0 AND OLD.is_active <> 0 THEN
        DELETE FROM Carts WHERE product_id = NEW.product_id;
    END IF;
END $$

DROP TRIGGER IF EXISTS trg_carts_block_inactive_insert $$
CREATE TRIGGER trg_carts_block_inactive_insert
    BEFORE INSERT
    ON Carts
    FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Products p WHERE p.product_id = NEW.product_id AND p.is_active = 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add inactive product to cart';
    END IF;
END $$

DROP TRIGGER IF EXISTS trg_carts_block_inactive_update $$
CREATE TRIGGER trg_carts_block_inactive_update
    BEFORE UPDATE
    ON Carts
    FOR EACH ROW
BEGIN
    IF NEW.product_id <> OLD.product_id AND
       EXISTS (SELECT 1 FROM Products p WHERE p.product_id = NEW.product_id AND p.is_active = 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot reference inactive product in cart';
    END IF;
END $$

DELIMITER ;
-- =============================
-- End soft delete cascade triggers
-- =============================

INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogoi_muinhonden.jpeg', 'Giày Cao Gót Cao Gót Mũi Nhọn', '499000', NULL, 'Thiết kế mũi nhọn thanh lịch tôn lên vẻ sang trọng cho phái đẹp. Phù hợp để đi làm, dự tiệc hay dạo phố, giúp đôi chân trông thon gọn và quyến rũ hơn.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogot_bitmui.jpeg', 'Giày Cao Gót Cao Gót Bít Mũi Phối Cap', '549000', '466650', 'Thiết kế bít mũi phối cap tinh tế, tôn lên vẻ sang trọng và chuyên nghiệp. Phù hợp cho môi trường công sở hoặc các dịp trang trọng.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogot_dapcheo.jpeg', 'Giày Cao Gót Đắp Chéo', '549000', '466650', 'Phần quai đắp chéo mềm mại ôm chân, tạo cảm giác thoải mái và chắc chắn. Phong cách hiện đại giúp bạn dễ dàng kết hợp với nhiều outfit.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogot_khoatrangtri.jpeg', 'Giày Cao Gót Phối Dây Khóa Trang Trí', '549000', '466650', 'Trang trí dây khóa tinh tế tạo điểm nhấn sang trọng. Thiết kế tôn dáng, phù hợp cho các buổi tiệc hoặc gặp gỡ quan trọng.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogot_phoino.jpeg', 'Giày Cao Gót Slingback Phối Nơ Trang Trí', '499000', '424150', 'Chi tiết nơ nhỏ xinh tạo nét nữ tính, dịu dàng. Thiết kế slingback nhẹ nhàng giúp di chuyển thoải mái cả ngày dài.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogotpump.jpeg', 'Giày Cao Gót Pump Gót Thanh Phối Quai Trang Trí', '549000', '466650', 'Kiểu dáng pump cổ điển kết hợp quai trang trí tinh tế mang lại vẻ nữ tính và hiện đại. Gót thanh giúp di chuyển nhẹ nhàng, tôn dáng hoàn hảo.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogotpump_truquai.jpeg', 'Giày Cao Gót Pump Gót Trụ Quai Mary Jane Xéo', '549000', '466650', 'Phối quai Mary Jane cách điệu tạo điểm nhấn duyên dáng. Gót trụ chắc chắn, mang lại cảm giác vững vàng và thoải mái suốt ngày dài.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogotsequin.jpeg', 'Giày Cao Gót Phối Liệu Sequin', '549000', NULL, 'Bề mặt ánh sequin nổi bật giúp đôi giày tỏa sáng trong mọi bữa tiệc. Thiết kế cao gót tinh tế, phù hợp cho những cô nàng yêu thích sự nổi bật.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogotslingback_nhon.jpeg', 'Giày Cao Gót Slingback Gót Nhọn', '549000', '466650', 'Thiết kế slingback hở gót tạo cảm giác thoáng nhẹ, hiện đại. Gót nhọn tôn dáng và giúp bạn tự tin trong mọi bước đi.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('caogotslingback_vuong.jpeg', 'Giày Cao Gót Slingback Mũi Vuông', '499000', '424150', 'Phong cách mũi vuông thời thượng mang lại sự cá tính nhưng vẫn thanh lịch. Gót cao vừa phải, dễ phối với nhiều trang phục công sở hay dự tiệc.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cg_quaihauhong.jpeg', 'Giày Cao Gót Quai Hậu Khoá Trang Trí Xé Dán ', '499000', NULL, 'Quai hậu linh hoạt với khóa xé dán tiện dụng, dễ điều chỉnh. Kiểu dáng hiện đại, trẻ trung phù hợp cho nhiều phong cách.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cg_thanhthoat_hong.jpeg', 'Giày Cao Gót Mũi Nhọn Gót Thanh ', '659000', '560150', 'Sự kết hợp hoàn hảo giữa vẻ thanh lịch và tinh tế. Gót thanh cao vừa phải giúp tôn dáng mà vẫn dễ di chuyển.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgot_bitmui_basic.jpeg', 'Giày Cao Gót Bít Mũi Cơ Bản ', '299000', '254150', 'Thiết kế tối giản, dễ phối đồ và phù hợp trong nhiều hoàn cảnh. Đế và gót chắc chắn, mang lại cảm giác tự tin khi di chuyển.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgot_gottru.png', 'Giày Cao Gót Gót Trụ ', '549000', NULL, 'Gót trụ vững vàng giúp bạn thoải mái khi đi lại nhiều giờ. Kiểu dáng hiện đại, dễ phối với cả váy và quần âu.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgot_khoatrangtri_hong.jpeg', 'Giày Cao Gót Xi Phối Khoá Trang Trí', '499000', '424150', 'Chất liệu bóng nhẹ kết hợp khóa trang trí mang lại vẻ sang trọng. Là lựa chọn lý tưởng cho những buổi tiệc tối hoặc gặp gỡ quan trọng.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgot_noden.jpeg', 'Giày Cao Gót Phối Nơ', '379000', '322150', 'Thiết kế nơ tinh tế ở phần mũi giày mang lại vẻ mềm mại, nữ tính. Phù hợp cho phong cách ngọt ngào, thanh lịch.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgot_pump_khoatrangtri.jpeg', 'Giày Cao Gót Pump Phối Khoá Trang Trí', '549000', NULL, 'Kết hợp phong cách pump cổ điển và chi tiết khóa hiện đại. Tạo điểm nhấn sang trọng cho mọi bộ trang phục.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgot_slingback_cuoi_be.jpeg', 'Giày Cao Gót Cao Gót Slingback Mũi Nhọn Gót Thanh ', '499000', NULL, 'Kiểu slingback mũi nhọn thanh thoát tôn lên vẻ yêu kiều. Gót thanh tinh tế giúp bước đi nhẹ nhàng, uyển chuyển.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgotblue.jpeg', 'Giày Cao Gót Mũi Nhọn ', '399000', '339150', 'Đơn giản nhưng tinh tế, mũi nhọn luôn là biểu tượng của sự thanh lịch. Một đôi giày “must-have” trong tủ đồ của mọi cô gái.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('cgsuc_truthap_quaingang.jpeg', 'Giày Cao Gót Sục Gót Trụ Thấp Phối Quai Ngang ', '399000', '339150', 'Thiết kế sục tiện lợi, dễ mang và tháo. Gót trụ thấp cùng quai ngang chắc chắn giúp thoải mái di chuyển suốt cả ngày.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('gothohau.jpeg', 'Giày Cao Gót Hở Hậu Khoá Trang Trí ', '659000', NULL, 'Thiết kế hở hậu tạo cảm giác thoáng mát, kết hợp chi tiết khoá trang trí tinh tế. Phù hợp cho những buổi tiệc hoặc đi làm sang trọng.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('gottru_khoajn.jpeg', 'Giày Cao Gót Gót Trụ Phối Khoá Jn ', '349000', NULL, 'Kiểu dáng hiện đại với phần gót trụ vững chắc, tạo cảm giác thoải mái khi di chuyển. Phối khoá nhẹ nhàng tăng điểm nhấn thanh lịch.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('gotvuong_muivuong_quaicochan.jpeg', 'Giày Cao Gót Gót Vuông Mũi Vuông Quai Cổ Chân ', '549000', '466650', 'Gót vuông vững vàng kết hợp quai cổ chân giúp cố định bàn chân. Thiết kế mũi vuông mang lại phong cách thời thượng.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('mary_jane.jpeg', 'Giày Cao Gót Mary Jane Cao Gót ', '769000', '653650', 'Kiểu dáng cổ điển nhưng không kém phần hiện đại. Gót cao giúp kéo dài đôi chân và tăng vẻ quyến rũ.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('maryjane_coquai.jpeg', 'Giày Cao Gót Quai Mary Jane ', '669000', '568650', 'Dáng Mary Jane cổ điển kết hợp quai ngang nữ tính. Dễ phối với váy liền, quần tây hay đồ công sở.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('maryjane_khoatrangtri.jpeg', 'Giày Cao Gót Maryjane Phối Khóa Trang Trí ', '679000', '577150', 'Tạo điểm nhấn bằng khoá kim loại tinh tế. Kiểu dáng Mary Jane giúp tôn lên vẻ thanh lịch và duyên dáng.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('mules_muicheo.jpeg', 'Giày Cao Gót Mules Đắp Mũi Chéo', '549000', NULL, 'Phong cách mules dễ mang, phần mũi chéo tinh tế tạo điểm nhấn mềm mại. Phù hợp cho đi chơi hoặc công sở.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('mules_muinhon_gottru.jpg', 'Giày mules mũi nhọn gót trụ ', '459000', '390150', 'Mũi nhọn thanh thoát, gót trụ chắc chắn giúp di chuyển tự tin. Mang lại nét sang trọng và thoải mái trong từng bước đi.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('mules_quaicheo.jpeg', 'Giày Cao Gót Mules Quai Chéo', '659000', '560150', 'Kiểu dáng mở thoáng mát với quai chéo ôm nhẹ bàn chân. Dễ phối đồ, phù hợp nhiều hoàn cảnh.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('pump_gotnhon_muinhon.jpeg', 'Giày Cao Gót Pump Gót Nhọn Mũi Nhọn ', '559000', '475150', 'Thiết kế cổ điển tôn dáng, gót nhọn và mũi nhọn giúp đôi chân thêm thon dài. Lý tưởng cho những dịp quan trọng.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('pump_gotthanh_2si.jpeg', 'Giày Cao Gót Pump Gót Thanh Phối 2 Loại Si ', '549000', '466650', 'Gót thanh nhẹ nhàng kết hợp chất liệu si bóng mịn. Mang lại phong cách sang trọng và tinh tế.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('pump_gottru_muinhon.jpeg', 'Giày Cao Gót Pump Gót Trụ Mũi Nhọn ', '669000', '568650', 'Mũi nhọn quyến rũ đi cùng gót trụ vững chắc. Dễ phối với váy công sở hoặc trang phục dạo phố.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('pump_hogot_quaicochan.jpeg', 'Giày Cao Gót Pump Hở Gót Quai Cổ Chân ', '779000', NULL, 'Phần hở gót mang lại nét mềm mại, quai cổ chân cố định tạo cảm giác an toàn khi di chuyển.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('pump_thanhtoigian.jpeg', 'Giày Cao Gót Pump Gót Thanh Tối Giản', '549000', NULL, 'Thiết kế tối giản nhưng tinh tế, gót thanh giúp tôn lên vẻ nữ tính. Phù hợp phong cách thanh lịch hàng ngày.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('quaihau_cokhoa.jpeg', 'Giày Cao Gót Quai Hậu Xé Dán Có Khoá ', '549000', NULL, 'Quai hậu xé dán tiện lợi, kết hợp khoá tinh tế tạo sự chắc chắn. Phù hợp cho phong cách công sở hiện đại.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_cl_dan.jpeg', 'Giày Cao Gót Slingback Phối Chất Liệu Đan', '549000', NULL, 'Thiết kế độc đáo với chi tiết đan tinh xảo. Mang lại vẻ nữ tính và sang trọng cho người mang.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_dapmuicheo.jpeg', 'Giày Cao Gót Slingback Đắp Mũi Chéo', '499000', NULL, 'Mũi chéo đắp tạo điểm nhấn mềm mại, phong cách thanh lịch. Gót vừa phải giúp thoải mái suốt ngày dài.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_gottru.jpeg', 'Giày Cao Gót Slingback Gót Trụ', '499000', NULL, 'Gót trụ chắc chắn kết hợp quai sau tiện dụng. Mang đến phong cách trẻ trung, dễ phối đồ.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_gotv_toecap.jpeg', 'Giày Cao Gót Slingback Gót Vuông Phối Toecap Và Khóa Trang Trí ', '499000', NULL, 'Thiết kế phối toecap sang trọng, nhấn nhá bằng chi tiết khoá kim loại. Tạo ấn tượng hiện đại và tinh tế.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_gotvuong.jpeg', 'Giày Cao Gót Slingback Gót Vuông', '399000', NULL, 'Dáng slingback cùng gót vuông vững vàng. Phù hợp cho cả đi làm và dạo phố.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_gotvuong_cokhoa.jpeg', 'Giày Cao Gót Slingback Gót Vuông Có Khoá ', '499000', NULL, 'Gót vuông cao nhẹ cùng khoá tinh tế tạo điểm nhấn. Dễ mang và phù hợp nhiều phong cách thời trang.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_ho.jpeg', 'Giày Cao Gót Slingback Hở', '699000', NULL, 'Dáng hở gót thoáng mát, tạo cảm giác nhẹ nhàng và thanh thoát. Phù hợp phong cách tối giản.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_khoatrangtri.jpeg', 'Giày Cao Gót Slingback Phối Khóa Trang Trí', '549000', NULL, 'Khoá trang trí nổi bật mang lại vẻ sang trọng. Gót vừa phải cho cảm giác thoải mái khi di chuyển.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_lieubong.jpeg', 'Giày Cao Gót Slingback Phối Liệu Bóng', '549000', NULL, 'Chất liệu bóng mịn giúp đôi giày nổi bật hơn. Dáng slingback dễ mang và tôn dáng hiệu quả.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_muiden.jpeg', 'Giày Cao Gót Slingback Mũi Nhọn Phối Toecap', '499000', NULL, 'Mũi nhọn phối toecap tạo cảm giác tinh tế và thời thượng. Lý tưởng cho các buổi tiệc nhẹ hoặc đi làm.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_muinhonden.jpeg', 'Giày Cao Gót Cao Gót Slingback Mũi Nhọn Gót Thanh', '599000', NULL, 'Gót thanh nhỏ gọn giúp tôn lên vóc dáng. Thiết kế slingback mang lại cảm giác nhẹ nhàng, tinh tế.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_notrangtri.jpeg', 'Giày Cao Gót Trang Trí Nơ ', '659000', NULL, 'Nơ nhỏ xinh tạo điểm nhấn đáng yêu. Thiết kế đơn giản nhưng vẫn giữ nét thanh lịch và duyên dáng', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_phoixich.jpeg', 'Giày Cao Gót Slingback Phối Xích', '459000', NULL, 'Phối xích kim loại sang trọng, phá cách nhẹ nhàng. Thích hợp cho phong cách cá tính, hiện đại.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingback_toecap.jpeg', 'Giày Cao Gót Slingback Phối Toe Cap', '549000', NULL, 'Toecap nổi bật giúp bảo vệ mũi giày, đồng thời tăng tính thẩm mỹ. Kiểu dáng slingback thoải mái khi mang.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('slingbackpump_toigian.jpeg', 'Giày Cao Gót Slingback Pump Tối Giản', '549000', '466650', 'Dáng slingback hở gót thoáng mát, tông màu trung tính dễ phối. Gót thanh cao nhẹ giúp tôn dáng tự nhiên.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew000500.jpg', 'Dép Eva Biti\'s Nữ BEW000500', '216000', '183600', 'Dép EVA nhẹ, đế êm ái giúp di chuyển thoải mái. Thiết kế đơn giản, thích hợp mang hằng ngày.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew000902den.jpg', 'Dép Eva Biti\'s Nữ Màu Đen BEW000902DEN', '219000', '186150', 'Màu đen thanh lịch, chất liệu EVA siêu nhẹ. Đế mềm giúp bước đi êm chân và dễ vệ sinh.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew000902kem.jpg', 'Dép Eva Phun Nữ Biti\'s BEW000902KEM', '120450', '102382.5', 'Gam màu kem nhã nhặn, thiết kế tiện dụng. Phù hợp mang trong nhà hoặc khi đi dạo.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew000902xdl.jpg', 'Dép Eva Phun Nữ Biti\'s BEW000902XDL', '274350', '233197.5', 'Dáng dép phun nguyên khối bền chắc, màu xám dịu nhẹ. Tạo cảm giác thoải mái suốt ngày dài.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001100.jpg', 'Dép Eva Biti\'s E-Soft Nữ BEW001100', '274000', '232900', 'Công nghệ E-Soft êm ái hỗ trợ bàn chân. Phong cách tối giản, dễ phối đồ hằng ngày.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001100xmn.jpg', 'Dép Eva Biti\'s E-Soft Nữ Màu Xanh Mi Nơ BEW001100XMN', '265000', '225250', 'Thiết kế nơ xinh xắn cùng tông xanh dịu mắt. Chất liệu E-Soft mềm mại mang lại sự êm ái khi di chuyển.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001102.jpg', 'Dép Eva Biti\'s Nữ BEW001102', '295000', '250750', 'Dép nữ nhẹ, bền, đế chống trơn trượt hiệu quả. Phù hợp mang trong nhà hoặc đi chơi nhẹ nhàng.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001104hog.jpg', 'Dép Eva Biti\'s Esoft Nữ Màu Hồng BEW001104HOG', '295000', NULL, 'Dép E-Soft êm ái với tông hồng ngọt ngào, nữ tính. Đế mềm hỗ trợ di chuyển nhẹ nhàng, phù hợp mang trong nhà hoặc đi dạo.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001104kem.jpg', 'Dép Eva Phun Nữ Biti\'s BEW000902KEM', '295000', NULL, 'Dép EVA nhẹ, bền, gam màu kem thanh lịch. Thiết kế phun nguyên khối giúp thoải mái và chống trơn trượt hiệu quả.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001104trg.jpg', 'Dép Eva Biti\'s Esoft Nữ Màu Trắng BEW001104TRG', '295000', NULL, 'Màu trắng tinh khôi, thiết kế đơn giản. Chất liệu E-Soft êm chân giúp di chuyển thoải mái suốt ngày dài.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001104xng.jpg', 'Dép Eva Biti\'s Esoft Nữ Màu Xanh Ngọc BEW001104XNG', '96000', NULL, 'Màu xanh ngọc tươi sáng, mang cảm giác nhẹ nhàng. Đế E-Soft mềm mại phù hợp mang đi học hoặc đi chơi.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001300.jpg', 'Dép Eva Biti\'s Nữ BEW001300', '166000', NULL, 'Dép nữ cơ bản với chất liệu EVA siêu nhẹ. Đế chống trượt và bền bỉ, dễ vệ sinh và phù hợp dùng hằng ngày.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001301.jpg', 'Dép Eva Biti\'s Nữ BEW001301', '151000', NULL, 'Kiểu dáng tiện dụng, ôm chân nhẹ nhàng. Đế EVA mềm mại giúp thoải mái trong từng bước đi.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew001800.jpg', 'Dép Eva Biti\'s Nữ BEW001800', '120000', NULL, 'Dép EVA cao cấp, thiết kế tối giản. Đế đàn hồi và chống trượt giúp an toàn khi di chuyển.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew002300den.jpg', 'Dép Eva Biti\'s Nữ Màu Đen BEW002300DEN', '116000', NULL, 'Gam đen sang trọng, dễ phối đồ. Dép EVA nhẹ, êm và bền, phù hợp sử dụng cả trong nhà và ngoài trời.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew002300kem.jpg', 'Dép Eva Biti\'s Nữ Màu Kem BEW002300KEM', '120000', NULL, 'Màu kem nhã nhặn, tông trung tính dễ phối. Đế mềm giúp giảm áp lực bàn chân khi di chuyển lâu.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew002300xdl.jpg', 'Dép Eva Biti\'s Nữ Màu Xanh Dương Lợt BEW002300XDL', '175000', NULL, 'Màu xanh dương lợt tươi mát, thiết kế trẻ trung. Đế EVA nhẹ và linh hoạt cho cảm giác dễ chịu.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew002800den.jpg', 'Dép Eva Biti\'s Nữ Màu Đen BEW002800DEN', '175000', '148750', 'Dáng dép cơ bản dễ mang, tông đen sang trọng. Chất liệu EVA nhẹ, bền và chống thấm nước.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew002800ked.jpg', 'Dép Eva Biti\'s Nữ Màu Kem Đậm BEW002800KED', '175000', '148750', 'Màu kem đậm tinh tế, đế chống trượt hiệu quả. Phù hợp dùng trong sinh hoạt hằng ngày.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew002800trg.jpg', 'Dép Eva Biti\'s Nữ Màu Trắng BEW002800TRG', '175000', '148750', 'Dép trắng đơn giản, trẻ trung. Đế EVA êm nhẹ, giúp bước đi thoải mái mọi lúc.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew002900den.jpg', 'Dép Eva Biti\'s Sapa Nữ Màu Đen BEW002900DEN', '109000', '92650', 'Mẫu dép Sapa bền bỉ, thiết kế ôm chân chắc chắn. Tông đen mạnh mẽ, dễ phối nhiều kiểu đồ.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003000cam.jpg', 'Dép Eva Nữ Biti\'s Màu Cam BEW003000CAM', '109000', '92650', 'Màu cam nổi bật mang lại sự tươi trẻ. Chất liệu EVA nhẹ, chống trơn và dễ vệ sinh.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003000den.jpg', 'Dép Eva Nữ Biti\'s Màu Đen BEW003000DEN', '109000', '92650', 'Kiểu dáng đơn giản, màu đen sang trọng. Đế mềm và nhẹ giúp bước đi tự nhiên.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003000kem.jpg', 'Dép Eva Nữ Biti\'s Màu Kem BEW003000KEM', '109000', '92650', 'Màu kem dịu nhẹ, phù hợp phong cách nữ tính. Dép EVA nhẹ và bền, mang êm chân cả ngày.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003000xam.jpg', 'Dép Biti\'s Nữ Màu Xám BEW003000XAM', '280000', '238000', 'Tông xám trung tính, dễ phối trang phục. Dép EVA mềm mại giúp thoải mái khi sử dụng lâu.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003200den.jpg', 'Dép Biti\'s Nữ Màu Đen BEW003200DEN', '280000', NULL, 'Dép nữ màu đen cổ điển, đế chống trượt. Thiết kế chắc chắn, phù hợp dùng hàng ngày.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003200ked.jpg', 'Dép Biti\'s Nữ Màu Kem Đậm BEW003200KED', '280000', NULL, 'Màu kem đậm tinh tế, thiết kế tối giản. Đế EVA êm ái giúp giảm mỏi chân.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003200til.jpg', 'Dép Biti\'s Nữ Màu Tím Lợt BEW003200TIL', '185000', NULL, 'Gam tím lợt nhẹ nhàng, mang nét nữ tính. Đế nhẹ và đàn hồi, phù hợp cho mọi độ tuổi.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003600ked.jpg', 'Dép Biti\'s Nữ Màu Kem Đậm BEW003600KED', '125000', NULL, 'Dép EVA bền nhẹ, màu kem đậm hiện đại. Đế mềm giúp di chuyển linh hoạt, êm ái.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bew003700den.jpg', 'Dép Biti\'s Nữ Màu Đen BEW003700DEN', '465000', NULL, 'Dép đen đơn giản, thiết kế tinh gọn. Đế chống trượt phù hợp cho cả đi trong nhà và ngoài trời.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bfw005388den.jpg', 'Dép Cao Gót Biti’s Nữ Màu Đen BFW005388DEN', '465000', NULL, 'Dép cao gót tông đen sang trọng, kiểu dáng hiện đại. Đế cao vừa phải giúp tôn dáng mà vẫn thoải mái.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bfw005388kem.jpg', 'Dép Cao Gót Biti’s Nữ Màu Kem BFW005388KEM', '440000', NULL, 'Màu kem thanh lịch, đế cao nhẹ. Thiết kế nữ tính phù hợp đi tiệc hoặc công sở.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bfw005488den.jpg', 'Dép Cao Gót Biti’s Nữ Màu Đen BFW005488DEN', '440000', NULL, 'Dáng cao gót cơ bản, tông đen thời thượng. Đế chắc chắn giúp di chuyển tự tin.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bfw005488dod.jpg', 'Dép Cao Gót Biti’s Nữ Màu Đỏ Đậm BFW005488DOD', '440000', NULL, 'Màu đỏ đậm nổi bật, tôn vẻ quyến rũ. Gót cao nhẹ nhàng, phù hợp phong cách sang trọng.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bfw005488kem.jpg', 'Dép Cao Gót Biti’s Nữ Màu Kem BFW005488KEM', '300000', NULL, 'Tông kem tinh tế, phù hợp mọi trang phục. Gót cao nhẹ giúp đôi chân thêm thanh thoát.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bpw003788den.jpg', 'Dép Nữ Bit\'s BPW003788DEN', '300000', '255000', 'Dép nữ màu đen cổ điển, kiểu dáng đơn giản. Đế êm và nhẹ, dễ mang hằng ngày.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bpw003788kem.jpg', 'Dép Nữ Biti\'s BPW003788KEM', '300000', '255000', 'Màu kem thanh nhã, thiết kế tiện dụng. Phù hợp cho mọi hoạt động thường ngày.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bpw004288den.jpg', 'Dép Biti\'s Nữ Màu Đen BPW004288DEN', '240000', '204000', 'Dép nữ bền chắc, màu đen sang trọng. Đế chống trượt giúp an toàn khi di chuyển.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bpw004288nau.jpg', 'Dép Biti\'s Nữ Màu Nâu BPW004288NAU', '436000', '370600', 'Màu nâu trung tính, dễ phối đồ. Đế êm, thoáng và chống trơn hiệu quả.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bpw005688nau.jpg', 'Sandal Đế Xuồng Biti\'s Nữ Màu Nâu BPW005688NAU', '170000', '144500', 'Sandal đế xuồng giúp tôn dáng tự nhiên. Màu nâu nhã nhặn, phù hợp phong cách thanh lịch.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw020100den.jpg', 'Dép Biti\'s Nữ Màu Đen BXW020100DEN', '170000', '144500', 'Dép quai ngang cơ bản, tông đen dễ phối. Đế mềm êm mang lại cảm giác thoải mái.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw020100doo.jpg', 'Dép Biti\'s Nữ Màu Đỏ BXW020100DOO', '170000', '144500', 'Màu đỏ nổi bật, thiết kế năng động. Dép EVA nhẹ, dễ mang cho mọi lứa tuổi.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw020100nau.jpg', 'Dép Biti\'s Nữ Màu Nâu BXW020100NAU', '140000', '119000', 'Gam nâu ấm áp, kiểu dáng bền bỉ. Phù hợp mang trong nhà hoặc đi chơi nhẹ.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw020200den.jpg', 'Dép Biti\'s Nữ Màu Đen BXW020200DEN', '130000', '110500', 'Dáng dép cổ điển, đế êm chống trượt. Màu đen trung tính dễ phối quần áo.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw020200doo.jpg', 'Dép Biti\'s Nữ Màu Đỏ BXW020200DOO', '150000', NULL, 'Màu đỏ cá tính, chất liệu bền nhẹ. Dép êm chân, phù hợp đi bộ hoặc đi chợ.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw020900den.jpg', 'Dép Xốp Biti\'s Nữ Màu Đen BXW020900DEN', '150000', NULL, 'Dép xốp nhẹ, thoáng khí. Màu đen sang trọng, tiện mang hằng ngày.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw021900den.jpg', 'Dép Xốp Biti\'s Nữ Màu Đen BXW021900DEN', '170000', NULL, 'Dép xốp êm ái, đế chống trượt. Thiết kế gọn nhẹ, phù hợp mang trong nhà.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('bxw021900hog.jpg', 'Dép Xốp Biti\'s Nữ Màu Hồng BXW021900HOG', '200000', NULL, 'Màu hồng ngọt ngào, nhẹ nhàng nữ tính. Dép xốp mềm mang lại cảm giác êm chân dễ chịu.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('byw001000den.jpg', 'Dép Biti\'s Nữ Màu Đen BYW001000DEN', '300000', NULL, 'Dép nữ màu đen đơn giản, thiết kế chắc chắn. Phù hợp mang đi làm hoặc đi dạo.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('byw001000nau.jpg', 'Dép Biti\'s Nữ Màu Nâu BYW001000NAU', '380000', NULL, 'Tông nâu hiện đại, kiểu dáng tiện dụng. Đế êm và chống trượt hiệu quả.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('byw001000til.jpg', 'Dép Biti\'s Nữ Màu Tím Lợt BYW001000TIL', '280000', NULL, 'Màu tím lợt dễ thương, trẻ trung. Dép nhẹ, dễ mang và tạo cảm giác thoải mái.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('dew003101den.jpg', 'Dép Eva Phun Nữ DEW003101DEN (Đen)', '92000', NULL, 'Dép EVA phun màu đen tinh tế, đế êm nhẹ. Dễ vệ sinh và phù hợp dùng hàng ngày.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('dew003101xam.png', 'Dép Eva Biti\'s Nữ Màu Xám DEW003101XAM', '91000', NULL, 'Màu xám trung tính, kiểu dáng tối giản. Chất liệu EVA nhẹ và bền, phù hợp mọi lứa tuổi.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('dew003101xnh.png', 'Dép Eva Biti\'s Nữ Màu Xanh Nhớt DEW003101XNH', '91000', NULL, 'Gam xanh nhớt độc đáo, trẻ trung. Dép EVA siêu nhẹ, mang lại cảm giác thoải mái.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('dew007900.jpg', 'Dép Eva Biti\'s Nữ DEW007900', '104000', NULL, 'Dép nữ đơn giản, chất liệu EVA bền nhẹ. Phù hợp sử dụng trong nhà hoặc đi biển.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('gfw019688den.jpg', 'Dép Thời Trang Gosto Nữ Màu Đen GFW019688DEN', '450000', NULL, 'Dép thời trang tông đen cá tính, thiết kế hiện đại. Đế mềm giúp dễ dàng di chuyển cả ngày.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('hew001200hog.jpg', 'Dép Eva Biti\'s Hunter Nữ Màu Hồng HEW001200HOG', '300000', '255000', 'Màu hồng nữ tính, phong cách trẻ trung. Chất liệu EVA mềm và bền, mang lại sự thoải mái tuyệt đối.', '3');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('hew001200kem.jpg', 'Dép Eva Biti\'s Hunter Nữ Màu Kem HEW001200KEM', '200000', '170000', 'Dép Hunter tông kem nhẹ nhàng, phù hợp mọi trang phục. Đế chống trượt, êm ái khi di chuyển.', '4');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('hew001200trg.jpg', 'Dép Eva Biti\'s Hunter Nữ Màu Trắng HEW001200TRG', '230000', '195500', 'Màu trắng tinh tế, thiết kế hiện đại. Dép EVA nhẹ, phù hợp cho phong cách năng động.', '5');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('hew001201den.jpg', 'Dép Eva Biti\'s Hunter Nữ Màu Đen HEW001201DEN', '230000', '195500', 'Tông đen mạnh mẽ, phong cách thể thao. Đế EVA mềm giúp thoải mái khi mang lâu.', '1');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('x0221b000den.jpg', 'Dép Xốp Biti\'s Nữ Màu Đen X0221B000DEN', '230000', '195500', 'Dép xốp đen cổ điển, nhẹ và thoáng. Thiết kế tiện dụng phù hợp sử dụng hàng ngày.', '2');
INSERT INTO `products` (`main_image_url`, `name`, `base_price`, `sale_price`, `description`, `category_id`) VALUES ('x0221b000nau.png', 'Dép Xốp Biti\'s Nữ Màu Nâu X0221B000NAU', '210000', '178500', 'Gam nâu trầm ấm, chất liệu xốp êm ái. Đế chống trượt, dễ mang và bền bỉ.', '3');
