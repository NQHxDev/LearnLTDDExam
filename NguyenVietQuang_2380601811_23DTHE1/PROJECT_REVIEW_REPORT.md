# BÁO CÁO REVIEW TOÀN BỘ PROJECT

**Ngày review:** 29/10/2026  
**Backend:** ASP.NET Core Web API .NET 9 + EF Core + SQL Server  
**Frontend:** Flutter  
**Phạm vi:** Kiểm tra cấu trúc, compile/build, cấu hình kết nối, authentication, CRUD, email và LiveKit.

---

## 1. KẾT LUẬN TỔNG QUAN

Project hiện đã có nền tảng hoạt động và đã từng chạy thành công với SQL Server. Backend có thể:

- Đăng ký và đăng nhập bằng JWT.
- Trả về thông tin user hiện tại qua `/api/Auth/me`.
- Phân quyền Admin/User.
- CRUD thiết bị ở mức cơ bản.
- Quản lý order và review.
- Có Flutter client với API client, lưu token, login/register và danh sách thiết bị.

Tuy nhiên project **chưa nên gọi là production-ready**. Có một số lỗi và rủi ro cần xử lý trước khi demo chính thức hoặc deploy công khai.

**Đánh giá hiện tại:**

- Backend core: **Khá tốt, khoảng 75-80%**.
- Flutter integration: **MVP, khoảng 55-65%**.
- LiveKit: **Chưa phải tích hợp production thật**.
- Security/configuration: **Cần sửa ngay**.

---

## 2. CÁC LỖI NGHIÊM TRỌNG CẦN SỬA

### 2.1. API key Resend đang hardcode và đã bị lộ

`appsettings.json` và `appsettings.Development.json` đang chứa API key Resend thật.

Rủi ro:

- API key có thể bị commit lên Git.
- Người khác có thể sử dụng quota gửi email của bạn.
- Key đã xuất hiện trong lịch sử trao đổi và nên được rotate.

**Cần sửa:**

1. Rotate/revoke key cũ trong Resend Dashboard.
2. Xóa key thật khỏi `appsettings.json`.
3. Dùng User Secrets hoặc Environment Variables.

Ví dụ:

```powershell
dotnet user-secrets init
dotnet user-secrets set "Resend:ApiKey" "NEW_KEY"
```

---

### 2.2. JWT secret đang hardcode

`Jwt:Key` hiện nằm trực tiếp trong appsettings. Đây là secret dùng để ký toàn bộ JWT.

**Cần sửa:**

```powershell
dotnet user-secrets set "Jwt:Key" "a-long-random-production-secret"
```

Không dùng key mẫu khi deploy.

---

### 2.3. Seed data dùng `DateTime.UtcNow` trong `OnModelCreating`

`ApplicationDbContext` dùng `DateTime.UtcNow` trong `HasData` cho `CreatedAt`. Đây là nguyên nhân phổ biến gây:

```text
PendingModelChangesWarning
```

Mỗi lần EF build model, thời gian seed thay đổi nên EF nhận diện model mới dù code nghiệp vụ không đổi.

**Cần sửa:** dùng timestamp cố định trong seed hoặc seed admin/device bằng code startup riêng.

Ví dụ:

```csharp
private static readonly DateTime SeedDate =
    new DateTime(2026, 10, 29, 0, 0, 0, DateTimeKind.Utc);
```

Sau đó thay toàn bộ `DateTime.UtcNow` trong `HasData` bằng `SeedDate`.

Không nên suppress warning bằng `ConfigureWarnings` để che lỗi model drift.

---

### 2.4. Các migration dư thừa và khó kiểm soát

Thư mục `Migrations` có nhiều migration được tạo liên tiếp để xử lý pending changes:

- `InitialCreate`
- `UpdateModels`
- `ApplyPendingChanges`
- `FixDatabase`
- `FinalMigration`

Điều này khiến lịch sử migration khó đọc và có thể gây lỗi khi đưa project sang máy/database mới.

**Khuyến nghị:**

- Giữ các migration đã apply nếu database đang dùng.
- Không xóa migration đã chạy trên database production.
- Sau khi cố định seed date, tạo migration sạch tiếp theo.
- Với project học tập và database có thể tạo lại, có thể reset migration/database một lần rồi tạo `InitialCreate` sạch.

---

## 3. BACKEND REVIEW

### 3.1. Program.cs

Đã làm đúng:

- Đăng ký DbContext.
- JWT authentication.
- DI services.
- Swagger.
- CORS.
- Auto migration.

Cần cải thiện:

- `AllowAll` không phù hợp production.
- `UseHttpsRedirection()` nhưng Flutter development đang gọi HTTP.
- Auto migration trong startup nên dùng cẩn thận khi nhiều instance deploy cùng lúc.
- Không nên log hoặc trả exception chi tiết ở production.

