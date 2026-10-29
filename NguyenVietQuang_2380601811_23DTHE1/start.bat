@echo off
echo ============================================
echo   CHILD DEVICES MANAGEMENT API
echo   Nguyen Viet Quang - 2380601811
echo ============================================
echo.
echo [1/3] Checking .NET SDK...
dotnet --version
echo.
echo [2/3] Building project...
dotnet build --verbosity quiet
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)
echo.
echo [3/3] Starting application...
echo.
echo Swagger UI will be available at: https://localhost:xxxx
echo.
echo Press Ctrl+C to stop the application
echo.
dotnet run
