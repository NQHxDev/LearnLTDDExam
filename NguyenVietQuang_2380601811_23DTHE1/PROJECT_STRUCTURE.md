# 📂 CẤU TRÚC PROJECT - CHILD DEVICES MANAGEMENT API

## 📁 Root Files

\\\
NguyenVietQuang_2380601811_23DTHE1/
│
├── Program.cs                                    # Application entry point
├── appsettings.json                             # Production configuration
├── appsettings.Development.json                 # Development configuration
├── NguyenVietQuang_2380601811_23DTHE1.csproj   # Project file
├── NguyenVietQuang_2380601811_23DTHE1.sln      # Solution file
├── .gitignore                                   # Git ignore rules
├── start.bat                                    # Quick start script
│
├── README.md                                    # Main documentation
├── QUICK_START.md                               # Quick start guide
├── API_TESTING_GUIDE.md                         # API testing guide
├── PROJECT_INFO.md                              # Project information
└── SUMMARY.md                                   # Project summary
\\\

## 📁 Controllers/ (API Endpoints)

\\\
Controllers/
├── AuthController.cs           # Authentication endpoints (3)
│   ├── POST   /api/auth/register
│   ├── POST   /api/auth/login
│   └── GET    /api/auth/me
│
├── DevicesController.cs        # Device management endpoints (5)
│   ├── GET    /api/devices
│   ├── GET    /api/devices/{id}
│   ├── POST   /api/devices              [Admin]
│   ├── PUT    /api/devices/{id}         [Admin]
│   └── DELETE /api/devices/{id}         [Admin]
│
├── OrdersController.cs         # Order management endpoints (5)
│   ├── GET    /api/orders               [Auth]
│   ├── GET    /api/orders/{id}          [Auth]
│   ├── POST   /api/orders               [Auth]
│   ├── PATCH  /api/orders/{id}/status   [Admin]
│   └── POST   /api/orders/{id}/cancel   [Auth]
│
└── ReviewsController.cs        # Review management endpoints (5)
    ├── GET    /api/reviews
    ├── GET    /api/reviews/{id}
    ├── POST   /api/reviews              [Auth]
    ├── PUT    /api/reviews/{id}         [Auth]
    └── DELETE /api/reviews/{id}         [Auth]
\\\

**Total: 18 API Endpoints**

## 📁 Models/ (Domain Entities)

\\\
Models/
├── User.cs           # User entity
│   ├── Properties: Id, Username, Email, PasswordHash, FullName, PhoneNumber, Role
│   ├── Enum: UserRole (User, Admin)
│   └── Relations: 1:N with Devices
│
├── Device.cs         # Device entity
│   ├── Properties: Id, Name, Description, Category, Price, Brand, ModelNumber
│   ├── Properties: ImageUrl, StockQuantity, MinAge, MaxAge, IsAvailable
│   ├── Enum: DeviceCategory (EducationalToy, ElectronicDevice, SafetyDevice, Monitor, SmartWatch, Tablet, Other)
│   └── Relations: N:1 User, 1:N Reviews, 1:N OrderItems
│
├── Order.cs          # Order entity
│   ├── Properties: Id, OrderNumber, UserId, TotalAmount, Status
│   ├── Properties: ShippingAddress, PhoneNumber, Notes
│   ├── Enum: OrderStatus (Pending, Confirmed, Processing, Shipping, Delivered, Cancelled)
│   └── Relations: N:1 User, 1:N OrderItems
│
├── OrderItem.cs      # Order item entity
│   ├── Properties: Id, OrderId, DeviceId, Quantity, UnitPrice, TotalPrice
│   └── Relations: N:1 Order, N:1 Device
│
└── Review.cs         # Review entity
    ├── Properties: Id, UserId, DeviceId, Rating, Comment
    └── Relations: N:1 User, N:1 Device
\\\

## 📁 DTOs/ (Data Transfer Objects)

\\\
DTOs/
├── AuthDtos.cs       # Authentication DTOs
│   ├── LoginDto
│   ├── RegisterDto
│   ├── UserDto
│   └── AuthResponseDto
│
├── DeviceDtos.cs     # Device DTOs
│   ├── DeviceDto
│   ├── CreateDeviceDto
│   └── UpdateDeviceDto
│
├── OrderDtos.cs      # Order DTOs
│   ├── OrderDto
│   ├── OrderItemDto
│   ├── CreateOrderDto
│   ├── CreateOrderItemDto
│   └── UpdateOrderStatusDto
│
└── ReviewDtos.cs     # Review DTOs
    ├── ReviewDto
    ├── CreateReviewDto
    └── UpdateReviewDto
