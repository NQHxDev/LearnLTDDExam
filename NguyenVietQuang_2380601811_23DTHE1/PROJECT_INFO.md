# 📊 THÔNG TIN DỰ ÁN

## Thông tin sinh viên
- **Họ tên:** Nguyễn Việt Quang
- **MSSV:** 2380601811
- **Lớp:** 23DTHE1
- **Môn học:** Lập trình di động
- **Đề tài:** Hệ thống quản lý thiết bị trẻ em

---

## Cấu trúc dự án

\\\
NguyenVietQuang_2380601811_23DTHE1/
│
├── Controllers/                    # API Controllers
│   ├── AuthController.cs          # Authentication endpoints
│   ├── DevicesController.cs       # Device management
│   ├── OrdersController.cs        # Order management
│   └── ReviewsController.cs       # Review management
│
├── Models/                         # Domain Models
│   ├── User.cs                    # User entity
│   ├── Device.cs                  # Device entity
│   ├── Order.cs                   # Order entity
│   ├── OrderItem.cs               # Order item entity
│   └── Review.cs                  # Review entity
│
├── DTOs/                          # Data Transfer Objects
│   ├── AuthDtos.cs                # Auth DTOs
│   ├── DeviceDtos.cs              # Device DTOs
│   ├── OrderDtos.cs               # Order DTOs
│   └── ReviewDtos.cs              # Review DTOs
│
├── Services/                       # Business Logic Layer
│   ├── AuthService.cs             # Authentication service
│   ├── DeviceService.cs           # Device service
│   ├── OrderService.cs            # Order service
│   └── ReviewService.cs           # Review service
│
├── Data/                          # Data Access Layer
│   └── ApplicationDbContext.cs    # EF Core DbContext
│
├── Helpers/                       # Utility Classes
│   ├── ApiResponse.cs             # Standard API response format
│   └── JwtHelper.cs               # JWT token helper
│
├── Middleware/                    # Custom Middleware
│   └── ErrorHandlingMiddleware.cs # Global error handler
│
├── Migrations/                    # EF Core Migrations
│
├── Program.cs                     # Application entry point
├── appsettings.json              # Configuration
├── README.md                      # Project documentation
├── API_TESTING_GUIDE.md          # API testing guide
└── start.bat                      # Quick start script

\\\

---

## Tính năng đã triển khai

### ✅ Core Features

1. **Authentication & Authorization**
   - Đăng ký tài khoản
   - Đăng nhập với JWT
   - Role-based access (Admin/User)
   - Password hashing với BCrypt

2. **Device Management**
   - CRUD operations cho thiết bị
   - Phân loại theo danh mục
   - Lọc theo độ tuổi phù hợp
   - Tìm kiếm và phân trang
   - Quản lý tồn kho

3. **Order Management**
   - Tạo đơn hàng
   - Xem danh sách đơn hàng
   - Cập nhật trạng thái (Admin)
   - Hủy đơn hàng
   - Tự động cập nhật tồn kho
   - Transaction handling

4. **Review System**
   - Đánh giá sản phẩm (1-5 sao)
   - Bình luận
   - Mỗi user chỉ review 1 lần/sản phẩm
   - Tính trung bình rating

### ✅ Technical Features

- Clean Architecture
- Repository Pattern
- Dependency Injection
- Error Handling Middleware
- API Response Standardization
- Swagger/OpenAPI Documentation
- Entity Framework Core
- SQL Server Database
- Data Seeding

---

## Database Schema

### Tables

1. **Users** - Quản lý người dùng
2. **Devices** - Quản lý thiết bị
3. **Orders** - Quản lý đơn hàng
4. **OrderItems** - Chi tiết đơn hàng
5. **Reviews** - Đánh giá sản phẩm

### Relationships

- User 1:N Devices (created by)
- User 1:N Orders
- User 1:N Reviews
- Device 1:N Reviews
- Device 1:N OrderItems
- Order 1:N OrderItems

---

## API Endpoints Summary

| Module | Endpoints | Methods |
|--------|-----------|---------|
| Auth | 3 | POST, GET |
| Devices | 5 | GET, POST, PUT, DELETE |
| Orders | 5 | GET, POST, PATCH |
| Reviews | 5 | GET, POST, PUT, DELETE |

**Tổng cộng: 18 API endpoints**

