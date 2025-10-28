<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
    if (!user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add User</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { max-width: 600px; margin: 40px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .row { margin-bottom: 12px; }
        label { display:block; margin-bottom: 6px; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 8px; }
        .btn { background: #667eea; color: #fff; padding: 10px 16px; border: none; border-radius: 4px; cursor: pointer; }
        .alert { padding: 10px; border-radius: 4px; margin-bottom: 12px; }
        .alert.error { background: #fdecea; color: #b71c1c; }
        .alert.success { background: #e8f5e9; color: #1b5e20; }
    </style>
</head>
<body>
<div class="container">
    <h2>Create User</h2>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert error"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <div class="alert success"><%= request.getAttribute("success") %></div>
    <% } %>
    <form method="post" action="<%= request.getContextPath() %>/admin/add-user">
        <div class="row">
            <label for="name">Name</label>
            <input type="text" name="name" id="name" required />
        </div>
        <div class="row">
            <label for="username">Username</label>
            <input type="text" name="username" id="username" required />
        </div>
        <div class="row">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" required />
        </div>
        <div class="row">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" required />
        </div>
        <div class="row">
            <label for="phone">Phone</label>
            <input type="text" name="phone" id="phone" />
        </div>
        <div class="row">
            <label for="address">Address</label>
            <textarea name="address" id="address"></textarea>
        </div>
        <div class="row">
            <label for="role">Role</label>
            <select name="role" id="role" required>
                <option value="CUSTOMER">Customer</option>
                <option value="SELLER">Seller</option>
                <option value="ADMIN">Administrator</option>
            </select>
        </div>
        <button class="btn" type="submit">Create</button>
        <a class="btn" style="background:#999; text-decoration:none;" href="<%= request.getContextPath() %>/admin/dashboard.jsp">Back</a>
    </form>
</div>
</body>
</html>