CORS production nên giới hạn:

```csharp
policy.WithOrigins(
    "https://zeion.online",
    "https://www.zeion.online"
)
.AllowAnyHeader()
.AllowAnyMethod();
```

---

### 3.2. Authentication

Đã hoạt động:

- Login admin.
- `/api/Auth/me`.
- JWT role `Admin`.
- `[Authorize(Roles = "Admin")]` cho POST/PUT/DELETE device.

Thiếu:

- Validation độ dài password.
- Email format validation.
- Lockout sau nhiều lần login sai.
- Refresh token.
- OTP.
- OAuth Google.
- Password reset endpoint thực tế.

Một lỗi thiết kế đáng chú ý: welcome email được gọi trực tiếp trong `RegisterAsync`. Service hiện bắt lỗi và trả `false`, nên không làm register fail; đây là chấp nhận được cho demo nhưng production nên dùng background queue/outbox.

---

### 3.3. CRUD Devices

Đã có:

- GET danh sách.
- GET theo ID.
- POST Admin.
- PUT Admin.
- DELETE Admin.
- Pagination và filter cơ bản.

Cần bổ sung validation rõ ràng:

- `Name` không rỗng.
- `Price >= 0`.
- `StockQuantity >= 0`.
- `MinAge >= 0`.
- `MaxAge >= MinAge`.
- Category hợp lệ.

Hiện một số DTO chưa có DataAnnotations nên nhiều dữ liệu không hợp lệ chỉ được phát hiện ở service hoặc có thể lọt qua.

---

### 3.4. Orders

Đã có logic inventory và transaction. Tuy nhiên cần kiểm tra thêm:

- Quantity phải lớn hơn 0.
- Không cho phép duplicate cùng `DeviceId` trong một order hoặc phải gộp item.
- Update status nên giới hạn transition hợp lệ.
- Cần chống race condition khi hai request cùng mua item cuối cùng.
- Gửi email sau commit transaction, không gửi trước commit.

---

### 3.5. Reviews

Đã có unique constraint cho một user/device. Cần bổ sung:

- Kiểm tra user đã mua thiết bị trước khi review nếu nghiệp vụ yêu cầu.
- Validation comment length.
- Không trả lỗi `Forbid()` một cách thiếu message chi tiết nếu frontend cần hiển thị.

---

## 4. LIVEKIT REVIEW

`LiveKitService` hiện chưa phải LiveKit integration đầy đủ.

Nó đang:

- Tự tạo JWT token.
- Lưu room trong `Dictionary` memory.
- Trả danh sách participant rỗng.
- Không gọi LiveKit RoomService API.
- Mất toàn bộ room khi backend restart.

Ngoài ra `appsettings.Development.json` đang dùng:

```json
"ApiKey": "devkey",
"ApiSecret": "devsecret",
"WsUrl": "ws://localhost:7880"
```

Nếu chưa có LiveKit server chạy tại port 7880, Flutter sẽ không thể video call.

**Kết luận:** LiveKit hiện chỉ là prototype token/room flow, chưa phải video call production.

Cần làm tiếp:

1. Tạo LiveKit Cloud project hoặc chạy server thật.
2. Lấy API key, secret và `wss://...` URL.
3. Tích hợp RoomService API.
4. Flutter thêm package LiveKit client.
5. Test camera/microphone permission.
6. Test hai thiết bị cùng join một room.

---

## 5. RESEND REVIEW

Đã có:

- Gọi REST API Resend.
- Welcome email.
- Order confirmation email.
- Shipping email service.
- Password reset email service mẫu.

Chưa hoàn thành:

- Verify domain `zeion.online`.
- DNS SPF/DKIM/DMARC.
- Rotate API key.
- Background queue.
- Retry policy chuyên biệt cho email.
- Lưu message ID để tracking.

Nếu domain chưa được verify, email từ `noreply@zeion.online` có thể không gửi được.

---

## 6. FLUTTER REVIEW

Flutter project đã có các phần chính:

- `config/app_config.dart`
- `services/api_client.dart`
- `services/auth_service.dart`
- `services/device_service.dart`
- `services/storage_service.dart`
- Auth/device controllers.
- Login/register/home/device screens.

### Lỗi/rủi ro phát hiện

#### 6.1. API URL đang cố định IP LAN

`lib/config/app_config.dart` đang dùng:

```dart
http://192.168.1.110:5057/api
```

IP LAN có thể thay đổi. Cần tách cấu hình theo môi trường:

- Android emulator: `http://10.0.2.2:5057/api`
- Web/Windows: `http://localhost:5057/api`
- Điện thoại thật: IP LAN hiện tại của máy backend.

#### 6.2. Chưa thấy màn hình Splash được sử dụng

