# API Testing Quick Guide

## Test với Swagger UI (Khuyến nghị)

1. Chạy ứng dụng: \dotnet run\
2. Mở browser: \https://localhost:xxxx\
3. Test ngay trên giao diện Swagger

## Test với HTTP File (VS Code/Rider)

### 1. Authentication Tests

\\\http
### Login Admin
POST https://localhost:7xxx/api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "Admin@123"
}

### Register New User
POST https://localhost:7xxx/api/auth/register
Content-Type: application/json

{
  "username": "testuser",
  "email": "test@example.com",
  "password": "Test@123",
  "fullName": "Test User",
  "phoneNumber": "0123456789"
}

### Get Current User
GET https://localhost:7xxx/api/auth/me
Authorization: Bearer YOUR_TOKEN_HERE
\\\

### 2. Devices Tests

\\\http
### Get All Devices
GET https://localhost:7xxx/api/devices?pageNumber=1&pageSize=10

### Get Device by ID
GET https://localhost:7xxx/api/devices/1

### Search Devices
GET https://localhost:7xxx/api/devices?search=watch&category=SmartWatch&minAge=5&maxAge=12

### Create Device (Admin only)
POST https://localhost:7xxx/api/devices
Authorization: Bearer ADMIN_TOKEN
Content-Type: application/json

{
  "name": "Test Device",
  "description": "Test description",
  "category": "SmartWatch",
  "price": 1500000,
  "brand": "TestBrand",
  "modelNumber": "TEST-001",
  "imageUrl": "https://example.com/image.jpg",
  "stockQuantity": 10,
  "minAge": 5,
  "maxAge": 10
}

### Update Device (Admin only)
PUT https://localhost:7xxx/api/devices/1
Authorization: Bearer ADMIN_TOKEN
Content-Type: application/json

{
  "price": 1800000,
  "stockQuantity": 15
}
\\\

### 3. Orders Tests

\\\http
### Get All Orders
GET https://localhost:7xxx/api/orders
Authorization: Bearer YOUR_TOKEN

### Create Order
POST https://localhost:7xxx/api/orders
Authorization: Bearer YOUR_TOKEN
Content-Type: application/json

{
  "shippingAddress": "123 Test Street, District 1, HCMC",
  "phoneNumber": "0987654321",
  "notes": "Deliver after 6 PM",
  "items": [
    {
      "deviceId": 1,
      "quantity": 1
    }
  ]
}

### Get Order by ID
GET https://localhost:7xxx/api/orders/1
Authorization: Bearer YOUR_TOKEN

### Cancel Order
POST https://localhost:7xxx/api/orders/1/cancel
Authorization: Bearer YOUR_TOKEN

### Update Order Status (Admin only)
PATCH https://localhost:7xxx/api/orders/1/status
Authorization: Bearer ADMIN_TOKEN
Content-Type: application/json

{
  "status": "Confirmed"
}
\\\

### 4. Reviews Tests

\\\http
### Get Reviews for Device
GET https://localhost:7xxx/api/reviews?deviceId=1

### Create Review
POST https://localhost:7xxx/api/reviews
Authorization: Bearer YOUR_TOKEN
Content-Type: application/json

{
  "deviceId": 1,
  "rating": 5,
  "comment": "Excellent product!"
}

### Update Review
PUT https://localhost:7xxx/api/reviews/1
Authorization: Bearer YOUR_TOKEN
Content-Type: application/json

{
  "rating": 4,
  "comment": "Updated review"
}

### Delete Review
DELETE https://localhost:7xxx/api/reviews/1
Authorization: Bearer YOUR_TOKEN
\\\

## Test Flow Scenario

### Kịch bản 1: User mua hàng

1. **Register** tài khoản user
2. **Login** để lấy token
3. **Browse devices** - Xem danh sách thiết bị
4. **Create order** - Đặt hàng
5. **Get orders** - Xem đơn hàng của mình
6. **Create review** - Đánh giá sản phẩm

### Kịch bản 2: Admin quản lý

1. **Login** với admin account
2. **Create device** - Thêm sản phẩm mới
3. **Update device** - Cập nhật thông tin
4. **Get all orders** - Xem tất cả đơn hàng
5. **Update order status** - Cập nhật trạng thái đơn

## Expected Responses

### Success Response
\\\json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
\\\

### Error Response
\\\json
{
  "success": false,
  "message": "Error description",
  "errors": ["Error detail 1", "Error detail 2"]
}
\\\

## Common HTTP Status Codes

- **200 OK** - Request successful
- **201 Created** - Resource created
- **400 Bad Request** - Invalid input
- **401 Unauthorized** - Missing or invalid token
- **403 Forbidden** - Insufficient permissions
- **404 Not Found** - Resource not found
- **500 Internal Server Error** - Server error
