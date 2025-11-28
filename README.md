# BTL-Servlet-Java — Web Shopping App (Java Servlet)

A Java Servlet/JSP e-commerce web application with end‑to‑end shopping flow: browse products, manage cart, checkout, and pay via an integrated payment gateway.

Vietnamese: Ứng dụng mua sắm trực tuyến xây dựng bằng Java Servlet/JSP, hỗ trợ giỏ hàng, thanh toán và tích hợp cổng thanh toán.

---

## What this project does

Core user journeys:
- Product browsing
  - View product list and details with pricing, images, and descriptions
  - Search and sort by name/price/category
- Shopping cart
  - Add/update/remove items
  - Persist cart across pages and sessions
- Checkout
  - Collect shipping and contact information
  - Choose payment method
- Payment (Gateway‑integrated)
  - Redirect/hosted checkout or on‑site (depending on gateway)
  - Return URL handling for success/cancel
  - Webhook/callback handling to confirm final payment status
- Orders
  - Create order from cart, calculate totals, track status (Pending, Paid, Canceled)
  - View order history and details
- Accounts
  - Sign up / sign in / sign out
  - Session management
  - Basic profile management
- Admin (if enabled)
  - Manage products (CRUD), categories, inventory, and orders
  - View payments and reconcile statuses

High‑level flow:
1) User browses products and adds items to the cart
2) User proceeds to checkout and reviews order summary
3) App creates a pending order and initiates payment with the gateway
4) User completes payment on gateway page (or inline)
5) Gateway redirects back to app (return URL)
6) App verifies the payment via callback/webhook or server‑side confirmation
7) Order status updates to Paid; confirmation screen shown to user

---

## Payment gateway integration

This project is built to integrate with a payment gateway using common patterns:
- Initialization
  - Create a payment request from server using total amount, currency, orderId, and return/callback URLs
  - Sign requests and verify signatures where required
- Redirect flow
  - Redirect the customer to gateway checkout
  - On success/cancel, gateway sends user back to `returnUrl` with transaction params
- Server verification
  - Validate gateway response (signature, transactionId, orderId, amount)
  - Optionally call gateway’s verify API
- Webhook/callback (recommended)
  - Expose an endpoint for asynchronous notifications
  - Update order status to Paid/Failed based on verified payload
- Idempotency
  - Ensure re‑playing webhooks doesn’t double‑charge or double‑confirm
- Security
  - Store secret keys securely (environment/secret manager)
  - Enforce HTTPS in production
  - Validate all incoming gateway data

Configuration (examples; rename to match your gateway):
- Environment variables or app config:
  - `PAYMENT_GATEWAY_KEY` / `PAYMENT_GATEWAY_SECRET`
  - `PAYMENT_RETURN_URL` (e.g., https://your-domain/checkout/return)
  - `PAYMENT_WEBHOOK_URL` (e.g., https://your-domain/api/payments/webhook)
  - `PAYMENT_GATEWAY_BASE_URL`
- Order lifecycle:
  - Pending → Paid/Failed/Canceled
  - Reconcile statuses via webhook and/or verify API

Note: Replace placeholders with your actual gateway details (provider name, endpoints, keys, and signature method).

---

## Tech stack

Languages in repository:
- Java — 68.9%
- JavaScript — 20.9%
- CSS — 7.7%
- SCSS — 1.3%
- Less — 1.2%

Backend:
- Java (Servlet API, JSP/JSTL)
- HTTP Sessions, Filters, and MVC‑style Controllers (Servlets)
- DAO/Service layers for business logic and data access
- Relational database (e.g., MySQL/PostgreSQL) via JDBC or a light ORM
- Payment gateway SDK/REST integration

Frontend:
- Vanilla JavaScript for interactivity (cart updates, validations)
- CSS with SCSS/Less pre‑processing for styles
- JSP views for server‑rendered pages

Runtime and tooling:
- Apache Tomcat (9/10 recommended)
- Maven or Gradle (build and dependency management)
- Node.js tooling for SCSS/Less compilation (optional)

---

## Key modules

- Product module
  - Product listing, detail pages, categories
  - Inventory checks (optional)
- Cart module
  - Session‑backed cart, add/remove/update
  - Pricing and totals computation
- Checkout module
  - Address/contact forms and validation
  - Order creation and confirmation pages
- Payment module
  - Gateway client (init/redirect/verify)
  - Return URL + webhook endpoints
  - Signature verification and idempotency
- User module
  - Authentication (login/register), password hashing
  - Profile and order history
- Admin module (optional)
  - Product/Category CRUD
  - Orders view and manual reconciliation

---

## Running locally (quick outline)

- Prerequisites: JDK 11+, Tomcat 9/10, Maven or Gradle, database, Node.js (if using SCSS/Less)
- Configure environment variables (payment keys/URLs and database credentials)
- Build:
  - Maven: `mvn clean package`
  - Gradle: `./gradlew clean build`
- Deploy the WAR to Tomcat (`webapps/`) or run via IDE server config
- Access: `http://localhost:8080/<context-path>`

SCSS/Less (optional):
- SCSS: `npx sass src/main/webapp/assets/scss:src/main/webapp/assets/css --watch`
- Less: `npx lessc src/main/webapp/assets/less/styles.less > src/main/webapp/assets/css/styles.css`

---

## Project structure (typical)

```
src/main/java/...            # Servlets, Filters, Services, DAOs, Models
src/main/webapp/             # JSP views, static assets
  ├─ WEB-INF/web.xml
  ├─ assets/
  │  ├─ js/
  │  ├─ css/
  │  ├─ scss/                # if used
  │  └─ less/                # if used
  └─ index.jsp
pom.xml or build.gradle
```
Tuyên đã ở đây

