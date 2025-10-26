# Java Web Application - User Login & Authentication with Hibernate & JPA

## Project Overview

A modern Java web application implementing user login, registration, and authentication using:

- **Jakarta EE 10** - Web framework (Servlet API 6.0)
- **Hibernate 6.4** - ORM framework
- **JPA (Jakarta Persistence API)** - Entity management
- **MySQL 8** - Database
- **Maven** - Build tool

This project demonstrates enterprise-level patterns including Object-Relational Mapping, session management, and transaction handling.

## Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Web Framework | Jakarta Servlet | 6.0.0 |
| ORM Framework | Hibernate | 6.4.0 |
| Persistence API | Jakarta Persistence | 3.1.0 |
| Database | MySQL | 5.7+ |
| Driver | MySQL Connector/J | 8.0.33 |
| Build Tool | Maven | 3.6+ |
| Java Version | Java | 24+ |

## Prerequisites

- Java 24 or later
- Apache Maven 3.6+
- MySQL 5.7 or later
- Jakarta EE 10 compatible application server (Apache Tomcat 10+)

## Project Structure

```
D:\BTL_Java_Web\BTL/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/btl/
│   │   │       ├── model/
│   │   │       │   └── User.java                 # JPA Entity
│   │   │       ├── dao/
│   │   │       │   └── UserDAO.java              # Hibernate DAO
│   │   │       ├── servlet/
│   │   │       │   ├── LoginServlet.java
│   │   │       │   ├── LogoutServlet.java
│   │   │       │   ├── RegisterServlet.java
│   │   │       │   └── HelloServlet.java
│   │   │       └── util/
│   │   │           ├── DatabaseConnection.java   # Legacy JDBC
│   │   │           └── HibernateUtil.java        # SessionFactory Manager
│   │   ├── resources/
│   │   │   └── hibernate.cfg.xml                 # Hibernate Configuration
│   │   └── webapp/
│   │       ├── login.jsp
│   │       ├── register.jsp
│   │       ├── dashboard.jsp
│   │       ├── index.jsp
│   │       └── WEB-INF/
│   │           └── web.xml
│   └── test/
│       └── java/
├── pom.xml                                        # Maven Configuration
├── database.sql                                   # Database Schema & Data
├── README.md                                      # This file
└── HIBERNATE_GUIDE.md                             # Detailed Hibernate Guide
```

## Database Setup

### 1. Create Database

```sql
CREATE DATABASE IF NOT EXISTS btl_java_web;
USE btl_java_web;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert test user
INSERT INTO users (username, email, password, full_name) VALUES 
('testuser', 'test@example.com', 'test123', 'Test User');
```

### 2. Using database.sql Script

```bash
mysql -u root -p < database.sql
```

Or in MySQL Workbench:
1. File → Open SQL Script → Select `database.sql`
2. Execute the script

### 3. Verify Connection

Hibernate configuration is located at: `src/main/resources/hibernate.cfg.xml`

Connection settings:
- **URL**: `jdbc:mysql://localhost:3306/btl_java_web`
- **Username**: `root`
- **Password**: (empty)

## Building the Project

### Clean and Build

```bash
cd D:\BTL_Java_Web\BTL
mvn clean package
```

Output: `target/BTL-1.0-SNAPSHOT.war`

### Build Without Tests

```bash
mvn clean package -DskipTests
```

## Running the Application

### Option 1: Using Tomcat Maven Plugin

```bash
mvn tomcat7:run
```

Then access: `http://localhost:8080/BTL/`

### Option 2: Deploy to Tomcat Server

1. Copy `target/BTL-1.0-SNAPSHOT.war` to `$TOMCAT_HOME/webapps/`
2. Start Tomcat: `./catalina.sh run` (Linux/Mac) or `catalina.bat run` (Windows)
3. Access: `http://localhost:8080/BTL/`

### Option 3: Using IDE

In IntelliJ IDEA or Eclipse:
1. Right-click project → Run on Server
2. Select local Tomcat instance
3. Click Run

## Using the Application

### Access Points

