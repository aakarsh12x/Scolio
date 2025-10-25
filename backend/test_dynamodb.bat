@echo off
echo Starting DynamoDB Local and running tests...

:: Check if DynamoDB Local is already running
netstat -ano | findstr :8000 > nul
if %errorlevel% equ 0 (
    echo DynamoDB Local is already running on port 8000
) else (
    echo Starting DynamoDB Local...
    start "DynamoDB Local" cmd /c "cd scripts && start_dynamodb.bat"
    echo Waiting for DynamoDB Local to start...
    timeout /t 5 /nobreak > nul
)

:: Run the test script
echo Running backend tests...
node src/scripts/testBackend.js

echo Test completed.
pause 