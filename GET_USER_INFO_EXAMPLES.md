# Getting User Information After Login - Code Examples

## Overview

After a user successfully logs in, all their information is stored in the session. This guide shows how to access user data in different scenarios.

---

## 1. In JSP Pages

### Get User Object from Session

```jsp
<%
    // Get user from session (cast needed)
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
    
    // Check if user is logged in
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Now you can access all user properties
    int userId = user.getId();
    String username = user.getUsername();
    String name = user.getName();
    String email = user.getEmail();
    String phone = user.getPhoneNumber();
    String address = user.getAddress();
    com.example.btl.model.Role role = user.getRole();
%>
```

### Display User Info

```jsp
<div class="user-profile">
    <h1>Welcome, <%= user.getName() %>!</h1>
    <p>Username: <%= user.getUsername() %></p>
    <p>Email: <%= user.getEmail() %></p>
    <p>Phone: <%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not set" %></p>
    <p>Address: <%= user.getAddress() != null ? user.getAddress() : "Not set" %></p>
    <p>Role: <%= user.getRole().getDisplayName() %></p>
    <p>Member Since: <%= user.getCreatedAt() %></p>
</div>
```

### Check User Role

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
    
    if (user.isAdmin()) {
        out.println("You are an Administrator");
    } else if (user.isSeller()) {
        out.println("You are a Seller");
    } else if (user.isCustomer()) {
        out.println("You are a Customer");
    }
%>
```

### Show Role-Specific Content

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>

<!-- Customer Only -->
<% if (user.isCustomer()) { %>
    <div class="customer-menu">
        <a href="/shop">Browse Products</a>
        <a href="/cart">Shopping Cart</a>
        <a href="/orders">My Orders</a>
    </div>
<% } %>

<!-- Seller Only -->
<% if (user.isSeller()) { %>
    <div class="seller-menu">
        <a href="/seller/products">My Products</a>
        <a href="/seller/orders">Order Management</a>
        <a href="/seller/analytics">Analytics</a>
    </div>
<% } %>

<!-- Admin Only -->
<% if (user.isAdmin()) { %>
    <div class="admin-menu">
        <a href="/admin/users">Manage Users</a>
        <a href="/admin/products">Manage Products</a>
        <a href="/admin/reports">System Reports</a>
    </div>
<% } %>
```

---

## 2. In Servlets

### Get User in doGet/doPost

```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    
    // Check if session exists and user is logged in
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get user from session
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
    
    // Use user data
    String userName = user.getName();
    int userId = user.getId();
    com.example.btl.model.Role role = user.getRole();
    
    // Forward to JSP with user data
    request.setAttribute("user", user);
    request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
}
```

### Example Servlet with Role Check

```java
@WebServlet("/seller/products")
public class ProductManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        com.example.btl.model.User user = 
            (com.example.btl.model.User) session.getAttribute("user");
        
        // Only sellers and admins can access this page
        if (!user.isSeller() && !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Continue with seller logic
        String sellerName = user.getName();
        request.setAttribute("seller", user);
        request.getRequestDispatcher("/seller/products.jsp").forward(request, response);
    }
}
```

---

## 3. All Session Attributes

### What's Stored in Session After Login

```java
// From LoginServlet.java
HttpSession session = request.getSession(true);
session.setAttribute("user", user);              // Full User object
session.setAttribute("userId", user.getId());    // User ID (int)
session.setAttribute("username", user.getUsername());  // Username (String)
session.setAttribute("role", user.getRole());    // Role enum
session.setAttribute("name", user.getName());    // Full name (String)
```

### Access Each Attribute

```jsp
<%
    // Get individual attributes
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    com.example.btl.model.Role role = 
        (com.example.btl.model.Role) session.getAttribute("role");
    String name = (String) session.getAttribute("name");
    
    // Or get the full user object
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
    
    // Both approaches work - choose what's convenient
%>
```

---

## 4. Complete User Object Access

### All User Getter Methods

```java
// Get user object
com.example.btl.model.User user = 
    (com.example.btl.model.User) session.getAttribute("user");

// Access all properties
int id = user.getId();
String username = user.getUsername();
String password = user.getPassword();  // Don't display this!
String name = user.getName();
String email = user.getEmail();
String phoneNumber = user.getPhoneNumber();
String address = user.getAddress();
com.example.btl.model.Role role = user.getRole();
String createdAt = user.getCreatedAt();
LocalDateTime updatedAt = user.getUpdatedAt();

// Role helper methods
boolean isAdmin = user.isAdmin();
boolean isSeller = user.isSeller();
boolean isCustomer = user.isCustomer();

// Role utilities
String roleCode = role.getCode();           // "ADMIN", "SELLER", "CUSTOMER"
String roleDisplay = role.getDisplayName(); // "Administrator", "Seller", "Customer"
```

---

## 5. Practical Examples

### Example 1: Display User Greeting

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>

<h1>
    Hello, <%= user.getName() %>! 
    <span style="color: #667eea;">(Role: <%= user.getRole().getDisplayName() %>)</span>
