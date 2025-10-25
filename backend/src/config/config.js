require('dotenv').config();

const config = {
  // Environment
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: process.env.PORT || 3000,
  
  // Database Configuration
  database: {
    type: process.env.NODE_ENV === 'production' ? 'postgresql' : 'dynamodb',
    
    // PostgreSQL Configuration (Production)
    postgres: {
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 5432,
      database: process.env.DB_NAME || 'scolio_school_management',
      username: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || '',
      dialect: 'postgres',
      logging: process.env.NODE_ENV === 'development',
      pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
      }
    },
    
    // DynamoDB Local Configuration (Development)
    dynamodb: {
      endpoint: process.env.DYNAMODB_ENDPOINT || 'http://localhost:8000',
      region: process.env.DYNAMODB_REGION || 'local',
      accessKeyId: 'dummy',
      secretAccessKey: 'dummy'
    }
  },
  
  // File Upload Configuration
  upload: {
    path: process.env.UPLOAD_PATH || './uploads',
    maxFileSize: process.env.MAX_FILE_SIZE || 10 * 1024 * 1024, // 10MB
    allowedTypes: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  },
  
  // Email Configuration
  email: {
    host: process.env.EMAIL_HOST || 'smtp.gmail.com',
    port: process.env.EMAIL_PORT || 587,
    secure: false,
    auth: {
      user: process.env.EMAIL_USER || '',
      pass: process.env.EMAIL_PASSWORD || ''
    }
  },
  
  // API Configuration
  api: {
    prefix: process.env.API_PREFIX || '/api',
    corsOrigin: process.env.CORS_ORIGIN || '*',
    rateLimit: {
      windowMs: (process.env.RATE_LIMIT_WINDOW || 15) * 60 * 1000, // 15 minutes
      max: process.env.RATE_LIMIT_MAX || 100
    }
  },
  
  // Socket.io Configuration
  socket: {
    corsOrigin: process.env.SOCKET_CORS_ORIGIN || 'http://localhost:3000'
  },
  
  // Application Constants
  constants: {
    userTypes: ['teacher', 'student', 'parent', 'admin'],
    attendanceStatus: ['present', 'absent', 'late', 'excused'],
    examTypes: ['quiz', 'test', 'midterm', 'final'],
    notificationTypes: ['announcement', 'reminder', 'alert', 'event'],
    notificationPriorities: ['low', 'medium', 'high', 'urgent'],
    feeStatus: ['pending', 'partial', 'paid', 'overdue']
  }
};

module.exports = config; 