\\\

## 📁 Services/ (Business Logic)

\\\
Services/
├── AuthService.cs        # Authentication service
│   ├── RegisterAsync()
│   ├── LoginAsync()
│   └── GetUserByIdAsync()
│
├── DeviceService.cs      # Device service
│   ├── GetDevicesAsync()         (with pagination & filters)
│   ├── GetDeviceByIdAsync()
│   ├── CreateDeviceAsync()
│   ├── UpdateDeviceAsync()
│   └── DeleteDeviceAsync()
│
├── OrderService.cs       # Order service
│   ├── GetOrdersAsync()          (with pagination & filters)
│   ├── GetOrderByIdAsync()
│   ├── CreateOrderAsync()        (with transaction & stock management)
│   ├── UpdateOrderStatusAsync()
│   └── CancelOrderAsync()        (with stock restoration)
│
└── ReviewService.cs      # Review service
    ├── GetReviewsAsync()         (with pagination & filters)
    ├── GetReviewByIdAsync()
    ├── CreateReviewAsync()
    ├── UpdateReviewAsync()
    └── DeleteReviewAsync()
\\\

## 📁 Data/ (Data Access Layer)

\\\
Data/
└── ApplicationDbContext.cs    # EF Core DbContext
    ├── DbSets: Users, Devices, Orders, OrderItems, Reviews
    ├── OnModelCreating(): Entity configurations
    └── SeedData(): Initial data (1 admin + 5 devices)
\\\

## 📁 Helpers/ (Utilities)

\\\
Helpers/
├── ApiResponse.cs      # Standard API response wrapper
│   ├── ApiResponse<T>
│   └── PagedResponse<T>
│
└── JwtHelper.cs        # JWT token helper
    ├── GenerateToken()
    ├── GetUserIdFromToken()
    └── GetUserRole()
\\\

## 📁 Middleware/

\\\
Middleware/
└── ErrorHandlingMiddleware.cs    # Global error handler
    └── HandleExceptionAsync()
\\\

## 📁 Migrations/ (EF Core Migrations)

\\\
Migrations/
├── 20261029061126_InitialCreate.cs
├── 20261029061126_InitialCreate.Designer.cs
├── <timestamp>_UpdateModels.cs
├── <timestamp>_UpdateModels.Designer.cs
├── <timestamp>_ApplyPendingChanges.cs
├── <timestamp>_ApplyPendingChanges.Designer.cs
└── ApplicationDbContextModelSnapshot.cs
\\\

## 📊 Statistics

### Files Count
- **Controllers:** 4 files
- **Models:** 5 files
- **DTOs:** 4 files
- **Services:** 4 files
- **Data:** 1 file
- **Helpers:** 2 files
- **Middleware:** 1 file
- **Documentation:** 5 markdown files
- **Config:** 3 files (Program.cs, appsettings.json, .csproj)

**Total Source Files:** 29 files

### Lines of Code (Estimated)
- Controllers: ~800 lines
- Models: ~250 lines
- DTOs: ~200 lines
- Services: ~1000 lines
- Data: ~250 lines
- Helpers: ~150 lines
- Middleware: ~50 lines
- Program.cs: ~100 lines

**Total LOC:** ~2800+ lines

### API Endpoints
- Auth: 3 endpoints
- Devices: 5 endpoints
- Orders: 5 endpoints
- Reviews: 5 endpoints

**Total:** 18 endpoints

### Database Tables
- Users
- Devices
- Orders
- OrderItems
- Reviews

**Total:** 5 tables

---

## 🎯 Features Summary

✅ Authentication & Authorization (JWT)
✅ Device Management (CRUD + Search + Filter)
✅ Order Management (with Stock Control)
✅ Review System (Rating + Comments)
✅ Clean Architecture
✅ Error Handling
✅ API Documentation (Swagger)
✅ Data Seeding
✅ Pagination
✅ Role-based Access Control

---

**© 2024 Nguyễn Việt Quang - 2380601811 - 23DTHE1**
