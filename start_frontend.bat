@echo off
echo ==========================================
echo   Starting péče School Management Frontend
echo ==========================================
echo.

echo Navigating to frontend directory...
cd frontend

echo Installing Flutter dependencies...
flutter pub get

echo.
echo Starting Flutter Application...
echo Make sure the backend is running at http://localhost:3000
echo.

flutter run -d windows

pause 