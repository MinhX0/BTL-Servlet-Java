# Hibernate & JPA Implementation Guide

## Overview

This project has been updated to use **Hibernate ORM** with **Jakarta Persistence API (JPA)** instead of raw JDBC. This provides several benefits:

- **Automatic SQL generation**: Hibernate generates SQL queries automatically
- **Object-Relational Mapping (ORM)**: Work with Java objects instead of raw SQL
- **Transaction management**: Built-in support for ACID transactions
- **Caching**: First-level and second-level caching
- **Lazy loading**: Efficient data retrieval
- **Type safety**: Compile-time checking with query objects

## Project Structure

```
src/main/java/com/example/btl/
├── model/
│   └── User.java                  # JPA Entity with annotations
├── dao/
│   └── UserDAO.java               # Hibernatef operations
├── servlet/
│   ├── LoginServlet.java          # Login handler
│   ├── LogoutServlet.java         # Logout handler
│   └── RegisterServlet.java       # Registration handler
└── util/
    ├── DatabaseConnection.java    # Legacy JDBC connection (optional)
    └── HibernateUtil.java         # Hibernate SessionFactory manager

src/main/resources/
└── hibernate.cfg.xml              # Hibernate configuration

src/main/webapp/
├── login.jsp
├── register.jsp
└── dashboard.jsp
```

## Key Components

### 1. User Entity (JPA)

**File**: `src/main/java/com/example/btl/model/User.java`

```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;
    
    // Getters and setters...
}
```

**Annotations Explained**:
- `@Entity`: Marks this class as a JPA entity (database table)
- `@Table(name = "users")`: Maps to the "users" table in the database
- `@Id`: Marks the primary key field
- `@GeneratedValue(strategy = GenerationType.IDENTITY)`: Auto-increment ID
- `@Column`: Defines column properties and constraints

### 2. HibernateUtil Configuration

**File**: `src/main/java/com/example/btl/util/HibernateUtil.java`

This is a singleton utility class that manages the Hibernate SessionFactory:

```java
public class HibernateUtil {
    private static SessionFactory sessionFactory;

    static {
        sessionFactory = new Configuration()
                .configure("hibernate.cfg.xml")
                .addAnnotatedClass(User.class)
                .buildSessionFactory();
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static Session getSession() throws HibernateException {
        return sessionFactory.openSession();
    }

    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
```

### 3. Hibernate Configuration File

**File**: `src/main/resources/hibernate.cfg.xml`

```xml
<hibernate-configuration>
    <session-factory>
        <!-- Database Connection -->
        <property name="hibernate.connection.driver_class">com.mysql.cj.jdbc.Driver</property>
        <property name="hibernate.connection.url">jdbc:mysql://localhost:3306/btl_java_web</property>
        <property name="hibernate.connection.username">root</property>
        <property name="hibernate.connection.password"></property>
        <property name="hibernate.dialect">org.hibernate.dialect.MySQL8Dialect</property>

        <!-- Show SQL for debugging -->
        <property name="hibernate.show_sql">true</property>
        <property name="hibernate.format_sql">true</property>

        <!-- Entity mapping -->
        <mapping class="com.example.btl.model.User"/>
    </session-factory>
</hibernate-configuration>
```

### 4. UserDAO with Hibernate

**File**: `src/main/java/com/example/btl/dao/UserDAO.java`

The DAO now uses Hibernate instead of raw JDBC:

#### Authentication
```java
public User authenticateUser(String username, String password) {
    Session session = null;
    try {
        session = HibernateUtil.getSession();
        String hql = "FROM User WHERE username = :username AND password = :password";
        Query<User> query = session.createQuery(hql, User.class);
        query.setParameter("username", username);
        query.setParameter("password", password);
        
        return query.uniqueResult();
    } finally {
        if (session != null) session.close();
    }
}
```

#### Registration
```java
public boolean registerUser(User user) {
    Session session = null;
    Transaction transaction = null;
    try {
        session = HibernateUtil.getSession();
        transaction = session.beginTransaction();
        session.persist(user);  // Save object
        transaction.commit();
        return true;
    } catch (HibernateException e) {
        if (transaction != null) transaction.rollback();
        return false;
    } finally {
        if (session != null) session.close();
    }
}
```

#### Check if Username Exists
```java
public boolean usernameExists(String username) {
    Session session = null;
    try {
        session = HibernateUtil.getSession();
        String hql = "SELECT COUNT(*) FROM User WHERE username = :username";
        Query<Long> query = session.createQuery(hql, Long.class);
        query.setParameter("username", username);
        
        Long count = query.uniqueResult();
        return count != null && count > 0;
    } finally {
        if (session != null) session.close();
    }
}
```

