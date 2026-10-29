# 🚀 HƯỚNG DẪN CHẠY NHANH

## Bước 1: Kiểm tra yêu cầu hệ thống

Đảm bảo bạn đã cài đặt:
- ✅ .NET 9.0 SDK
- ✅ SQL Server hoặc SQL Server LocalDB

Kiểm tra:
\\\ash
dotnet --version
# Phải là 9.0.x trở lên
\\\

## Bước 2: Build project

\\\ash
dotnet build
\\\

## Bước 3: Chạy ứng dụng

### Cách 1: Dùng command line
\\\ash
dotnet run
\\\

### Cách 2: Double-click file
\\\
start.bat
\\\

### Cách 3: Visual Studio
- Mở file .sln
- Nhấn F5 hoặc click Run

## Bước 4: Mở Swagger UI

Sau khi app chạy, mở browser:
\\\
https://localhost:xxxx
\\\
(Port number sẽ hiển thị trong console)

## Bước 5: Test API

### 1. Login để lấy token
Trong Swagger UI:
- Tìm endpoint \POST /api/auth/login\
- Click "Try it out"
- Nhập:
  \\\json
  {
    "username": "admin",
    "password": "Admin@123"
  }
  \\\
- Click "Execute"
- Copy token từ response

### 2. Authorize
- Click nút "Authorize" ở góc trên
- Nhập: \Bearer <token_vừa_copy>\
- Click "Authorize"

### 3. Test các endpoints khác
Giờ bạn có thể test tất cả API endpoints!

## Các endpoints phổ biến để test:

### 📱 Xem danh sách thiết bị
\\\
GET /api/devices
\\\

### 🛒 Tạo đơn hàng mới
\\\
POST /api/orders
{
  "shippingAddress": "123 Test Street",
  "phoneNumber": "0123456789",
  "items": [
    {
      "deviceId": 1,
      "quantity": 1
    }
  ]
}
\\\

### ⭐ Đánh giá sản phẩm
\\\
POST /api/reviews
{
  "deviceId": 1,
  "rating": 5,
  "comment": "Excellent!"
}
\\\

## Lưu ý:

### Database
- Database sẽ tự động được tạo khi chạy lần đầu
- Sample data (admin account + 5 devices) được tự động seed

### Nếu gặp lỗi Connection String
Sửa file \ppsettings.json\:
\\\json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=ChildDevicesDB;Trusted_Connection=true;TrustServerCertificate=true"
  }
}
\\\

Hoặc dùng SQL Server thật:
\\\json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=ChildDevicesDB;User Id=sa;Password=YourPassword;TrustServerCertificate=true"
  }
}
\\\

### Nếu gặp lỗi migration
\\\ash
# Xóa database cũ
dotnet ef database drop --force

# Update lại
dotnet ef database update
\\\

## Tài khoản test

### Admin Account
- Username: \dmin\
- Password: \Admin@123\
- Role: Admin (full access)

### Tạo User Account
Dùng endpoint \POST /api/auth/register\:
\\\json
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "Test@123",
  "fullName": "Test User"
}
\\\

## Thư mục quan trọng

- \README.md\ - Documentation đầy đủ
- \API_TESTING_GUIDE.md\ - Hướng dẫn test chi tiết
- \PROJECT_INFO.md\ - Thông tin dự án
- \SUMMARY.md\ - Tổng kết

## Help!

Nếu cần trợ giúp:
1. Đọc README.md
2. Đọc phần Troubleshooting
3. Check logs trong console

---

**Happy coding! 🎉**
