@echo off
echo Starting DynamoDB Local...
cd /d "C:\Users\aakar\DynamoDbLocal"
java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb

echo DynamoDB Local started successfully!
echo Endpoint: http://localhost:8000
echo.
echo Press Ctrl+C to stop DynamoDB Local 