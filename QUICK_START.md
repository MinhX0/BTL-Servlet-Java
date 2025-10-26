# Hibernate & JPA Implementation - Quick Start Guide

## What Changed?

Your project has been upgraded from **raw JDBC** to **Hibernate ORM** with **JPA**.

### Before (JDBC)
```java
// Manual SQL
String query = "SELECT id, username, email FROM users WHERE username = ? AND password = ?";
PreparedStatement stmt = conn.prepareStatement(query);
stmt.setString(1, username);
stmt.setString(2, password);
ResultSet rs = stmt.executeQuery();
```

### After (Hibernate)
```java
// Automatic mapping
String hql = "FROM User WHERE username = :username AND password = :password";
Query<User> query = session.createQuery(hql, User.class);
query.setParameter("username", username);
query.setParameter("password", password);
User user = query.uniqueResult();
```

## 5-Minute Setup

### Step 1: Create Database

```bash
mysql -u root < database.sql
```

### Step 2: Build Project

```bash
cd D:\BTL_Java_Web\BTL
mvn clean package
```

### Step 3: Deploy to Tomcat

Copy `target/BTL-1.0-SNAPSHOT.war` to Tomcat's `webapps/` directory

### Step 4: Start Tomcat

```bash
# Windows
catalina.bat run

# Linux/Mac
./catalina.sh run
```

### Step 5: Access Application

Open browser: `http://localhost:8080/BTL/login`

**Test Login**:
- Username: `testuser`
- Password: `test123`

## New Files Added

| File | Purpose |
|------|---------|
| `src/main/resources/hibernate.cfg.xml` | Hibernate configuration |
| `src/main/java/com/example/btl/util/HibernateUtil.java` | SessionFactory manager |
| `src/main/java/com/example/btl/servlet/RegisterServlet.java` | User registration |
| `HIBERNATE_GUIDE.md` | Detailed Hibernate documentation |

## Modified Files

| File | Changes |
|------|---------|
| `pom.xml` | Added Hibernate and JPA dependencies |
| `src/main/java/com/example/btl/model/User.java` | Added JPA @Entity annotations |
| `src/main/java/com/example/btl/dao/UserDAO.java` | Refactored to use Hibernate |
| `src/main/webapp/register.jsp` | Enhanced with validation |

## Key Concepts

### 1. Entities (Models)

JPA entities are classes that map to database tables:

```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(unique = true)
    private String username;
    
    // ...
}
```

### 2. SessionFactory & Session

- **SessionFactory**: Manages sessions (thread-safe, singleton)
- **Session**: Represents a single user interaction with the database

```java
SessionFactory factory = HibernateUtil.getSessionFactory();
Session session = HibernateUtil.getSession();
```

### 3. DAO Pattern

Data Access Objects encapsulate database operations:

```java
UserDAO userDAO = new UserDAO();
User user = userDAO.authenticateUser("john", "password");
```

### 4. Transactions

Ensure data integrity with transactions:

```java
Transaction transaction = session.beginTransaction();
try {
    session.persist(user);
    transaction.commit();
} catch (Exception e) {
    transaction.rollback();
}
```

## Common Operations

### Authenticate User
```java
User user = userDAO.authenticateUser(username, password);
if (user != null) {
    // Login successful
}
```

### Register User
```java
User newUser = new User(username, email, password, fullName);
boolean success = userDAO.registerUser(newUser);
```

### Check Availability
```java
boolean taken = userDAO.usernameExists("john");
```

### Get User by ID
```java
User user = userDAO.getUserById(1);
```

## Hibernate vs JDBC Comparison

| Aspect | JDBC | Hibernate |
|--------|------|-----------|
| **Code Volume** | 30+ lines per query | 5-10 lines |
| **SQL Injection** | Need PreparedStatement | Automatic prevention |
| **Type Safety** | ResultSet casting | Type-safe queries |
| **Caching** | Manual | Built-in |
| **Relationships** | Manual joins | Automatic mapping |
| **Learning Curve** | Easy | Moderate |
| **Production Ready** | Yes | Yes (industry standard) |

## URL Routes

```
/BTL/login              → User login page
/BTL/register           → User registration page
/BTL/dashboard.jsp      → Authenticated user dashboard
/BTL/logout             → Logout (invalidate session)
```

## Configuration Files

### hibernate.cfg.xml
Located at: `src/main/resources/hibernate.cfg.xml`

Contains:
- Database connection details
- Hibernate settings
- Entity class mappings

```xml
<property name="hibernate.connection.url">
    jdbc:mysql://localhost:3306/btl_java_web
</property>
```

### web.xml
Located at: `src/main/webapp/WEB-INF/web.xml`

Deployment configuration (uses annotation-based servlet registration)

## Session Management

Sessions are created automatically on login:

```java
HttpSession session = request.getSession(true);
session.setAttribute("user", user);
session.setAttribute("username", user.getUsername());
session.setMaxInactiveInterval(30 * 60); // 30 minutes
```

Dashboard checks for session:

```java
if (session.getAttribute("user") == null) {
    // Redirect to login
}
```

## Error Handling

Common issues and solutions:

### Issue: "Mapping class not found"
**Cause**: Entity not registered in hibernate.cfg.xml  
**Fix**: Add `<mapping class="com.example.btl.model.User"/>`

### Issue: "Connection refused"
**Cause**: MySQL not running  
**Fix**: Start MySQL service

### Issue: "Table doesn't exist"
**Cause**: database.sql not executed  
**Fix**: Run: `mysql -u root < database.sql`

## Debugging

Enable SQL logging in `hibernate.cfg.xml`:

```xml
<property name="hibernate.show_sql">true</property>
<property name="hibernate.format_sql">true</property>
```

This will print all SQL queries to console.

## Next Steps

1. **Test the application**
   - Login with testuser/test123
   - Register a new user
   - Logout

2. **Explore the code**
   - Review User.java entity
   - Study UserDAO methods
   - Examine LoginServlet

3. **Enhance security**
   - Implement password hashing (bcrypt)
   - Add input validation
   - Use HTTPS

4. **Advanced features**
   - Add user roles
   - Implement email verification
   - Create admin dashboard

## Additional Documentation

- **HIBERNATE_GUIDE.md** - Comprehensive Hibernate guide
- **README_HIBERNATE.md** - Full project documentation
- **database.sql** - Database schema and test data

## FAQ

**Q: Why use Hibernate over JDBC?**  
A: Less boilerplate, automatic SQL generation, built-in caching, better maintainability

**Q: Is Hibernate slow?**  
A: No, with proper configuration it's as fast as JDBC. Caching makes it faster.

**Q: Can I use raw SQL with Hibernate?**  
A: Yes, use `session.createNativeQuery()` for native SQL queries

**Q: How do I add new entities?**  
A: Create a class with @Entity, add @Column annotations, register in hibernate.cfg.xml

**Q: What's the difference between persist() and merge()?**  
A: persist() for new objects, merge() for existing objects

## Support

- Check console logs for error messages
- Enable `hibernate.show_sql=true` for debugging
- Verify database connection in `hibernate.cfg.xml`
- Ensure all Maven dependencies are installed: `mvn install`

---

**Ready to go!** Follow the 5-minute setup above to get started.

