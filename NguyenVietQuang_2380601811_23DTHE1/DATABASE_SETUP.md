# ⚠️ LƯU Ý VỀ DATABASE

## Vấn đề LocalDB

Nếu gặp lỗi khi chạy dotnet ef database update, đây là vấn đề với SQL Server LocalDB trên máy của bạn.

## ✅ Giải pháp

### Cách 1: Để ứng dụng tự động tạo database (Khuyến nghị)

Chỉ cần chạy ứng dụng:

\\\ash
dotnet run
\\\

Database sẽ **TỰ ĐỘNG** được tạo khi ứng dụng khởi động nhờ đoạn code trong Program.cs:

\\\csharp
// Auto-migrate database on startup
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    dbContext.Database.Migrate();
}
\\\

### Cách 2: Sử dụng SQL Server thật

Nếu bạn có SQL Server đầy đủ, sửa connection string trong ppsettings.json:

\\\json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=ChildDevicesDB;User Id=sa;Password=YourPassword;TrustServerCertificate=true;Encrypt=false"
  }
}
\\\

### Cách 3: Sửa LocalDB (Nâng cao)

Nếu muốn sửa LocalDB:

\\\ash
# Delete LocalDB instance
sqllocaldb delete mssqllocaldb

# Create new instance
sqllocaldb create mssqllocaldb

# Start instance
sqllocaldb start mssqllocaldb
\\\

## 🎯 Khuyến nghị

**Sử dụng Cách 1** - Đơn giản nhất, chỉ cần:

1. Chạy: dotnet run
2. Database tự động tạo
3. Sample data tự động seed
4. Mở Swagger UI và test

## ✅ Xác nhận Database đã tạo

Khi ứng dụng chạy, bạn sẽ thấy log:

\\\
Database migrated successfully
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5057
\\\

Nếu thấy dòng "Database migrated successfully" = Database đã OK!

## 🧪 Test

Sau khi app chạy:
1. Mở Swagger UI (https://localhost:xxxx)
2. Login với admin/Admin@123
3. Test các endpoints

Nếu login thành công = Database hoạt động tốt!

---

**Lưu ý:** Migration sẽ tự động chạy mỗi lần khởi động ứng dụng, không cần chạy dotnet ef database update thủ công.
