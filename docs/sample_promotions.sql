-- Sample Promotions for Testing
-- Run this after creating the Promotions table

-- Active promotion: 10% off for orders over 200,000 VND
INSERT INTO Promotions (name, description, discount_type, discount_value, min_order_amount, start_date, end_date, is_active)
VALUES
('Giảm 10% cho đơn hàng trên 200K',
 'Áp dụng cho tất cả đơn hàng có giá trị từ 200,000đ trở lên',
 'PERCENTAGE',
 10.00,
 200000.00,
 '2025-01-01 00:00:00',
 '2025-12-31 23:59:59',
 1);

-- Flash sale: 50,000 VND off for orders over 500,000 VND
INSERT INTO Promotions (name, description, discount_type, discount_value, min_order_amount, start_date, end_date, is_active)
VALUES
('Flash Sale - Giảm 50K',
 'Giảm ngay 50,000đ cho đơn hàng từ 500,000đ',
 'FIXED_AMOUNT',
 50000.00,
 500000.00,
 '2025-11-25 00:00:00',
 '2025-12-25 23:59:59',
 1);

-- Holiday promotion: 15% off for orders over 300,000 VND
INSERT INTO Promotions (name, description, discount_type, discount_value, min_order_amount, start_date, end_date, is_active)
VALUES
('Giáng Sinh 2025 - Giảm 15%',
 'Ưu đãi đặc biệt mừng Giáng Sinh cho đơn hàng từ 300,000đ',
 'PERCENTAGE',
 15.00,
 300000.00,
 '2025-12-20 00:00:00',
 '2025-12-26 23:59:59',
 1);

-- New Year promotion: 100,000 VND off for orders over 1,000,000 VND
INSERT INTO Promotions (name, description, discount_type, discount_value, min_order_amount, start_date, end_date, is_active)
VALUES
('Tết 2026 - Giảm 100K',
 'Chào đón năm mới với ưu đãi giảm 100,000đ cho đơn hàng từ 1,000,000đ',
 'FIXED_AMOUNT',
 100000.00,
 1000000.00,
 '2025-12-31 00:00:00',
 '2026-01-10 23:59:59',
 1);

-- VIP promotion: 20% off for high-value orders
INSERT INTO Promotions (name, description, discount_type, discount_value, min_order_amount, start_date, end_date, is_active)
VALUES
('Khách hàng VIP - Giảm 20%',
 'Ưu đãi đặc biệt cho khách hàng VIP - Đơn hàng từ 2,000,000đ',
 'PERCENTAGE',
 20.00,
 2000000.00,
 '2025-01-01 00:00:00',
 '2025-12-31 23:59:59',
 1);

-- Weekend special: 5% off for all orders
INSERT INTO Promotions (name, description, discount_type, discount_value, min_order_amount, start_date, end_date, is_active)
VALUES
('Cuối tuần vui vẻ - Giảm 5%',
 'Giảm giá 5% cho tất cả đơn hàng vào cuối tuần',
 'PERCENTAGE',
 5.00,
 0.00,
 '2025-11-29 00:00:00',
 '2025-12-01 23:59:59',
 1);

