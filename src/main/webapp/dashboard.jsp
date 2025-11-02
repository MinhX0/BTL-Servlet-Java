<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp#login");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Bảng điều khiển</title>
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
            <h1>Trang quản trị</h1>
            <div class="nav-right">
                <div class="user-info">
                    <span>Xin chào, <strong><%= username %></strong>!</span>
                    <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="welcome-card">
            <h2>Chào mừng đến Bảng điều khiển</h2>
            <p>Bạn đã đăng nhập thành công!</p>
        </div>

        <div class="content-grid">
            <div class="card">
                <h3>Hồ sơ</h3>
                <p>Quản lý thông tin hồ sơ và cài đặt tài khoản của bạn.</p>
            </div>

            <div class="card">
                <h3>Cài đặt</h3>
                <p>Thiết lập các tùy chọn và cài đặt bảo mật.</p>
            </div>

            <div class="card">
                <h3>Trợ giúp</h3>
                <p>Nhận trợ giúp và hỗ trợ cho các câu hỏi của bạn.</p>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2025 Ứng dụng Java Web. Bảo lưu mọi quyền.</p>
    </div>
</body>
</html>