| Page | URL | Purpose |
|------|-----|---------|
| Login | `/BTL/login` | User authentication |
| Register | `/BTL/register` | New user registration |
| Dashboard | `/BTL/dashboard.jsp` | User dashboard (authenticated users only) |
| Logout | `/BTL/logout` | End session |

### Test Credentials

After running `database.sql`:

- **Username**: `testuser`
- **Password**: `test123`

### User Registration

1. Navigate to `/register`
2. Fill in all required fields
3. System validates:
   - Username uniqueness
   - Email uniqueness
   - Password confirmation
4. Upon success, redirect to login page

## Core Components

### 1. User Entity (JPA)

**Location**: `src/main/java/com/example/btl/model/User.java`

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
    
    // Getters and setters...
}
```

### 2. Hibernate Configuration

**Location**: `src/main/resources/hibernate.cfg.xml`

Manages database connections and entity mappings:

```xml
<hibernate-configuration>
    <session-factory>
        <property name="hibernate.connection.driver_class">
            com.mysql.cj.jdbc.Driver
        </property>
        <property name="hibernate.connection.url">
            jdbc:mysql://localhost:3306/btl_java_web
        </property>
        <property name="hibernate.dialect">
            org.hibernate.dialect.MySQL8Dialect
        </property>
        <mapping class="com.example.btl.model.User"/>
    </session-factory>
</hibernate-configuration>
```

### 3. HibernateUtil - SessionFactory Manager

**Location**: `src/main/java/com/example/btl/util/HibernateUtil.java`

```java
public class HibernateUtil {
    private static SessionFactory sessionFactory;

    static {
        sessionFactory = new Configuration()
                .configure("hibernate.cfg.xml")
                .addAnnotatedClass(User.class)
                .buildSessionFactory();
    }

    public static Session getSession() {
        return sessionFactory.openSession();
    }
}
```

### 4. UserDAO - Data Access Object

**Location**: `src/main/java/com/example/btl/dao/UserDAO.java`

Provides Hibernate-based database operations:

#### Key Methods

- `authenticateUser(username, password)` - Validates login credentials
- `registerUser(user)` - Saves new user with transaction
- `usernameExists(username)` - Checks username availability
- `emailExists(email)` - Checks email availability
- `getUserById(id)` - Retrieves user by ID
- `updateUser(user)` - Updates user information
- `deleteUser(id)` - Deletes user record
- `getAllUsers()` - Retrieves all users

#### Example Usage

```java
UserDAO userDAO = new UserDAO();

// Authenticate
User user = userDAO.authenticateUser("john", "password123");

// Register
User newUser = new User("john", "john@example.com", "password123", "John Doe");
userDAO.registerUser(newUser);

// Check availability
boolean exists = userDAO.usernameExists("john");
```

### 5. Servlets

#### LoginServlet
- **Path**: `/login`
- **Methods**: GET (show form), POST (process login)
- **Session**: Creates session on successful authentication

#### RegisterServlet
- **Path**: `/register`
- **Methods**: GET (show form), POST (process registration)
- **Validation**: Username/email uniqueness, password confirmation

#### LogoutServlet
- **Path**: `/logout`
- **Methods**: GET, POST
- **Action**: Invalidates session and redirects to login

### 6. JSP Pages

#### login.jsp
- User login interface
- Error message display
- Link to registration page

#### register.jsp
- User registration form
- Field validation and error messages
- Success message display

#### dashboard.jsp
- Protected page (requires authentication)
- User welcome message
- Navigation and logout button

## Hibernate Query Language (HQL)

Examples used in this application:

```java
// SELECT
"FROM User"
"FROM User WHERE username = :username"
"FROM User WHERE id = :id"

// COUNT
"SELECT COUNT(*) FROM User"
"SELECT COUNT(*) FROM User WHERE username = :username"

// UPDATE (when needed)
"UPDATE User SET fullName = :name WHERE id = :id"

