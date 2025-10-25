# péče School Management System - JavaScript Backend Plan

## 🏗️ Architecture Overview

### **Technology Stack**
- **Runtime**: Node.js with Express.js
- **Database**: 
  - **Production**: PostgreSQL with Sequelize ORM
  - **Development**: DynamoDB Local (existing setup)
- **File Storage**: Local storage with multer
- **Real-time**: Socket.io for notifications
- **API Documentation**: Swagger/OpenAPI
- **Validation**: Joi or express-validator
- **Testing**: Jest + Supertest
- **Deployment**: PM2 (no Docker dependency)

## 📊 Database Schema Design

### **PostgreSQL Tables (Production)**

### **User Management**
```sql
-- Users Table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('teacher', 'student', 'parent', 'admin')),
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  phone VARCHAR(20),
  avatar_url TEXT,
  address JSONB,
  is_active BOOLEAN DEFAULT true,
  last_login TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **DynamoDB Schema (Development)**
```javascript
// User Schema (DynamoDB Local)
{
  username: String (primary key),
  email: String,
  userType: String (enum: ['teacher', 'student', 'parent', 'admin']),
  profile: {
    firstName: String,
    lastName: String,
    phone: String,
    avatar: String,
    address: Object
  },
  isActive: Boolean,
  lastLogin: Date,
  createdAt: Date,
  updatedAt: Date
}
```

### **Academic Management**

```sql
-- Teachers Table (PostgreSQL)
CREATE TABLE teachers (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  employee_id VARCHAR(20) UNIQUE NOT NULL,
  subjects TEXT[],
  qualification TEXT,
  experience INTEGER,
  join_date DATE,
  bio TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Students Table (PostgreSQL)
CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  student_id VARCHAR(20) UNIQUE NOT NULL,
  roll_number VARCHAR(20),
  grade VARCHAR(20),
  section VARCHAR(10),
  admission_date DATE,
  parent_id INTEGER REFERENCES parents(id),
  academic_year VARCHAR(10),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Parents Table (PostgreSQL)
CREATE TABLE parents (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  relationship VARCHAR(20),
  occupation VARCHAR(100),
  emergency_contact JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Classes Table (PostgreSQL)
CREATE TABLE classes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  grade VARCHAR(20),
  section VARCHAR(10),
  class_teacher_id INTEGER REFERENCES teachers(id),
  academic_year VARCHAR(10),
  max_students INTEGER DEFAULT 40,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Class Students Junction Table
CREATE TABLE class_students (
  class_id INTEGER REFERENCES classes(id),
  student_id INTEGER REFERENCES students(id),
  PRIMARY KEY (class_id, student_id)
);

-- Class Subjects Table
CREATE TABLE class_subjects (
  id SERIAL PRIMARY KEY,
  class_id INTEGER REFERENCES classes(id),
  subject VARCHAR(50),
  teacher_id INTEGER REFERENCES teachers(id),
  schedule JSONB
);
```

```javascript
// DynamoDB Schemas (Development)
// Teachers Table
{
  teacherId: String (primary key),
  userId: String,
  employeeId: String,
  name: String,
  email: String,
  phone: String,
  subjects: [String],
  qualification: String,
  experience: Number,
  joinDate: String,
  bio: String,
  classesAssigned: [String],
  isActive: Boolean
}

// Students Table
{
  studentId: String (primary key),
  userId: String,
  name: String,
  grade: String,
  section: String,
  rollNumber: String,
  admissionDate: String,
  parentId: String,
  parentName: String,
  address: String,
  phone: String,
  email: String,
  academicYear: String,
  isActive: Boolean
}

// Classes Table
{
  classId: String (primary key),
  name: String,
  grade: String,
  section: String,
  classTeacher: String,
  teacherId: String,
  subject: String,
  timeSlot: String,
  description: String,
  students: Number,
  maxStudents: Number,
  academicYear: String
}
```

### **Academic Operations**

```sql
-- Attendance Table (PostgreSQL)
CREATE TABLE attendance (
  id SERIAL PRIMARY KEY,
  student_id INTEGER REFERENCES students(id),
  class_id INTEGER REFERENCES classes(id),
  teacher_id INTEGER REFERENCES teachers(id),
  date DATE NOT NULL,
  status VARCHAR(20) CHECK (status IN ('present', 'absent', 'late', 'excused')),
  remarks TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Assignments Table (PostgreSQL)
CREATE TABLE assignments (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  class_id INTEGER REFERENCES classes(id),
  teacher_id INTEGER REFERENCES teachers(id),
  subject VARCHAR(50),
  due_date DATE,
  attachments TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Assignment Submissions Table (PostgreSQL)
CREATE TABLE assignment_submissions (
  id SERIAL PRIMARY KEY,
  assignment_id INTEGER REFERENCES assignments(id),
  student_id INTEGER REFERENCES students(id),
  submission_date TIMESTAMP,
  attachments TEXT[],
  remarks TEXT,
  grade VARCHAR(10),
  feedback TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exams Table (PostgreSQL)
CREATE TABLE exams (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  class_id INTEGER REFERENCES classes(id),
  teacher_id INTEGER REFERENCES teachers(id),
  subject VARCHAR(50),
  exam_date DATE,
  duration INTEGER,
  total_marks INTEGER,
  exam_type VARCHAR(20) CHECK (exam_type IN ('quiz', 'test', 'midterm', 'final')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exam Results Table (PostgreSQL)
CREATE TABLE exam_results (
  id SERIAL PRIMARY KEY,
  exam_id INTEGER REFERENCES exams(id),
  student_id INTEGER REFERENCES students(id),
  marks_obtained INTEGER,
  grade VARCHAR(10),
  remarks TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Timetable Table (PostgreSQL)
CREATE TABLE timetables (
  id SERIAL PRIMARY KEY,
  class_id INTEGER REFERENCES classes(id),
  academic_year VARCHAR(10),
  day_of_week VARCHAR(10),
  period_number INTEGER,
  subject VARCHAR(50),
  teacher_id INTEGER REFERENCES teachers(id),
  start_time TIME,
  end_time TIME,
  room VARCHAR(20)
);
```

```javascript
// DynamoDB Schemas (Development)
// Attendance Table
{
  attendanceId: String (primary key), // format: studentId_date
  studentId: String,
  classId: String,
  teacherId: String,
  date: String,
  status: String, // 'present', 'absent', 'late', 'excused'
  remarks: String,
  createdAt: String
}

// Assignments Table
{
  assignmentId: String (primary key),
  title: String,
  description: String,
  classId: String,
  teacherId: String,
  subject: String,
  dueDate: String,
  attachments: [String],
  submissions: [{
    studentId: String,
    submissionDate: String,
    attachments: [String],
    remarks: String,
    grade: String,
    feedback: String
  }],
  createdAt: String
}

// Exams Table
{
  examId: String (primary key),
  title: String,
  classId: String,
  teacherId: String,
  subject: String,
  examDate: String,
  duration: Number,
  totalMarks: Number,
  examType: String, // 'quiz', 'test', 'midterm', 'final'
  results: [{
    studentId: String,
    marksObtained: Number,
    grade: String,
    remarks: String
  }]
}
```

### **Communication & Management**

```sql
-- Notifications Table (PostgreSQL)
CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  message TEXT,
  type VARCHAR(20) CHECK (type IN ('announcement', 'reminder', 'alert', 'event')),
  sender_id INTEGER REFERENCES users(id),
  target_user_types TEXT[],
  target_classes INTEGER[],
  target_users INTEGER[],
  priority VARCHAR(10) CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  scheduled_for TIMESTAMP,
  expires_at TIMESTAMP,
  attachments TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notification Reads Table (PostgreSQL)
CREATE TABLE notification_reads (
  notification_id INTEGER REFERENCES notifications(id),
  user_id INTEGER REFERENCES users(id),
  read_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (notification_id, user_id)
);

-- Events Table (PostgreSQL)
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  event_type VARCHAR(50),
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  location VARCHAR(200),
  organizer_id INTEGER REFERENCES users(id),
  is_public BOOLEAN DEFAULT true,
  attachments TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Event Participants Table (PostgreSQL)
CREATE TABLE event_participants (
  id SERIAL PRIMARY KEY,
  event_id INTEGER REFERENCES events(id),
  user_id INTEGER REFERENCES users(id),
  participation_type VARCHAR(20) CHECK (participation_type IN ('required', 'optional')),
  status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'declined')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fees Table (PostgreSQL)
CREATE TABLE fees (
  id SERIAL PRIMARY KEY,
  student_id INTEGER REFERENCES students(id),
  academic_year VARCHAR(10),
  total_amount DECIMAL(10,2),
  paid_amount DECIMAL(10,2) DEFAULT 0,
  pending_amount DECIMAL(10,2),
  status VARCHAR(20) CHECK (status IN ('pending', 'partial', 'paid', 'overdue')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fee Structure Table (PostgreSQL)
CREATE TABLE fee_structure (
  id SERIAL PRIMARY KEY,
  fee_id INTEGER REFERENCES fees(id),
  category VARCHAR(50),
  amount DECIMAL(10,2),
  due_date DATE,
  description TEXT
);

-- Fee Payments Table (PostgreSQL)
CREATE TABLE fee_payments (
  id SERIAL PRIMARY KEY,
  fee_id INTEGER REFERENCES fees(id),
  amount DECIMAL(10,2),
  payment_date DATE,
  payment_method VARCHAR(50),
  transaction_id VARCHAR(100),
  receipt_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```javascript
// DynamoDB Schemas (Development)
// Notifications Table
{
  notificationId: String (primary key), // timestamp
  title: String,
  message: String,
  type: String, // 'announcement', 'reminder', 'alert', 'event'
  sender: String,
  recipients: {
    userTypes: [String],
    specificUsers: [String],
    classes: [String]
  },
  priority: String, // 'low', 'medium', 'high', 'urgent'
  isRead: [{
    userId: String,
    readAt: String
  }],
  scheduledFor: String,
  expiresAt: String,
  attachments: [String],
  timestamp: String
}

// Events Table
{
  eventId: String (primary key),
  title: String,
  description: String,
  eventType: String,
  startDate: String,
  endDate: String,
  location: String,
  organizer: String,
  participants: {
    required: [String],
    optional: [String],
    confirmed: [String]
  },
  attachments: [String],
  isPublic: Boolean
}

// Fees Table
{
  feeId: String (primary key),
  studentId: String,
  academicYear: String,
  feeStructure: [{
    category: String,
    amount: Number,
    dueDate: String,
    description: String
  }],
  payments: [{
    amount: Number,
    paymentDate: String,
    paymentMethod: String,
    transactionId: String,
    receipt: String
  }],
  totalAmount: Number,
  paidAmount: Number,
  pendingAmount: Number,
  status: String // 'pending', 'partial', 'paid', 'overdue'
}
```

## 🚀 API Endpoints Structure

### **User Management**
```
GET    /api/users                    # List all users
POST   /api/users                    # Create new user
GET    /api/users/:id               # Get user details
PUT    /api/users/:id               # Update user
DELETE /api/users/:id               # Deactivate user
GET    /api/users/search            # Search users
GET    /api/users/profile/:id       # Get user profile
PUT    /api/users/profile/:id       # Update user profile
```

### **Teacher Management**
```
GET    /api/teachers                # List teachers
POST   /api/teachers                # Add teacher
GET    /api/teachers/:id            # Get teacher details
PUT    /api/teachers/:id            # Update teacher
GET    /api/teachers/:id/classes    # Get teacher's classes
GET    /api/teachers/:id/students   # Get teacher's students
GET    /api/teachers/:id/schedule   # Get teacher's schedule
```

### **Student Management**
```
GET    /api/students                # List students
POST   /api/students                # Add student
GET    /api/students/:id            # Get student details
PUT    /api/students/:id            # Update student
GET    /api/students/:id/attendance # Get attendance
GET    /api/students/:id/assignments # Get assignments
GET    /api/students/:id/grades     # Get grades
GET    /api/students/:id/fees       # Get fee details
```

### **Class Management**
```
GET    /api/classes                 # List classes
POST   /api/classes                 # Create class
GET    /api/classes/:id             # Get class details
PUT    /api/classes/:id             # Update class
GET    /api/classes/:id/students    # Get class students
GET    /api/classes/:id/timetable   # Get class timetable
GET    /api/classes/:id/attendance  # Get class attendance
```

### **Attendance Management**
```
GET    /api/attendance              # Get attendance records
POST   /api/attendance              # Mark attendance
PUT    /api/attendance/:id          # Update attendance
GET    /api/attendance/class/:classId/date/:date
GET    /api/attendance/student/:studentId
GET    /api/attendance/reports      # Attendance reports
```

### **Assignment/Homework Management**
```
GET    /api/assignments             # List assignments
POST   /api/assignments             # Create assignment
GET    /api/assignments/:id         # Get assignment details
PUT    /api/assignments/:id         # Update assignment
DELETE /api/assignments/:id         # Delete assignment
POST   /api/assignments/:id/submit  # Submit assignment
GET    /api/assignments/:id/submissions # Get submissions
PUT    /api/assignments/:id/grade   # Grade assignment
```

### **Examination Management**
```
GET    /api/exams                   # List exams
POST   /api/exams                   # Create exam
GET    /api/exams/:id               # Get exam details
PUT    /api/exams/:id               # Update exam
POST   /api/exams/:id/results       # Add exam results
GET    /api/exams/:id/results       # Get exam results
GET    /api/exams/student/:studentId # Get student's exams
```

### **Notification Management**
```
GET    /api/notifications           # Get notifications
POST   /api/notifications           # Send notification
PUT    /api/notifications/:id/read  # Mark as read
DELETE /api/notifications/:id       # Delete notification
GET    /api/notifications/unread    # Get unread count
```

### **Event Management**
```
GET    /api/events                  # List events
POST   /api/events                  # Create event
GET    /api/events/:id              # Get event details
PUT    /api/events/:id              # Update event
DELETE /api/events/:id              # Delete event
POST   /api/events/:id/rsvp         # RSVP to event
```

### **Fee Management**
```
GET    /api/fees                    # List fee records
POST   /api/fees                    # Create fee record
GET    /api/fees/student/:studentId # Get student fees
POST   /api/fees/:id/payment        # Record payment
GET    /api/fees/:id/receipt        # Generate receipt
GET    /api/fees/reports            # Fee reports
```

### **Reports & Analytics**
```
GET    /api/reports/attendance      # Attendance reports
GET    /api/reports/academic        # Academic performance
GET    /api/reports/fees            # Fee collection reports
GET    /api/reports/class-summary   # Class summary reports
GET    /api/analytics/dashboard     # Dashboard analytics
```

## 🔧 Implementation Guidelines

### **Project Structure**
```
school-management-backend/
├── src/
│   ├── controllers/
│   │   ├── userController.js
│   │   ├── studentController.js
│   │   ├── teacherController.js
│   │   ├── classController.js
│   │   ├── attendanceController.js
│   │   ├── assignmentController.js
│   │   ├── examController.js
│   │   ├── notificationController.js
│   │   ├── eventController.js
│   │   └── feeController.js
│   ├── models/
│   │   ├── postgres/          # PostgreSQL models (Sequelize)
│   │   │   ├── User.js
│   │   │   ├── Teacher.js
│   │   │   ├── Student.js
│   │   │   ├── Class.js
│   │   │   ├── Attendance.js
│   │   │   ├── Assignment.js
│   │   │   ├── Exam.js
│   │   │   ├── Notification.js
│   │   │   ├── Event.js
│   │   │   └── Fee.js
│   │   └── dynamodb/          # DynamoDB models (development)
│   │       ├── userModel.js
│   │       ├── teacherModel.js
│   │       ├── studentModel.js
│   │       ├── classModel.js
│   │       ├── attendanceModel.js
│   │       └── notificationModel.js
│   ├── routes/
│   │   ├── userRoutes.js
│   │   ├── teacherRoutes.js
│   │   ├── studentRoutes.js
│   │   ├── classRoutes.js
│   │   ├── attendanceRoutes.js
│   │   ├── assignmentRoutes.js
│   │   ├── examRoutes.js
│   │   ├── notificationRoutes.js
│   │   ├── eventRoutes.js
│   │   └── feeRoutes.js
│   ├── middleware/
│   │   ├── validation.js
│   │   ├── upload.js
│   │   ├── errorHandler.js
│   │   └── cors.js
│   ├── services/
│   │   ├── emailService.js
│   │   ├── notificationService.js
│   │   ├── reportService.js
│   │   ├── fileService.js
│   │   └── databaseService.js  # Database abstraction layer
│   ├── utils/
│   │   ├── constants.js
│   │   ├── helpers.js
│   │   ├── validators.js
│   │   ├── logger.js
│   │   └── dynamoDbHelper.js   # Existing DynamoDB helper
│   ├── config/
│   │   ├── database.js         # PostgreSQL config
│   │   ├── dynamodb.js         # DynamoDB Local config
│   │   ├── config.js
│   │   └── swagger.js
│   └── app.js
├── tests/
├── uploads/
├── docs/
├── scripts/
│   ├── postgres-setup.sql      # PostgreSQL table creation
│   └── migrate-to-postgres.js  # Migration script
├── package.json
├── .env.example
└── README.md
```

### **Key Features to Implement**

1. **Database Abstraction Layer**
   - Dual database support (PostgreSQL production + DynamoDB Local development)
   - Seamless switching between database systems
   - Data migration utilities

2. **Real-time Features**
   - Socket.io for live notifications
   - Real-time attendance updates
   - Live dashboard updates

3. **File Management**
   - Assignment submission handling
   - Profile picture uploads
   - Document storage (certificates, reports)
   - Local file storage with organized directory structure

4. **Reporting System**
   - PDF generation for reports
   - Excel export capabilities
   - Dashboard analytics
   - Attendance reports and academic performance tracking

5. **Communication System**
   - Email notifications
   - In-app messaging
   - Announcement broadcasting

6. **Data Validation & Security**
   - Input validation and sanitization
   - Rate limiting
   - CORS configuration
   - Data integrity checks

7. **Performance Optimization**
   - Query optimization for both databases
   - API response caching
   - Efficient data indexing

## 🚦 Development Phases

### **Phase 1: Core Foundation & Database Setup (Week 1-2)**
- Set up project structure with dual database support
- Create PostgreSQL table schemas
- Implement database abstraction layer
- Set up DynamoDB Local integration (reuse existing setup)
- Basic CRUD operations for users, teachers, and students

### **Phase 2: Academic Management (Week 3-4)**
- Complete user management system
- Student and teacher profile management
- Class management with subject assignments
- Basic attendance tracking system

### **Phase 3: Educational Features (Week 5-6)**
- Assignment/homework creation and submission system
- Examination management and results
- Timetable management and scheduling
- File upload and storage system

### **Phase 4: Communication & Advanced Features (Week 7-8)**
- Real-time notification system with Socket.io
- Event management and calendar integration
- Fee management and payment tracking
- Reporting system with PDF/Excel export

### **Phase 5: Testing, Migration & Optimization (Week 9-10)**
- Comprehensive testing for both database systems
- Data migration scripts from DynamoDB to PostgreSQL
- API documentation with Swagger
- Performance optimization and deployment setup
- Integration testing with existing Flutter app

## 📱 Mobile App Integration

### **API Response Format**
```javascript
// Success Response
{
  success: true,
  data: {...},
  message: "Operation successful",
  timestamp: "2024-01-01T00:00:00.000Z"
}

// Error Response
{
  success: false,
  error: {
    code: "VALIDATION_ERROR",
    message: "Invalid input data",
    details: {...}
  },
  timestamp: "2024-01-01T00:00:00.000Z"
}
```

### **Pagination Support**
```javascript
{
  success: true,
  data: [...],
  pagination: {
    page: 1,
    limit: 20,
    total: 150,
    pages: 8,
    hasNext: true,
    hasPrev: false
  }
}
```

## 🔄 Database Abstraction Strategy

### **Environment-Based Database Selection**
```javascript
// config/database.js
const environment = process.env.NODE_ENV || 'development';

const databaseConfig = {
  development: {
    type: 'dynamodb',
    endpoint: 'http://localhost:8000',
    region: 'local'
  },
  production: {
    type: 'postgresql',
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD
  }
};
```

### **Database Service Layer**
```javascript
// services/databaseService.js
class DatabaseService {
  constructor() {
    this.dbType = process.env.NODE_ENV === 'production' ? 'postgresql' : 'dynamodb';
    this.initializeConnection();
  }
  
  async create(table, data) {
    if (this.dbType === 'postgresql') {
      return await this.postgresModel[table].create(data);
    } else {
      return await this.dynamoHelper.putItem(table, data);
    }
  }
  
  async findById(table, id) {
    if (this.dbType === 'postgresql') {
      return await this.postgresModel[table].findByPk(id);
    } else {
      return await this.dynamoHelper.getItem(table, 'id', id);
    }
  }
  
  // ... other CRUD operations
}
```

### **Migration Strategy**
1. **Development Phase**: Use existing DynamoDB Local setup
2. **Testing Phase**: Implement PostgreSQL models alongside DynamoDB
3. **Migration Phase**: Run migration scripts to transfer data
4. **Production Phase**: Switch to PostgreSQL with fallback support

### **Package.json Scripts**
```json
{
  "scripts": {
    "dev": "NODE_ENV=development nodemon src/app.js",
    "prod": "NODE_ENV=production node src/app.js",
    "setup-postgres": "node scripts/postgres-setup.js",
    "migrate": "node scripts/migrate-to-postgres.js",
    "test:dev": "NODE_ENV=development npm test",
    "test:prod": "NODE_ENV=production npm test"
  }
}
```

This comprehensive backend plan provides a scalable, maintainable foundation for the péče School Management System with dual database support, no authentication complexity, and seamless development-to-production migration path. 