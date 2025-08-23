@echo off
echo ========================================
echo SMS Service Management System Setup
echo ========================================
echo.

echo Checking prerequisites...
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
) else (
    echo ✅ Node.js is installed
)

REM Check if PHP is installed
php --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP is not installed. Please install PHP from https://www.php.net/downloads/
    pause
    exit /b 1
) else (
    echo ✅ PHP is installed
)

REM Check if Composer is installed
composer --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Composer is not installed. Please install Composer from https://getcomposer.org/download/
    pause
    exit /b 1
) else (
    echo ✅ Composer is installed
)

echo.
echo All prerequisites are installed!
echo.

echo Setting up React Frontend...
cd newsms
echo Installing npm dependencies...
npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install npm dependencies
    pause
    exit /b 1
)
echo ✅ React frontend setup complete
cd ..

echo.
echo Setting up Laravel Backend...
cd laravel-backend
echo Installing Composer dependencies...
composer install
if %errorlevel% neq 0 (
    echo ❌ Failed to install Composer dependencies
    pause
    exit /b 1
)

echo Copying environment file...
if not exist .env (
    copy env.example .env
    echo ✅ Environment file created
) else (
    echo ✅ Environment file already exists
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Configure your database in laravel-backend/.env
echo 2. Run: cd laravel-backend && php artisan key:generate
echo 3. Run: cd laravel-backend && php artisan migrate
echo 4. Start Laravel: cd laravel-backend && php artisan serve
echo 5. Start React: cd newsms && npm run dev
echo.
echo Laravel API will run on: http://localhost:8000
echo React app will run on: http://localhost:5173
echo.
pause