Có file `splash_screen.dart`, nhưng `main.dart` đang tự kiểm tra session và không điều hướng qua Splash screen. Đây không phải lỗi compile nhưng cấu trúc đang không thống nhất.

#### 6.3. Chưa có order/review frontend

Flutter mới tích hợp chủ yếu:

- Login.
- Register.
- Auth/me.
- Device list.
- Device create/delete cơ bản.

Chưa có màn hình:

- Order list/detail/create/cancel.
- Review create/update/delete.
- Video call.
- Profile editing.
- Location tracking.

#### 6.4. Chưa có xử lý refresh token

Khi JWT hết hạn, API client chỉ báo lỗi 401. Chưa có refresh token hoặc tự đưa người dùng về Login.

#### 6.5. Chưa đủ kiểm thử Flutter

Chưa có integration test gọi backend thật. `widget_test.dart` mặc định của project mới có thể không còn phù hợp sau khi thay đổi UI.

#### 6.6. Android cleartext

`usesCleartextTraffic="true"` đã được bật trong activity. Với development HTTP thì cần thiết, nhưng production phải dùng HTTPS và bỏ cấu hình này hoặc giới hạn network security config.

---

## 7. VẤN ĐỀ BUILD/TOOLING

Backend từng build thành công nhưng build output mặc định bị lỗi file khóa khi app đang chạy:

```text
The process cannot access ... apphost.exe because it is being used by another process
```

Cách xử lý:

```powershell
# Dừng app đang chạy trước khi build
Get-Process dotnet -ErrorAction SilentlyContinue | Stop-Process -Force

# Sau đó build
 dotnet build
```

Flutter analysis trong môi trường review không hoàn tất do tiến trình bị treo/timeout; cần chạy trực tiếp trong thư mục Flutter:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

---

## 8. DANH SÁCH ƯU TIÊN SỬA

### Mức P0 - Sửa ngay

- [ ] Rotate Resend API key.
- [ ] Di chuyển Resend key/JWT key/LiveKit secret ra User Secrets hoặc environment variables.
- [ ] Cố định `DateTime` trong EF seed data.
- [ ] Test lại `dotnet ef database update` sau khi sửa seed.
- [ ] Kiểm tra database và migrations từ database sạch.

### Mức P1 - Trước khi demo đầy đủ

- [ ] Thêm validation DTO.
- [ ] Sửa API URL Flutter theo environment.
- [ ] Chạy `flutter analyze` và `flutter test`.
- [ ] Thêm order API vào Flutter.
- [ ] Thêm review API vào Flutter.
- [ ] Xác nhận POST/PUT/DELETE bằng token Admin mới.
- [ ] Test từ Android emulator hoặc điện thoại thật.

### Mức P2 - Trước production

- [ ] LiveKit Cloud/server thật.
- [ ] LiveKit RoomService API.
- [ ] HTTPS cho API.
- [ ] CORS whitelist.
- [ ] OTP/OAuth.
- [ ] Rate limiting.
- [ ] Logging structured.
- [ ] Unit/integration tests.
- [ ] CI/CD.

---

## 9. TEST MATRIX ĐỀ XUẤT

| Nhóm | Test | Kết quả cần đạt |
|---|---|---|
| Health | `GET /api/Health` | 200 |
| Auth | Register | 200 và có token |
| Auth | Login admin | 200, role Admin |
| Auth | `/api/Auth/me` | 200 |
| Device | GET devices | 200, có items |
| Device | POST bằng User | 403 |
| Device | POST bằng Admin | 201 |
| Device | PUT bằng Admin | 200 |
| Device | DELETE bằng Admin | 200 |
| Order | Create order | 201, stock giảm |
| Order | Cancel order | 200, stock phục hồi |
| Review | Create review | 201 |
| Review | Duplicate review | 400 |
| Email | Register email | Resend message thành công |
| LiveKit | Create room | Room thật được tạo |
| LiveKit | Join from two clients | Hai client nhìn/nghe được nhau |
| Flutter | Login | Điều hướng Home |
| Flutter | Device list | Hiển thị devices từ backend |
| Flutter | Admin create device | 201 |

---

## 10. KẾT LUẬN

Project hiện đã có nền tảng tốt để demo backend và Flutter MVP. Các luồng đã xác nhận trước đó gồm database connection, login, `/api/Auth/me` và role Admin.

Tuy nhiên cần xử lý ngay secret hardcode và EF seed time động. Sau đó cần chạy đầy đủ `dotnet build`, `dotnet ef database update`, `flutter analyze`, `flutter test` và test trên thiết bị thật.

LiveKit hiện chỉ nên mô tả là **prototype integration**, chưa nên mô tả là video call production hoàn chỉnh.

**Trạng thái tổng thể:** `MVP hoạt động, cần hardening trước production.`
