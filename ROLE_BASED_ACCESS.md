# Role-Based Access Control (RBAC) Implementation Guide

## Overview

The application implements a role-based access control system with three user roles:
- **CUSTOMER**: Regular users who can browse and purchase products
- **SELLER**: Users who can manage their own products and shop
- **ADMIN**: Administrative users with full system access

## Role Enum

The `Role` enum defines available roles and provides utility methods.

**Location**: `src/main/java/com/example/btl/model/Role.java`

```java
public enum Role {
    CUSTOMER("CUSTOMER", "Customer"),
    ADMIN("ADMIN", "Administrator"),
    SELLER("SELLER", "Seller");
    
    // Methods to work with roles
    public String getCode()            // Get role code
    public String getDisplayName()     // Get display name
    public static Role fromCode(String code)  // Convert string to Role
}
```

## Using Roles in the User Entity

### 1. Store Role in User

```java
@Entity
@Table(name = "users")
public class User {
    @Column(nullable = false, length = 20)
    @Enumerated(EnumType.STRING)
    private Role role = Role.CUSTOMER;  // Default role
    
    // Methods to check role
    public boolean isAdmin() {
        return role == Role.ADMIN;
    }
    
    public boolean isSeller() {
        return role == Role.SELLER;
    }
    
    public boolean isCustomer() {
        return role == Role.CUSTOMER;
    }
}
```

### 2. Create User with Specific Role

```java
// Create customer (default)
User customer = new User("john", "pass123", "John Doe", "john@example.com");

// Create seller
User seller = new User("jane", "pass123", "Jane Smith", "jane@example.com", Role.SELLER);

// Create admin
User admin = new User("admin", "pass123", "Admin User", "admin@example.com", Role.ADMIN);
```

## Getting User Role After Login

### LoginServlet - Store Role in Session

Update `LoginServlet.java`:

```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    User user = userDAO.authenticateUser(username, password);
    
    if (user != null) {
        // Create session
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());  // Store role
        session.setAttribute("name", user.getName());
        session.setMaxInactiveInterval(30 * 60); // 30 minutes
        
        // Redirect based on role
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else if (user.isSeller()) {
            response.sendRedirect(request.getContextPath() + "/seller/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
        }
    } else {
        request.setAttribute("error", "Invalid username or password");
        try {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## Accessing Role Information in JSP

### 1. Get Current User Role in JSP Page

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    com.example.btl.model.User user = (com.example.btl.model.User) session.getAttribute("user");
    com.example.btl.model.Role userRole = user.getRole();
    String username = user.getUsername();
    String name = user.getName();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - <%= name %></title>
</head>
<body>
    <h1>Welcome, <%= name %>!</h1>
    <p>Your role: <%= userRole.getDisplayName() %></p>
    
    <% if (user.isAdmin()) { %>
        <h2>Admin Features</h2>
        <a href="/BTL/admin/users">Manage Users</a>
        <a href="/BTL/admin/reports">View Reports</a>
    <% } else if (user.isSeller()) { %>
        <h2>Seller Features</h2>
        <a href="/BTL/seller/products">Manage Products</a>
        <a href="/BTL/seller/orders">View Orders</a>
    <% } else { %>
        <h2>Customer Features</h2>
        <a href="/BTL/shop">Browse Products</a>
        <a href="/BTL/cart">My Cart</a>
    <% } %>
</body>
</html>
```

### 2. Access Role from Session Directly

```jsp
<%
    com.example.btl.model.Role role = (com.example.btl.model.Role) session.getAttribute("role");
    String roleDisplay = role.getDisplayName();
%>
Current Role: <%= roleDisplay %>
```

## Creating a Role-Based Access Filter

Create a servlet filter to check user roles:

```java
package com.example.btl.filter;

import com.example.btl.model.Role;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check if user is admin
        Role role = (Role) session.getAttribute("role");
        if (role != Role.ADMIN) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        chain.doFilter(request, response);
    }
}
```

Similarly for seller filter:

```java
@WebFilter("/seller/*")
public class SellerFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        Role role = (Role) session.getAttribute("role");
        if (role != Role.SELLER && role != Role.ADMIN) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        chain.doFilter(request, response);
    }
}
```

## Example: Dashboard JSP with Role-Based Content

Create `src/main/webapp/dashboard.jsp`:

