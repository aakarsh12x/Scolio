@echo off
echo ====================================================
echo  péče School Management System with DynamoDB Local
echo ====================================================
echo.

echo Step 1: Starting DynamoDB Local...
start cmd /k "cd /d C:\Users\aakar\DynamoDbLocal && java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb"

echo Waiting for DynamoDB Local to start...
timeout /t 5 /nobreak >nul

echo.
echo Step 2: Initializing DynamoDB tables...
cd scripts
call init_dynamodb.bat
cd ..

echo.
echo Step 3: Starting Flutter application...
echo.
echo Application is ready to use with the following credentials:
echo.
echo Teacher Login:
echo Username: teacher
echo Password: password
echo.
echo Student/Parent Login:
echo Username: student or parent
echo Password: password
echo.
echo Press any key to start the Flutter application...
pause >nul

flutter run

echo.
echo Application closed. DynamoDB Local is still running in the background.
echo To stop DynamoDB Local, close its command prompt window.
echo.
pause 