</h1>
```

### Example 2: User Info Card

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>

<div class="user-card">
    <img src="/avatar.jpg" alt="<%= user.getName() %>">
    <h3><%= user.getName() %></h3>
    <p><strong>Email:</strong> <%= user.getEmail() %></p>
    <p><strong>Phone:</strong> <%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not provided" %></p>
    <p><strong>Address:</strong> <%= user.getAddress() != null ? user.getAddress() : "Not provided" %></p>
    <p><strong>Role:</strong> <span class="role-badge"><%= user.getRole().getDisplayName() %></span></p>
    <p><strong>Member Since:</strong> <%= user.getCreatedAt() %></p>
</div>
```

### Example 3: Conditional Menu

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>

<nav class="user-menu">
    <span>Hi, <%= user.getName() %>!</span>
    
    <% if (user.isCustomer()) { %>
        <a href="/shop">Shop</a>
        <a href="/cart">Cart</a>
        <a href="/orders">Orders</a>
    <% } else if (user.isSeller()) { %>
        <a href="/seller/dashboard">Dashboard</a>
        <a href="/seller/products">Products</a>
        <a href="/seller/orders">Orders</a>
    <% } else if (user.isAdmin()) { %>
        <a href="/admin/dashboard">Admin Panel</a>
        <a href="/admin/users">Users</a>
        <a href="/admin/settings">Settings</a>
    <% } %>
    
    <a href="/logout">Logout</a>
</nav>
```

### Example 4: Display Role-Specific Info

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>

<% if (user.isAdmin()) { %>
    <h2>System Administration</h2>
    <p>Admin ID: <%= user.getId() %></p>
    <p>Email: <%= user.getEmail() %></p>
    <p>Phone: <%= user.getPhoneNumber() %></p>
%>

<% } else if (user.isSeller()) { %>
    <h2>My Shop</h2>
    <p>Shop Owner: <%= user.getName() %></p>
    <p>Contact Email: <%= user.getEmail() %></p>
    <p>Business Phone: <%= user.getPhoneNumber() %></p>
%>

<% } else { %>
    <h2>My Account</h2>
    <p>Name: <%= user.getName() %></p>
    <p>Email: <%= user.getEmail() %></p>
    <p>Shipping Address: <%= user.getAddress() %></p>
<% } %>
```

### Example 5: Servlet Processing

```java
@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get current user
        com.example.btl.model.User user = 
            (com.example.btl.model.User) session.getAttribute("user");
        
        // Get form parameters
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Update user
        user.setPhoneNumber(phone);
        user.setAddress(address);
        
        // Save to database (using DAO)
        UserDAO userDAO = new UserDAO();
        userDAO.updateUser(user);
        
        // Update session
        session.setAttribute("user", user);
        
        // Show success message
        request.setAttribute("message", "Profile updated successfully");
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
```

---

## 6. Common Patterns

### Pattern 1: Require Login

```jsp
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>
```

### Pattern 2: Require Admin

```jsp
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
    
    if (!user.isAdmin()) {
        response.sendError(403, "Access Denied");
        return;
    }
%>
```

### Pattern 3: Require Seller or Admin

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
    
    if (!user.isSeller() && !user.isAdmin()) {
        response.sendError(403, "Only sellers can access this page");
        return;
    }
%>
```

### Pattern 4: Show Different Content

```jsp
<%
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>

<% switch(user.getRole().getCode()) {
    case "ADMIN": %>
        <!-- Admin content -->
    <% break;
    case "SELLER": %>
        <!-- Seller content -->
    <% break;
    case "CUSTOMER":
    default: %>
        <!-- Customer content -->
    <% break;
} %>
```

---

## 7. Important Notes

### ✅ DO:
- Always check if user exists before using session attributes
- Use the User object for accessing all data
- Check user role before showing sensitive content
- Cast session attributes properly
- Use helper methods like `user.isAdmin()`

### ❌ DON'T:
- Display the password field anywhere
- Trust client-side role information
- Skip authentication checks
- Store sensitive data in plain text
- Hardcode role checks

---

## 8. Complete Page Example

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    com.example.btl.model.User user = 
        (com.example.btl.model.User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Profile - <%= user.getName() %></title>
</head>
<body>
    <header>
        <h1>My Profile</h1>
        <p>Logged in as: <%= user.getName() %> 
           (<%= user.getRole().getDisplayName() %>)</p>
        <a href="/logout">Logout</a>
    </header>

    <main>
        <section>
            <h2>Account Information</h2>
            <table>
                <tr>
                    <td>Username:</td>
                    <td><%= user.getUsername() %></td>
                </tr>
                <tr>
                    <td>Full Name:</td>
                    <td><%= user.getName() %></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><%= user.getEmail() %></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A" %></td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td><%= user.getAddress() != null ? user.getAddress() : "N/A" %></td>
                </tr>
                <tr>
                    <td>Role:</td>
                    <td>
                        <strong><%= user.getRole().getDisplayName() %></strong>
                        <% if (user.isAdmin()) { %>
                            <span style="color: red;">(Administrator)</span>
                        <% } else if (user.isSeller()) { %>
                            <span style="color: blue;">(Seller)</span>
                        <% } else { %>
                            <span style="color: green;">(Customer)</span>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <td>Member Since:</td>
                    <td><%= user.getCreatedAt() %></td>
                </tr>
            </table>
        </section>

        <section>
            <h2>Actions</h2>
            <a href="/edit-profile">Edit Profile</a>
            <a href="/change-password">Change Password</a>
            <a href="/logout">Logout</a>
        </section>
    </main>
</body>
</html>
```

---

That's it! You now have all the tools and examples to access and display user information throughout your application after login.

