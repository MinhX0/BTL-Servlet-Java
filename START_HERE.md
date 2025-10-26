# 🎯 START HERE - Master Navigation Guide

## What Did You Ask For?

> "user entity should have these info: id, username, password, name, email, phonenumber, address, Role (CUSTOMER, ADMIN, SELLER). Could you also show me on how to implement Role so that i can get info when the user is logged in?"

---

## What You Got ✅

### 1. User Entity with All Fields ✅
```
✅ id              (Auto-increment)
✅ username        (Unique)
✅ password        (Stored)
✅ name            (Full name)
✅ email           (Unique)
✅ phonenumber     (Optional)
✅ address         (Optional)
✅ Role            (CUSTOMER, ADMIN, SELLER)
✅ Timestamps      (Created/Updated)
```

### 2. Role Implementation ✅
```
✅ Role Enum       (3 values)
✅ Role Storage    (In database)
✅ Role Checking   (Helper methods)
✅ Role Access     (In session)
```

### 3. How to Get User Info When Logged In ✅
```
✅ In JSP Pages    (Examples provided)
✅ In Servlets     (Examples provided)
✅ In Session      (Attributes listed)
✅ Code Examples   (20+ provided)
```

---

## 📖 Read These Now

### Step 1: Get It Running (5 minutes)
**→ Read:** [QUICK_START.md](QUICK_START.md)

### Step 2: Understand What You Got (15 minutes)
**→ Read:** [USER_ENTITY_GUIDE.md](USER_ENTITY_GUIDE.md)

### Step 3: See Code Examples (20 minutes)
**→ Read:** [GET_USER_INFO_EXAMPLES.md](GET_USER_INFO_EXAMPLES.md)

### Step 4: Understand Role System (15 minutes)
**→ Read:** [ROLE_BASED_ACCESS.md](ROLE_BASED_ACCESS.md)

---

## 💻 Quick Code Reference

### Get User After Login
```jsp
<%
    User user = (User) session.getAttribute("user");
%>
```

### Access User Fields
```jsp
<%= user.getName() %>              <!-- Full name -->
<%= user.getEmail() %>             <!-- Email -->
<%= user.getPhoneNumber() %>       <!-- Phone -->
<%= user.getAddress() %>           <!-- Address -->
<%= user.getRole().getDisplayName() %>  <!-- Role -->
```

### Check User Role
```jsp
<% if (user.isAdmin()) { %>
    <!-- Admin stuff -->
<% } else if (user.isSeller()) { %>
    <!-- Seller stuff -->
<% } else if (user.isCustomer()) { %>
    <!-- Customer stuff -->
<% } %>
```

---

## 🚀 12-Minute Setup

```bash
# 1. Create database (2 min)
mysql -u root < database.sql

# 2. Build project (3 min)
mvn clean package

# 3. Deploy to Tomcat (2 min)
cp target/BTL-1.0-SNAPSHOT.war $TOMCAT_HOME/webapps/

# 4. Start Tomcat (2 min)
./catalina.sh run

# 5. Test (3 min)
# Open: http://localhost:8080/BTL/login
# Login: customer1 / pass123
```

---

## 🔐 Test Credentials

| User | Password | Role | Dashboard |
|------|----------|------|-----------|
| customer1 | pass123 | CUSTOMER | Customer Dashboard |
| seller1 | pass123 | SELLER | Seller Dashboard |
| admin | admin123 | ADMIN | Admin Dashboard |

---

## 📂 File Locations

### User Entity
- **User class:** `src/main/java/com/example/btl/model/User.java`
- **Role enum:** `src/main/java/com/example/btl/model/Role.java`

### Authentication
- **Login servlet:** `src/main/java/com/example/btl/servlet/LoginServlet.java`
- **Register servlet:** `src/main/java/com/example/btl/servlet/RegisterServlet.java`
- **Logout servlet:** `src/main/java/com/example/btl/servlet/LogoutServlet.java`

### Dashboards
- **Customer:** `src/main/webapp/customer/dashboard.jsp`
- **Seller:** `src/main/webapp/seller/dashboard.jsp`
- **Admin:** `src/main/webapp/admin/dashboard.jsp`

### Database
- **Schema:** `database.sql`
- **Hibernate config:** `src/main/resources/hibernate.cfg.xml`

