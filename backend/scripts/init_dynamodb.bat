@echo off
echo Initializing DynamoDB tables...

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed or not in PATH. Please install Python and try again.
    exit /b 1
)

REM Check if boto3 is installed
python -c "import boto3" >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing boto3...
    pip install boto3
)

REM Run the Python script to create tables and insert data
cd /d "%~dp0"
python create_dynamo_tables.py

echo.
echo DynamoDB initialization completed!
echo.
pause 