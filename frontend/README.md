# péče School Management System

A comprehensive school management system built with Flutter, featuring user authentication, teacher dashboard, student/parent dashboard, and more.

## DynamoDB Integration

This application can use DynamoDB Local for data storage. Follow these instructions to set up and run the application with DynamoDB Local.

### Prerequisites

- Java Runtime Environment (JRE) 8 or higher
- Python 3.6+ with boto3 package (for running setup scripts)
- Flutter SDK

### Setting up DynamoDB Local

1. DynamoDB Local files should be located at `C:\Users\aakar\DynamoDbLocal`
2. Start DynamoDB Local by running the following script:
   ```
   .\scripts\start_dynamodb.bat
   ```
   This will start DynamoDB Local on port 8000.

3. Initialize DynamoDB tables by running:
   ```
   .\scripts\init_dynamodb.bat
   ```
   This will create the necessary tables and populate them with demo data.

### Running the Application

Once DynamoDB Local is running, you can start the Flutter application:

```
flutter run
```

The app will automatically connect to DynamoDB Local on startup if it's running.

### Demo Credentials

#### Teacher Login
- Username: teacher
- Password: password

#### Student/Parent Login
- Username: student (or parent)
- Password: password

### Fallback Mode

If DynamoDB Local is not running, the app will automatically fall back to demo mode with hardcoded data.

## DynamoDB Schema

The application uses the following tables:

1. **Users**: Stores user authentication information
   - Primary Key: username (String)
   - Additional fields: password, userType, userId

2. **Teachers**: Stores teacher information
   - Primary Key: teacherId (String)
   - Additional fields: name, email, phone, joinDate, education, experience, bio, employeeId, classesAssigned

3. **Students**: Stores student information
   - Primary Key: studentId (String)
   - Additional fields: name, grade, parentName, parentId, address, phone, email, enrollmentDate

4. **Classes**: Stores class information
   - Primary Key: classId (String)
   - Additional fields: subject, teacher, teacherId, grade, timeSlot, description, students, nextHomework

5. **Attendance**: Stores attendance records
   - Primary Key: attendanceId (String, format: `studentId_date`)
   - Additional fields: studentId, classId, date, status, remarks

6. **Notifications**: Stores notifications
   - Primary Key: notificationId (String, timestamp)
   - Additional fields: title, message, type, timestamp, sender, recipients

## Application Features

- Teacher Dashboard
- Student/Parent Dashboard
- Class Management
- Attendance Tracking
- Calendar and Schedule
- Notifications
- User Profile Management