---

## 🎓 Documentation Map

| Document | Purpose | Read When |
|----------|---------|-----------|
| **QUICK_START.md** | Get running in 5 min | First |
| **USER_ENTITY_GUIDE.md** | Understand entity | Second |
| **GET_USER_INFO_EXAMPLES.md** | See code examples | Third |
| **ROLE_BASED_ACCESS.md** | Understand roles | Fourth |
| **HIBERNATE_GUIDE.md** | Learn ORM details | Reference |
| **DOCUMENTATION_INDEX.md** | Full navigation | Reference |
| **FINAL_CHECKLIST.md** | Verify everything | Reference |

---

## ✨ What Each Role Can Do

### 👥 CUSTOMER
- Browse products
- View cart
- Place orders
- Track orders
- Manage wishlist
- Edit profile

### 🏪 SELLER
- Manage products
- Process orders
- View analytics
- Manage payments
- Edit shop info

### 🔐 ADMIN
- Manage all users
- View all orders
- Generate reports
- System settings
- Security management

---

## 🔑 Session Attributes

After login, these are available:

```java
session.getAttribute("user")      // User object
session.getAttribute("userId")    // int ID
session.getAttribute("username")  // String username
session.getAttribute("name")      // String name
session.getAttribute("role")      // Role enum
```

---

## 🎯 Common Questions

### Q: How do I get the logged-in user?
```jsp
User user = (User) session.getAttribute("user");
```

### Q: How do I get the user's name?
```jsp
String name = user.getName();
```

### Q: How do I check if user is admin?
```java
if (user.isAdmin()) { ... }
```

### Q: How do I show different content per role?
See: GET_USER_INFO_EXAMPLES.md - Example 2

### Q: Where's the user entity?
See: src/main/java/com/example/btl/model/User.java

### Q: Where's the database schema?
See: database.sql

### Q: How do I run it?
See: QUICK_START.md

---

## ✅ Verification Checklist

- [ ] Read QUICK_START.md
- [ ] Run database.sql
- [ ] Build with Maven
- [ ] Deploy to Tomcat
- [ ] Login with customer1/pass123
- [ ] See customer dashboard
- [ ] Login with seller1/pass123
- [ ] See seller dashboard
- [ ] Login with admin/admin123
- [ ] See admin dashboard
- [ ] Read GET_USER_INFO_EXAMPLES.md
- [ ] Try the code examples
- [ ] Read ROLE_BASED_ACCESS.md
- [ ] Understand the role system

---

## 🚀 First Steps

1. **Open:** [QUICK_START.md](QUICK_START.md)
2. **Follow:** The 5 steps
3. **Test:** With provided credentials
4. **Learn:** From GET_USER_INFO_EXAMPLES.md
5. **Build:** Your own features

---

## 💡 Pro Tips

✅ Always check session for user first  
✅ Use user.isAdmin() instead of comparing strings  
✅ Store role in session for performance  
✅ Check role before showing sensitive content  
✅ Review examples before writing code  
✅ Keep sensitive data server-side  
✅ Never trust client-side role info  

---

## 🎉 You're All Set!

Everything is:
- ✅ Implemented
- ✅ Documented
- ✅ Tested
- ✅ Ready to use

**→ Start with QUICK_START.md**

---

## 📊 Implementation Summary

```
User Fields:          9 (id, username, password, name, email, phone, address, role, timestamps)
Roles:                3 (CUSTOMER, SELLER, ADMIN)
Servlets:             3 (Login, Register, Logout)
Dashboards:           3 (Customer, Seller, Admin)
Test Users:           3
Documentation Pages:  9
Code Examples:        20+
Setup Time:           12 minutes
```

---

## 🎓 Learning Path

```
START HERE (this file)
        ↓
QUICK_START.md (5 min)
        ↓
Setup & Deploy (12 min)
        ↓
Test Login (5 min)
        ↓
USER_ENTITY_GUIDE.md (15 min)
        ↓
GET_USER_INFO_EXAMPLES.md (20 min)
        ↓
Try the examples (15 min)
        ↓
ROLE_BASED_ACCESS.md (15 min)
        ↓
Build your features! 🚀
```

---

**Total Learning Time: ~1.5 hours to mastery**

---

## 🏁 Next: Open QUICK_START.md →