#### Get User by ID
```java
public User getUserById(int userId) {
    Session session = null;
    try {
        session = HibernateUtil.getSession();
        return session.get(User.class, userId);
    } finally {
        if (session != null) session.close();
    }
}
```

## Servlets

### LoginServlet

Handles user login with session management:

```java
@WebServlet(value = "/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.authenticateUser(username, password);
        
        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid credentials");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
```

### RegisterServlet

Handles new user registration with validation:

```java
@WebServlet(value = "/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullname");

        // Validate input
        if (userDAO.usernameExists(username)) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create and save user
        User user = new User(username, email, password, fullName);
        if (userDAO.registerUser(user)) {
            request.setAttribute("success", "Registration successful! Please login.");
        }
    }
}
```

### LogoutServlet

Terminates user session:

```java
@WebServlet(value = "/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
```

## Database Schema

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## Building and Running

### 1. Setup Database

```bash
mysql -u root < database.sql
```

### 2. Build Project

```bash
mvn clean package
```

### 3. Deploy to Tomcat

Copy `target/BTL-1.0-SNAPSHOT.war` to Tomcat's `webapps` directory

### 4. Access Application

- **Login**: `http://localhost:8080/BTL/login`
- **Register**: `http://localhost:8080/BTL/register`
- **Dashboard**: `http://localhost:8080/BTL/dashboard.jsp` (requires login)

## Test Credentials

After running `database.sql`, use:
- **Username**: `testuser`
- **Password**: `test123`

## Benefits of Hibernate Implementation

| Feature | Raw JDBC | Hibernate |
|---------|----------|-----------|
| SQL Writing | Manual | Automatic |
| Type Safety | Low | High |
| Object Mapping | Manual | Automatic |
| Transaction Mgmt | Manual | Built-in |
| Query Flexibility | Good | Excellent (HQL/Criteria) |
| Code Maintainability | Low | High |
| Caching | Manual | Built-in |

## HQL (Hibernate Query Language)

Examples of HQL queries used in this project:

```java
// Select all users
"FROM User"

// Select with WHERE clause
"FROM User WHERE username = :username AND password = :password"

// Count records
"SELECT COUNT(*) FROM User WHERE username = :username"

// Update records
"UPDATE User SET fullName = :name WHERE id = :id"

// Delete records
"DELETE FROM User WHERE id = :id"
```

## Dependencies Added

```xml
<!-- Hibernate ORM -->
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>6.4.0.Final</version>
</dependency>

<!-- Jakarta Persistence API -->
<dependency>
    <groupId>jakarta.persistence</groupId>
    <artifactId>jakarta.persistence-api</artifactId>
    <version>3.1.0</version>
</dependency>
```

## Common Hibernate Operations

### Save (Insert)
```java
User user = new User("john", "john@example.com", "pass123", "John Doe");
session.persist(user);
```

### Update (Merge)
```java
user.setEmail("newemail@example.com");
session.merge(user);
```

### Read (Get)
```java
User user = session.get(User.class, 1);
```

### Delete (Remove)
```java
session.remove(user);
```

## Transaction Management

All database operations are wrapped in transactions:

```java
Transaction transaction = null;
try {
    transaction = session.beginTransaction();
    // Do operations
    transaction.commit();
} catch (Exception e) {
    if (transaction != null) transaction.rollback();
} finally {
    session.close();
}
```

## Next Steps

To enhance the application further, consider:

1. **Password Hashing**: Implement BCrypt for password security
2. **Validation**: Add JSR-380 annotations for input validation
3. **Logging**: Add SLF4J for better logging
4. **Connection Pooling**: Use HikariCP for better performance
5. **Spring Integration**: Migrate to Spring Boot for enterprise features

## Troubleshooting

### SessionFactory Creation Failed
- Check hibernate.cfg.xml is in `src/main/resources/`
- Verify MySQL driver is in classpath
- Check database connection credentials

### HibernateException: Could not parse mapping document
- Ensure @Entity annotations are correct
- Check entity class is added to `hibernate.cfg.xml` mapping

### No Session Bound
- Always close Session in finally block
- Use try-with-resources if needed

## References

- [Hibernate Official Documentation](https://hibernate.org/orm/documentation/)
- [Jakarta Persistence API](https://jakarta.ee/specifications/persistence/)
- [HQL Guide](https://docs.jboss.org/hibernate/orm/6.0/userguide/html_single/Hibernate_User_Guide.html#hql)