---

## Technologies Used

### Backend Framework
- ASP.NET Core 9.0 Web API

### Database
- Entity Framework Core 9.0
- SQL Server / LocalDB

### Security
- JWT Bearer Authentication
- BCrypt Password Hashing
- Role-based Authorization

### Documentation
- Swagger/OpenAPI
- Swashbuckle.AspNetCore

### Tools
- .NET CLI
- Entity Framework Tools

---

## Sample Data

Hệ thống tự động tạo dữ liệu mẫu khi khởi tạo database:

- **1 Admin account**
- **5 Sample devices** (Đồng hồ, Tablet, Robot, Camera, GPS Tracker)

---

## Hướng dẫn chạy

### Quick Start

\\\ash
# 1. Clone project (nếu từ git)
git clone <repo-url>

# 2. Restore dependencies
dotnet restore

# 3. Update database
dotnet ef database update

# 4. Run application
dotnet run

# Hoặc chạy file start.bat
\\\

### Truy cập

- **API:** https://localhost:7xxx
- **Swagger UI:** https://localhost:7xxx (root)

### Test Account

- Username: \dmin\
- Password: \Admin@123\

---

## Business Rules

1. **Inventory Management**
   - Tự động giảm stock khi tạo đơn
   - Tự động tăng stock khi hủy đơn
   - Không cho phép đặt hàng khi hết stock

2. **Order Management**
   - Chỉ hủy được đơn Pending/Confirmed
   - Admin có thể cập nhật trạng thái
   - User chỉ xem được đơn của mình

3. **Review System**
   - Mỗi user chỉ review 1 lần/sản phẩm
   - User chỉ sửa/xóa review của mình
   - Admin có thể xóa mọi review

4. **Security**
   - Password tối thiểu 6 ký tự
   - Email/Username unique
   - JWT token expire sau 7 ngày

---

## API Response Format

Tất cả API đều trả về format chuẩn:

\\\json
{
  "success": true,
  "message": "Operation description",
  "data": { ... },
  "errors": null
}
\\\

---

## Error Handling

- **400 Bad Request** - Input validation errors
- **401 Unauthorized** - Authentication failed
- **403 Forbidden** - Insufficient permissions
- **404 Not Found** - Resource not found
- **500 Internal Server Error** - Server errors

Tất cả errors đều được handle bởi ErrorHandlingMiddleware.

---

## Testing

### Manual Testing
1. Sử dụng Swagger UI (khuyến nghị)
2. Sử dụng Postman/Thunder Client
3. Sử dụng HTTP file (VS Code/Rider)

### Test Scenarios
Xem chi tiết trong file \API_TESTING_GUIDE.md\

---

## Deployment Notes

### Môi trường Production

1. Đổi connection string trong \ppsettings.json\
2. Đổi JWT key thành key mạnh hơn
3. Disable detailed error messages
4. Enable HTTPS
5. Configure CORS properly

### Database Migration

\\\ash
# Apply migrations
dotnet ef database update

# Rollback
dotnet ef database update <previous-migration>
\\\

---

## Future Enhancements

- [ ] Image upload for devices
- [ ] Payment integration
- [ ] Email notifications
- [ ] SMS notifications
- [ ] Advanced search filters
- [ ] Statistics dashboard
- [ ] Export orders to Excel
- [ ] User profile management
- [ ] Wishlist feature
- [ ] Shopping cart

---

## Đánh giá tự đánh giá

### Điểm mạnh
✅ Kiến trúc rõ ràng, dễ maintain
✅ Code clean, có comments
✅ Error handling tốt
✅ API documentation đầy đủ
✅ Security practices tốt
✅ Business logic đúng đắn

### Hạn chế
- Chưa có unit tests
- Chưa có logging system
- Chưa có caching
- UI/Frontend chưa có

---

## Kết luận

Dự án đã hoàn thành đầy đủ các chức năng cơ bản của một hệ thống quản lý thiết bị trẻ em, 
bao gồm authentication, authorization, CRUD operations, và business logic phức tạp.

API được thiết kế theo chuẩn RESTful, có documentation đầy đủ, và sẵn sàng để tích hợp 
với mobile app hoặc frontend.

---

**Ngày hoàn thành:** 29/10/2026
**Sinh viên thực hiện:** Nguyễn Việt Quang - 2380601811
