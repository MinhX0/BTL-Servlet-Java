<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
    com.example.btl.model.Role role = user.getRole();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard - <%= user.getName() %></title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
        }

        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .navbar h1 {
            font-size: 24px;
            font-weight: 600;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .role-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .logout-btn {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid white;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .header-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .header-card h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 28px;
        }

        .header-card p {
            color: #666;
            margin-bottom: 5px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .info-item {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            border-left: 3px solid #667eea;
        }

        .info-item label {
            font-weight: 600;
            color: #667eea;
            display: block;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-item span {
            color: #333;
            font-size: 16px;
        }

        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
        }

        .card h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 20px;
        }

        .card p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .card-btn {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: transform 0.2s;
        }

        .card-btn:hover {
            transform: scale(1.05);
        }

        .statistics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #999;
            font-size: 14px;
            text-transform: uppercase;
        }

        .footer {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            font-size: 14px;
            border-top: 1px solid #eee;
        }

        .menu-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .menu-section h3 {
            color: #333;
            margin-bottom: 15px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }

        .menu-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
        }

        .menu-item {
            display: block;
            padding: 12px;
            background: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            color: #667eea;
            text-align: center;
            transition: all 0.3s;
        }

        .menu-item:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-content">
            <h1>E-Shop</h1>
            <div class="nav-right">
                <div class="user-info">
                    <div>
                        <div><strong><%= user.getName() %></strong></div>
                        <div style="font-size: 12px;">@<%= user.getUsername() %></div>
                    </div>
                    <div class="role-badge"><%= role.getDisplayName() %></div>
                    <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Header Card with User Info -->
        <div class="header-card">
            <h2>Welcome back, <%= user.getName() %>!</h2>
            <p>Manage your account and browse our products</p>

            <div class="info-grid">
                <div class="info-item">
                    <label>Email</label>
                    <span><%= user.getEmail() %></span>
                </div>
                <div class="info-item">
                    <label>Phone</label>
                    <span><%= user.getPhoneNumber() != null && !user.getPhoneNumber().isEmpty() ? user.getPhoneNumber() : "Not set" %></span>
                </div>
                <div class="info-item">
                    <label>Member Since</label>
                    <span><%= user.getCreatedAt() != null ? user.getCreatedAt().substring(0, 10) : "N/A" %></span>
                </div>
                <div class="info-item">
                    <label>Account Status</label>
                    <span style="color: green;">Active</span>
                </div>
            </div>
        </div>

        <!-- Statistics -->
        <h3 style="margin-bottom: 20px; color: #333;">Your Activity</h3>
        <div class="statistics">
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Active Orders</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Completed Orders</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Wishlist Items</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">$0</div>
                <div class="stat-label">Total Spent</div>
            </div>
        </div>

        <!-- Main Menu -->
        <div class="menu-section">
            <h3>Shopping</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/shop" class="menu-item">Browse Products</a>
                <a href="<%= request.getContextPath() %>/cart" class="menu-item">My Cart</a>
                <a href="<%= request.getContextPath() %>/wishlist" class="menu-item">Wishlist</a>
                <a href="<%= request.getContextPath() %>/orders" class="menu-item">My Orders</a>
            </div>
        </div>

        <!-- Account Menu -->
        <div class="menu-section">
            <h3>Account</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/profile" class="menu-item">Edit Profile</a>
                <a href="<%= request.getContextPath() %>/addresses" class="menu-item">Addresses</a>
                <a href="<%= request.getContextPath() %>/settings" class="menu-item">Settings</a>
                <a href="<%= request.getContextPath() %>/password" class="menu-item">Change Password</a>
            </div>
        </div>

        <!-- Features -->
        <h3 style="margin-bottom: 20px; color: #333;">Quick Actions</h3>
        <div class="content-grid">
            <div class="card">
                <h3>📦 Browse Shop</h3>
                <p>Explore our wide selection of products and find what you're looking for.</p>
                <a href="<%= request.getContextPath() %>/shop" class="card-btn">Browse Now</a>
            </div>

            <div class="card">
                <h3>🛒 Shopping Cart</h3>
                <p>Review and manage items in your shopping cart before checkout.</p>
                <a href="<%= request.getContextPath() %>/cart" class="card-btn">View Cart</a>
            </div>

            <div class="card">
                <h3>❤️ Wishlist</h3>
                <p>Save your favorite items for later. Build your personal wishlist.</p>
                <a href="<%= request.getContextPath() %>/wishlist" class="card-btn">View Wishlist</a>
            </div>

            <div class="card">
                <h3>📋 Orders</h3>
                <p>Track your orders and view order history.</p>
                <a href="<%= request.getContextPath() %>/orders" class="card-btn">View Orders</a>
            </div>

            <div class="card">
                <h3>👤 Profile</h3>
                <p>Update your personal information and account settings.</p>
                <a href="<%= request.getContextPath() %>/profile" class="card-btn">Edit Profile</a>
            </div>

            <div class="card">
                <h3>❓ Help & Support</h3>
                <p>Get help with your account or orders. Contact our support team.</p>
                <a href="<%= request.getContextPath() %>/help" class="card-btn">Get Help</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2025 E-Shop. All rights reserved. |
            <a href="#" style="color: #667eea; text-decoration: none;">Terms of Service</a> |
            <a href="#" style="color: #667eea; text-decoration: none;">Privacy Policy</a>
        </p>
    </div>
</body>
</html>

