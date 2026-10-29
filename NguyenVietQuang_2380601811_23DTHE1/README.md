# Child Devices Management API

API Backend quản lý thiết bị trẻ em - Đồ án giữa kỳ Lập trình di động

**Sinh viên:** Nguyễn Việt Quang  
**MSSV:** 2380601811  
**Lớp:** 23DTHE1

---

## 📋 Tổng quan

Đây là một ASP.NET Core Web API hoàn chỉnh để quản lý hệ thống thiết bị trẻ em, bao gồm các tính năng:

- ✅ **Authentication & Authorization** với JWT
- ✅ **Quản lý thiết bị** (CRUD operations)
- ✅ **Quản lý đơn hàng** với inventory tracking
- ✅ **Hệ thống đánh giá** sản phẩm
- ✅ **Role-based access control** (Admin/User)
- ✅ **Phân trang và tìm kiếm**
- ✅ **Clean Architecture**
- ✅ **Error handling middleware**
- ✅ **Swagger documentation**

---

## 🏗️ Kiến trúc

Dự án được xây dựng theo **Clean Architecture** với các layers:

\\\
├── Models/              # Domain entities
├── DTOs/                # Data Transfer Objects
├── Data/                # DbContext & Database access
├── Services/            # Business logic
├── Controllers/         # API endpoints
├── Helpers/             # Utility classes
└── Middleware/          # Custom middleware
\\\

---

## 🛠️ Công nghệ sử dụng

- **.NET 9.0**
- **Entity Framework Core 9.0** (SQL Server)
- **JWT Authentication**
- **BCrypt.Net** (Password hashing)
- **Swashbuckle** (Swagger/OpenAPI)

---

## 📦 Cài đặt

### 1. Yêu cầu hệ thống

- .NET 9.0 SDK
- SQL Server hoặc SQL Server LocalDB
- Visual Studio 2022 / VS Code / Rider

### 2. Clone và cài đặt dependencies

\\\ash
# Restore packages
dotnet restore

# Build project
dotnet build
\\\

### 3. Cấu hình Database

Chỉnh sửa connection string trong \ppsettings.json\:

\\\json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=ChildDevicesDB;Trusted_Connection=true;TrustServerCertificate=true"
  }
}
\\\

### 4. Tạo Database

\\\ash
# Tạo migration (đã tạo sẵn)
dotnet ef migrations add InitialCreate

# Apply migration và tạo database
dotnet ef database update
\\\

### 5. Chạy ứng dụng

\\\ash
dotnet run
\\\

API sẽ chạy tại: **https://localhost:7xxx** hoặc **http://localhost:5xxx**

Swagger UI: **https://localhost:7xxx** (root)

---

## 👤 Tài khoản mặc định

Hệ thống tự động tạo tài khoản Admin khi khởi tạo database:

- **Username:** \dmin\
- **Password:** \Admin@123\
- **Role:** Admin

---

## 📚 API Endpoints

### 🔐 Authentication

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | \/api/auth/register\ | Đăng ký tài khoản mới | ❌ |
| POST | \/api/auth/login\ | Đăng nhập | ❌ |
| GET | \/api/auth/me\ | Lấy thông tin user hiện tại | ✅ |

### 📱 Devices (Thiết bị)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | \/api/devices\ | Lấy danh sách thiết bị (có phân trang, filter) | ❌ |
| GET | \/api/devices/{id}\ | Lấy chi tiết thiết bị | ❌ |
| POST | \/api/devices\ | Tạo thiết bị mới | ✅ Admin |
| PUT | \/api/devices/{id}\ | Cập nhật thiết bị | ✅ Admin |
| DELETE | \/api/devices/{id}\ | Xóa thiết bị | ✅ Admin |

**Query parameters cho GET /api/devices:**
- \pageNumber\ (int): Trang hiện tại (default: 1)
- \pageSize\ (int): Số items/trang (default: 10)
- \search\ (string): Tìm kiếm theo tên/mô tả
- \category\ (string): Lọc theo danh mục
- \minAge\ (int): Độ tuổi tối thiểu
- \maxAge\ (int): Độ tuổi tối đa

**Categories:**
- \EducationalToy\ - Đồ chơi giáo dục
- \ElectronicDevice\ - Thiết bị điện tử
- \SafetyDevice\ - Thiết bị an toàn
- \Monitor\ - Thiết bị giám sát
- \SmartWatch\ - Đồng hồ thông minh
- \Tablet\ - Máy tính bảng
- \Other\ - Khác

### 🛒 Orders (Đơn hàng)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | \/api/orders\ | Lấy danh sách đơn hàng | ✅ |
| GET | \/api/orders/{id}\ | Lấy chi tiết đơn hàng | ✅ |
| POST | \/api/orders\ | Tạo đơn hàng mới | ✅ |
| PATCH | \/api/orders/{id}/status\ | Cập nhật trạng thái đơn | ✅ Admin |
| POST | \/api/orders/{id}/cancel\ | Hủy đơn hàng | ✅ |

**Order Status:**
- \Pending\ - Chờ xử lý
- \Confirmed\ - Đã xác nhận
- \Processing\ - Đang xử lý
- \Shipping\ - Đang giao hàng
- \Delivered\ - Đã giao hàng
- \Cancelled\ - Đã hủy

