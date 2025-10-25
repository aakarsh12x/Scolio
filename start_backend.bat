@echo off
echo ==========================================
echo   Starting péče School Management Backend
echo ==========================================
echo.

echo Starting DynamoDB Local...
cd backend
start "DynamoDB Local" cmd /k "start_dynamodb.bat"

echo Waiting for DynamoDB to start...
timeout /t 5 /nobreak >nul

echo.
echo Starting Node.js Backend Server...
echo Backend API will be available at: http://localhost:3000
echo Health check: http://localhost:3000/health
echo.

node src/index.js

pause 