// DELETE (when needed)
"DELETE FROM User WHERE id = :id"
```

## Transaction Management

All database operations use proper transaction handling:

```java
Session session = null;
Transaction transaction = null;
try {
    session = HibernateUtil.getSession();
    transaction = session.beginTransaction();
    // Perform operations
    transaction.commit();
} catch (HibernateException e) {
    if (transaction != null) transaction.rollback();
    e.printStackTrace();
} finally {
    if (session != null) session.close();
}
```

## Security Considerations

⚠️ **Important**: This is a demonstration application. For production:

1. **Password Security**
   - Use bcrypt or PBKDF2 for hashing
   - Never store plain-text passwords
   - Current implementation stores plain text for demo purposes only

2. **Input Validation**
   - Implement stronger validation patterns
   - Use JSR-380 Bean Validation

3. **HTTPS**
   - Always use HTTPS in production
   - Configure SSL/TLS certificates

4. **CSRF Protection**
   - Implement CSRF tokens in forms

5. **Session Security**
   - Use secure and HttpOnly flags on cookies
   - Implement session timeout

6. **SQL Injection Prevention**
   - Hibernate's parameterized queries prevent SQL injection
   - Current implementation is safe from SQL injection

## Dependencies

```xml
<!-- Jakarta Servlet API -->
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>6.0.0</version>
    <scope>provided</scope>
</dependency>

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

<!-- MySQL Connector -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```

## Troubleshooting

### 1. SessionFactory Creation Failed
```
Error: Could not instantiate SessionFactory
```
**Solution**:
- Verify `hibernate.cfg.xml` is in `src/main/resources/`
- Check MySQL JDBC driver is in classpath
- Verify database connection credentials

### 2. HibernateException: Could not resolve mapping class
```
Error: Could not resolve mapping class
```
**Solution**:
- Ensure User entity is added to `hibernatecfg.xml`
- Check @Entity annotation is present
- Verify class path is correct

### 3. MySQL Connection Refused
```
Error: Connection refused
```
**Solution**:
- Verify MySQL server is running
- Check database URL and credentials in `hibernate.cfg.xml`
- Ensure database exists: `SHOW DATABASES;`

### 4. ClassNotFoundException: org.hibernate.Session
```
Error: ClassNotFoundException
```
**Solution**:
- Run `mvn clean install` to download dependencies
- Check Hibernate JARs are in `target/lib/`

### 5. No Session Bound to current Thread
```
Error: No Session bound to current Thread
```
**Solution**:
- Always close Session in finally block
- Don't share Session across threads
- Call `HibernateUtil.getSession()` for each operation

## Performance Optimization

### 1. Connection Pooling

Add to `hibernate.cfg.xml`:
```xml
<property name="hibernate.connection.pool_size">20</property>
```

### 2. Batch Processing

```xml
<property name="hibernate.jdbc.batch_size">20</property>
<property name="hibernate.order_inserts">true</property>
<property name="hibernate.order_updates">true</property>
```

### 3. Lazy Loading

Use lazy loading (default) to avoid unnecessary queries:
```java
@OneToMany(fetch = FetchType.LAZY)
```

### 4. Caching

Enable Hibernate's first-level cache (default):
```java
User user1 = session.get(User.class, 1);
User user2 = session.get(User.class, 1); // From cache
```

## Future Enhancements

- [ ] Password hashing with bcrypt
- [ ] Email verification on registration
- [ ] Password reset functionality
- [ ] User profile management
- [ ] Role-based access control (RBAC)
- [ ] Two-factor authentication (2FA)
- [ ] User activity logging
- [ ] Admin dashboard
- [ ] REST API endpoints
- [ ] Spring Boot migration
- [ ] Docker containerization

## Additional Resources

For detailed Hibernate implementation guide, see: **HIBERNATE_GUIDE.md**

## References

- [Hibernate Official Documentation](https://hibernate.org/orm/documentation/)
- [Jakarta Persistence API Specification](https://jakarta.ee/specifications/persistence/)
- [Jakarta Servlet Specification](https://jakarta.ee/specifications/servlet/)
- [MySQL JDBC Documentation](https://dev.mysql.com/doc/connector-j/8.0/en/)

## License

This project is provided for educational purposes.

## Support

For issues or questions:
1. Check the **HIBERNATE_GUIDE.md** for detailed explanations
2. Review Hibernate logs in console output
3. Verify database setup with `mysql -u root`
4. Check all dependencies are installed: `mvn dependency:tree`