### ⭐ Reviews (Đánh giá)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | \/api/reviews\ | Lấy danh sách đánh giá | ❌ |
| GET | \/api/reviews/{id}\ | Lấy chi tiết đánh giá | ❌ |
| POST | \/api/reviews\ | Tạo đánh giá mới | ✅ |
| PUT | \/api/reviews/{id}\ | Cập nhật đánh giá | ✅ |
| DELETE | \/api/reviews/{id}\ | Xóa đánh giá | ✅ |

---

## 🔑 Authentication

API sử dụng **JWT Bearer Token**. Sau khi đăng nhập, thêm token vào header:

\\\
Authorization: Bearer {your_token_here}
\\\

---

## 📝 Ví dụ sử dụng

### 1. Đăng ký tài khoản

\\\http
POST /api/auth/register
Content-Type: application/json

{
  "username": "user123",
  "email": "user@example.com",
  "password": "Password@123",
  "fullName": "Nguyen Van A",
  "phoneNumber": "0123456789"
}
\\\

### 2. Đăng nhập

\\\http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "Admin@123"
}
\\\

**Response:**
\\\json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@childdevices.com",
      "fullName": "System Administrator",
      "role": "Admin"
    }
  }
}
\\\

### 3. Lấy danh sách thiết bị

\\\http
GET /api/devices?pageNumber=1&pageSize=10&category=SmartWatch&minAge=5&maxAge=12
\\\

### 4. Tạo đơn hàng

\\\http
POST /api/orders
Authorization: Bearer {token}
Content-Type: application/json

{
  "shippingAddress": "123 Nguyen Trai, Quan 1, TP.HCM",
  "phoneNumber": "0987654321",
  "notes": "Giao hang ngoai gio hanh chinh",
  "items": [
    {
      "deviceId": 1,
      "quantity": 2
    },
    {
      "deviceId": 3,
      "quantity": 1
    }
  ]
}
\\\

### 5. Tạo đánh giá

\\\http
POST /api/reviews
Authorization: Bearer {token}
Content-Type: application/json

{
  "deviceId": 1,
  "rating": 5,
  "comment": "San pham rat tot, con toi rat thich!"
}
\\\

---

## 🗄️ Database Schema

### Users
- Id, Username, Email, PasswordHash, FullName, PhoneNumber, Role, IsActive, CreatedAt, UpdatedAt

### Devices
- Id, Name, Description, Category, Price, Brand, ModelNumber, ImageUrl, StockQuantity, MinAge, MaxAge, IsAvailable, CreatedBy, CreatedAt, UpdatedAt

### Orders
- Id, OrderNumber, UserId, TotalAmount, Status, ShippingAddress, PhoneNumber, Notes, CreatedAt, UpdatedAt

### OrderItems
- Id, OrderId, DeviceId, Quantity, UnitPrice, TotalPrice

### Reviews
- Id, UserId, DeviceId, Rating, Comment, CreatedAt, UpdatedAt

---

## 🎯 Tính năng nổi bật

### 1. Inventory Management
- Tự động cập nhật số lượng tồn kho khi tạo/hủy đơn hàng
- Kiểm tra tồn kho trước khi tạo đơn
- Transaction rollback nếu có lỗi

### 2. Business Rules
- Mỗi user chỉ được đánh giá 1 lần cho mỗi sản phẩm
- Chỉ hủy được đơn hàng ở trạng thái Pending/Confirmed
- Admin có quyền cao hơn trong việc quản lý

### 3. Security
- Password được hash bằng BCrypt
- JWT token có thời hạn 7 ngày
- Role-based authorization
- Input validation

### 4. API Response Format
Tất cả responses đều theo format chuẩn:

\\\json
{
  "success": true/false,
  "message": "Description",
  "data": {...},
  "errors": [...]
}
\\\

---

## 🧪 Testing

Sử dụng Swagger UI để test API:

1. Chạy ứng dụng
2. Mở browser tại root URL (https://localhost:xxxx)
3. Click "Authorize" và nhập Bearer token
4. Test các endpoints

Hoặc sử dụng Postman/Thunder Client với collection đã export.

---

## 📖 Documentation

- **Swagger UI:** Available at root URL khi chạy ứng dụng
- **OpenAPI Spec:** \/swagger/v1/swagger.json\

---

## 🐛 Troubleshooting

### Connection string error
- Kiểm tra SQL Server đang chạy
- Đổi connection string phù hợp với môi trường của bạn

### Migration error
\\\ash
# Xóa migration cũ
dotnet ef database drop

# Tạo lại
dotnet ef database update
\\\

### JWT error
- Đảm bảo \Jwt:Key\ trong appsettings.json đủ dài (>= 32 characters)

---

## 📞 Liên hệ

- **Sinh viên:** Nguyễn Việt Quang
- **Email:** quang@example.com
- **GitHub:** [Your GitHub]

---

## 📄 License

Dự án này được tạo cho mục đích học tập - Đồ án giữa kỳ môn Lập trình di động.

**© 2024 Nguyen Viet Quang - 23DTHE1**
