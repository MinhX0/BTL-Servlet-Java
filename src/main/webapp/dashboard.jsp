<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
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

        .welcome-card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .welcome-card h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }

        .welcome-card p {
            color: #666;
            font-size: 16px;
        }

        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 40px;
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
            margin-bottom: 10px;
        }

        .card p {
            color: #666;
            line-height: 1.6;
        }

        .footer {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-content">
            <h1>Application</h1>
            <div class="nav-right">
                <div class="user-info">
                    <span>Welcome, <strong><%= username %></strong>!</span>
                    <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="welcome-card">
            <h2>Welcome to Dashboard</h2>
            <p>You have successfully logged in!</p>
        </div>

        <div class="content-grid">
            <div class="card">
                <h3>Profile</h3>
                <p>Manage your profile information and account settings.</p>
            </div>

            <div class="card">
                <h3>Settings</h3>
                <p>Configure your preferences and security settings.</p>
            </div>

            <div class="card">
                <h3>Help</h3>
                <p>Get help and support for any questions you may have.</p>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2025 Java Web Application. All rights reserved.</p>
    </div>
</body>
</html>