```jsp
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
    <title>Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #667eea; color: white; padding: 20px; border-radius: 5px; }
        .nav { margin: 20px 0; }
        .nav a { margin-right: 15px; padding: 10px; background: #f0f0f0; text-decoration: none; }
        .nav a:hover { background: #ddd; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome, <%= user.getName() %>!</h1>
        <p>Role: <strong><%= role.getDisplayName() %></strong></p>
        <p>Email: <%= user.getEmail() %></p>
    </div>

    <div class="nav">
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>

    <!-- ADMIN DASHBOARD -->
    <% if (user.isAdmin()) { %>
        <div class="admin-section">
            <h2>Admin Dashboard</h2>
            <p>Manage the entire system</p>
            
            <div class="nav">
                <a href="<%= request.getContextPath() %>/admin/users">Manage Users</a>
                <a href="<%= request.getContextPath() %>/admin/reports">View Reports</a>
                <a href="<%= request.getContextPath() %>/admin/settings">System Settings</a>
            </div>

            <h3>System Statistics</h3>
            <p>Total Users: [X]</p>
            <p>Total Orders: [X]</p>
            <p>Total Revenue: [X]</p>
        </div>

    <!-- SELLER DASHBOARD -->
    <% } else if (user.isSeller()) { %>
        <div class="seller-section">
            <h2>Seller Dashboard</h2>
            <p>Manage your products and sales</p>
            
            <div class="nav">
                <a href="<%= request.getContextPath() %>/seller/products">My Products</a>
                <a href="<%= request.getContextPath() %>/seller/orders">Orders</a>
                <a href="<%= request.getContextPath() %>/seller/analytics">Analytics</a>
            </div>

            <h3>Shop Statistics</h3>
            <p>Products Listed: [X]</p>
            <p>Total Sales: [X]</p>
            <p>Pending Orders: [X]</p>
        </div>

    <!-- CUSTOMER DASHBOARD -->
    <% } else { %>
        <div class="customer-section">
            <h2>Customer Dashboard</h2>
            <p>Browse and purchase products</p>
            
            <div class="nav">
                <a href="<%= request.getContextPath() %>/shop">Browse Shop</a>
                <a href="<%= request.getContextPath() %>/orders">My Orders</a>
                <a href="<%= request.getContextPath() %>/wishlist">My Wishlist</a>
            </div>

            <h3>Your Account</h3>
            <p>Phone: <%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not set" %></p>
            <p>Address: <%= user.getAddress() != null ? user.getAddress() : "Not set" %></p>
        </div>
    <% } %>

</body>
</html>
```

## Database Test Data

After running `database.sql`, test with these credentials:

| Username | Password | Role | Name |
|----------|----------|------|------|
| customer1 | pass123 | CUSTOMER | John Customer |
| seller1 | pass123 | SELLER | Jane Seller |
| admin | admin123 | ADMIN | Admin User |

## Summary of Implementation

### 1. Database Level
- Role stored as ENUM in users table
- Default role is CUSTOMER

### 2. Entity Level (User.java)
- `@Enumerated(EnumType.STRING)` annotation
- Helper methods: `isAdmin()`, `isSeller()`, `isCustomer()`

### 3. Session Level
- Store role in session: `session.setAttribute("role", user.getRole())`
- Retrieve for authorization checks

### 4. View Level (JSP)
- Check role to display appropriate content
- Use conditional rendering based on user role

### 5. Filter Level (Optional)
- Use servlet filters to enforce role-based access
- Automatically redirect unauthorized users

## Best Practices

✅ Always check user role in JSP before showing sensitive content  
✅ Use filters to protect backend servlet endpoints  
✅ Store role in session for performance  
✅ Default to most restrictive role when creating users  
✅ Log role changes for audit trail  
✅ Never trust client-side role information  
✅ Validate role on every backend operation  

## Common Patterns

### Pattern 1: Check Role in JSP
```jsp
<% if (user.isAdmin()) { %>
    <!-- Admin only content -->
<% } %>
```

### Pattern 2: Redirect Based on Role
```java
if (user.isAdmin()) {
    response.sendRedirect("/admin/dashboard");
} else if (user.isSeller()) {
    response.sendRedirect("/seller/dashboard");
} else {
    response.sendRedirect("/customer/dashboard");
}
```

### Pattern 3: Role-Based API Response
```java
if (user.isAdmin()) {
    // Return all users
} else if (user.isSeller()) {
    // Return only own products
} else {
    // Return public data only
}
```

## Future Enhancements

- [ ] Add fine-grained permissions within roles
- [ ] Implement role assignment workflow
- [ ] Add role change audit logging
- [ ] Support custom roles
- [ ] Implement role-based decorators on endpoints

