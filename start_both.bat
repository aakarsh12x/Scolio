@echo off
echo ==========================================
echo   Starting péče School Management System
echo ==========================================
echo.

echo Starting Backend Server...
start "Backend Server" cmd /k "start_backend.bat"

echo Waiting for backend to initialize...
timeout /t 10 /nobreak >nul

echo.
echo Starting Frontend Application...
start "Frontend App" cmd /k "start_frontend.bat"

echo.
echo ==========================================
echo   Both Backend and Frontend are starting
echo ==========================================
echo   Backend API: http://localhost:3000
echo   Frontend: Will open in Flutter window
echo ==========================================
echo.

pause 