<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");

    // Check if user is admin
    if (!user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - <%= user.getName() %></title>
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

        .footer {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            font-size: 14px;
            border-top: 1px solid #eee;
        }

        .alert {
            background: #fff3cd;
            border: 1px solid #ffc107;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-content">
            <h1>🔐 Admin Dashboard</h1>
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
            <h2>System Administration Dashboard</h2>
            <p>Manage users, sellers, and system settings</p>
        </div>

        <!-- Alert -->
        <div class="alert">
            ⚠️ You have full administrative access to this system. Handle with care!
        </div>

        <!-- Statistics -->
        <h3 style="margin-bottom: 20px; color: #333;">System Statistics</h3>
        <div class="statistics">
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Active Sellers</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">0</div>
                <div class="stat-label">Total Orders</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">$0</div>
                <div class="stat-label">Platform Revenue</div>
            </div>
        </div>

        <!-- User Management -->
        <div class="menu-section">
            <h3>👥 User Management</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/admin/users" class="menu-item">All Users</a>
                <a href="<%= request.getContextPath() %>/admin/customers" class="menu-item">Customers</a>
                <a href="<%= request.getContextPath() %>/admin/sellers" class="menu-item">Sellers</a>
                <a href="<%= request.getContextPath() %>/admin/add-user" class="menu-item">Add User</a>
            </div>
        </div>

        <!-- Content Management -->
        <div class="menu-section">
            <h3>📦 Content Management</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/admin/products" class="menu-item">Products</a>
                <a href="<%= request.getContextPath() %>/admin/categories" class="menu-item">Categories</a>
                <a href="<%= request.getContextPath() %>/admin/orders" class="menu-item">Orders</a>
                <a href="<%= request.getContextPath() %>/admin/reports" class="menu-item">Reports</a>
            </div>
        </div>

        <!-- System Settings -->
        <div class="menu-section">
            <h3>⚙️ System Settings</h3>
            <div class="menu-list">
                <a href="<%= request.getContextPath() %>/admin/settings" class="menu-item">Settings</a>
                <a href="<%= request.getContextPath() %>/admin/logs" class="menu-item">Activity Logs</a>
                <a href="<%= request.getContextPath() %>/admin/backup" class="menu-item">Backup</a>
                <a href="<%= request.getContextPath() %>/admin/security" class="menu-item">Security</a>
            </div>
        </div>

        <!-- Quick Actions -->
        <h3 style="margin-bottom: 20px; color: #333;">Quick Actions</h3>
        <div class="content-grid">
            <div class="card">
                <h3>👥 Users</h3>
                <p>Manage all users, customers, and sellers. Review accounts and handle support requests.</p>
                <a href="<%= request.getContextPath() %>/admin/users" class="card-btn">Manage Users</a>
            </div>

            <div class="card">
                <h3>📦 Products</h3>
                <p>Oversee all product listings and manage product categories.</p>
                <a href="<%= request.getContextPath() %>/admin/products" class="card-btn">Manage Products</a>
            </div>

            <div class="card">
                <h3>📋 Orders</h3>
                <p>Track all orders in the system and resolve customer issues.</p>
                <a href="<%= request.getContextPath() %>/admin/orders" class="card-btn">View Orders</a>
            </div>

            <div class="card">
                <h3>📊 Reports</h3>
                <p>View system analytics and generate comprehensive reports.</p>
                <a href="<%= request.getContextPath() %>/admin/reports" class="card-btn">View Reports</a>
            </div>

            <div class="card">
                <h3>🔐 Security</h3>
                <p>Manage system security settings and user permissions.</p>
                <a href="<%= request.getContextPath() %>/admin/security" class="card-btn">Security Settings</a>
            </div>

            <div class="card">
                <h3>⚙️ System</h3>
                <p>Configure system settings and manage backups.</p>
                <a href="<%= request.getContextPath() %>/admin/settings" class="card-btn">System Settings</a>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2025 E-Shop Admin Panel. All rights reserved. |
            <a href="<%= request.getContextPath() %>/admin/settings" style="color: #667eea; text-decoration: none;">Settings</a> |
            <a href="<%= request.getContextPath() %>/admin/help" style="color: #667eea; text-decoration: none;">Help</a>
        </p>
    </div>
</body>
</html>

