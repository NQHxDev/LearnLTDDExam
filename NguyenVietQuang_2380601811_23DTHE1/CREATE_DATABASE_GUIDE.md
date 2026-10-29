# HƯỚNG DẪN TẠO DATABASE

## Cách 1: Tạo Database trong SSMS (Đơn giản nhất)

### Bước 1: Mở SQL Server Management Studio
1. Kết nối với server: (local)
2. Authentication: Windows Authentication

### Bước 2: Tạo Database
1. Chuột phải vào Databases → New Database
2. Database name: ChildDevicesDB
3. Click OK

### Bước 3: Chạy Migration
Quay lại terminal và chạy:
```
dotnet ef database update
```

## Cách 2: Sử dụng Script SQL

Copy và chạy script này trong SSMS:

```sql
CREATE DATABASE ChildDevicesDB;
GO

USE ChildDevicesDB;
GO
```

Sau đó chạy migration:
```
dotnet ef database update
```

## Cách 3: Để app tự tạo (Đã config sẵn)

Chỉ cần:
1. Tạo database trống tên "ChildDevicesDB" trong SSMS
2. Chạy: dotnet run
3. App sẽ tự động tạo tables và seed data

## Kiểm tra kết nối

Test connection string bằng cách chạy:
```
dotnet ef dbcontext info
```

Nếu thành công, bạn sẽ thấy thông tin về DbContext.
