<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");

    // Check if user is seller or admin
    if (!user.isSeller() && !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Seller Dashboard - <%= user.getName() %></title>
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            color: #f5576c;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #999;
            font-size: 14px;
            text-transform: uppercase;
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
            color: #f5576c;
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: transform 0.2s;
        }

        .card-btn:hover {
            transform: scale(1.05);
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
            border-bottom: 2px solid #f5576c;
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
            color: #f5576c;
            text-align: center;
            transition: all 0.3s;
        }

        .menu-item:hover {
            background: #f5576c;
            color: white;
            border-color: #f5576c;
        }

        .footer {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            font-size: 14px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-content">
            <h1>Seller Panel</h1>
            <div class="nav-right">
                <div class="user-info">
                    <div>
                        <div><strong><%= user.getName() %></strong></div>
                        <div style="font-size: 12px;">@<%= user.getUsername() %></div>
                    </div>
                    <div class="role-badge"><%= user.getRole().getDisplayName() %></div>
                    <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Header Card -->
        <div class="header-card">
            <h2>Welcome back, <%= user.getName() %>!</h2>
            <p>Manage your products and monitor your sales</p>
        </div>

        <!-- Statistics -->
        <h3 style="margin-bottom: 20px; color: #333;">Your Shop Statistics</h3>
        <div class="statistics">
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Products Listed</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Pending Orders</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Total Sales</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">$0</div>
                <div class="stat-label">Revenue</div>
            </div>
        </div>

        <!-- Main Menu -->
        <div class="menu-section">
            <h3>Product Management</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/seller/products" class="menu-item">My Products</a>
                <a href="<%= request.getContextPath() %>/seller/add-product" class="menu-item">Add Product</a>
                <a href="<%= request.getContextPath() %>/seller/categories" class="menu-item">Categories</a>
                <a href="<%= request.getContextPath() %>/seller/inventory" class="menu-item">Inventory</a>
            </div>
        </div>

        <!-- Orders Menu -->
        <div class="menu-section">
            <h3>Sales & Orders</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/seller/orders" class="menu-item">All Orders</a>
                <a href="<%= request.getContextPath() %>/seller/pending" class="menu-item">Pending Orders</a>
                <a href="<%= request.getContextPath() %>/seller/shipped" class="menu-item">Shipped</a>
                <a href="<%= request.getContextPath() %>/seller/analytics" class="menu-item">Analytics</a>
            </div>
        </div>

        <!-- Account Menu -->
        <div class="menu-section">
            <h3>Account Settings</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/seller/profile" class="menu-item">Edit Profile</a>
                <a href="<%= request.getContextPath() %>/seller/settings" class="menu-item">Settings</a>
                <a href="<%= request.getContextPath() %>/seller/payments" class="menu-item">Payments</a>
                <a href="<%= request.getContextPath() %>/seller/support" class="menu-item">Support</a>
            </div>
        </div>

        <!-- Quick Actions -->
        <h3 style="margin-bottom: 20px; color: #333;">Quick Actions</h3>
        <div class="content-grid">
            <div class="card">
                <h3>📦 Products</h3>
                <p>Manage your product listings, prices, and descriptions.</p>
                <a href="<%= request.getContextPath() %>/seller/products" class="card-btn">Go to Products</a>
            </div>

            <div class="card">
                <h3>📋 Orders</h3>
                <p>Process and track customer orders in real-time.</p>
                <a href="<%= request.getContextPath() %>/seller/orders" class="card-btn">View Orders</a>
            </div>

            <div class="card">
                <h3>📊 Analytics</h3>
                <p>Track your sales performance and customer insights.</p>
                <a href="<%= request.getContextPath() %>/seller/analytics" class="card-btn">View Analytics</a>
            </div>

            <div class="card">
                <h3>💳 Payments</h3>
                <p>Manage payment methods and view transaction history.</p>
                <a href="<%= request.getContextPath() %>/seller/payments" class="card-btn">Manage Payments</a>
            </div>

            <div class="card">
                <h3>👤 Profile</h3>
                <p>Update your shop information and personal details.</p>
                <a href="<%= request.getContextPath() %>/seller/profile" class="card-btn">Edit Profile</a>
            </div>

            <div class="card">
                <h3>❓ Help</h3>
                <p>Get support and answers to frequently asked questions.</p>
                <a href="<%= request.getContextPath() %>/seller/help" class="card-btn">Get Help</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2025 E-Shop Seller Platform. All rights reserved.</p>
    </div>
</body>
</html>

