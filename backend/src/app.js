const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const http = require('http');
const socketIo = require('socket.io');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const config = require('./config/config');
const responseMiddleware = require('./middleware/responseMiddleware');
const { errorHandler } = require('./middleware/errorHandler');

// Initialize express app
const app = express();

// Create HTTP server
const server = http.createServer(app);

// Initialize Socket.io
const io = socketIo(server, {
  cors: {
    origin: config.socket.corsOrigin,
    methods: ['GET', 'POST'],
    credentials: true
  }
});

// Socket.io middleware and event handlers
io.use((socket, next) => {
  // Socket authentication middleware could go here
  next();
});

io.on('connection', (socket) => {
  console.log('A user connected:', socket.id);
  
  // Join a room (e.g., for specific class or user)
  socket.on('join-room', (room) => {
    socket.join(room);
    console.log(`Socket ${socket.id} joined room: ${room}`);
  });

  // Leave a room
  socket.on('leave-room', (room) => {
    socket.leave(room);
    console.log(`Socket ${socket.id} left room: ${room}`);
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// Middleware
app.use(cors({
  origin: config.api.corsOrigin,
  credentials: true
}));
app.use(helmet());
app.use(compression());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Request logging
if (config.NODE_ENV !== 'test') {
  app.use(morgan('dev'));
}

// Response formatting middleware
app.use(responseMiddleware);

// Swagger documentation
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'School Management API',
      version: '1.0.0',
      description: 'API documentation for the School Management System',
      contact: {
        name: 'API Support',
        email: 'support@scolio-app.com'
      }
    },
    servers: [
      {
        url: `http://localhost:${config.port}`,
        description: 'Development server'
      }
    ]
  },
  apis: ['./src/routes/*.js']
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Health check endpoint
app.get('/health', (req, res) => {
  res.success({ status: 'ok', timestamp: new Date() }, 'Server is running');
});

// API version endpoint
app.get('/api/version', (req, res) => {
  res.success({ version: '1.0.0' }, 'API version');
});

// Import and use routes if they exist
try {
  const userRoutes = require('./routes/userRoutes');
  app.use('/api/users', userRoutes);
} catch (error) {
  console.warn('User routes not available:', error.message);
}

try {
  const teacherRoutes = require('./routes/teacherRoutes');
  app.use('/api/teachers', teacherRoutes);
} catch (error) {
  console.warn('Teacher routes not available:', error.message);
}

try {
  const studentRoutes = require('./routes/studentRoutes');
  app.use('/api/students', studentRoutes);
} catch (error) {
  console.warn('Student routes not available:', error.message);
}

try {
  const classRoutes = require('./routes/classRoutes');
  app.use('/api/classes', classRoutes);
} catch (error) {
  console.warn('Class routes not available:', error.message);
}

try {
  const attendanceRoutes = require('./routes/attendanceRoutes');
  app.use('/api/attendance', attendanceRoutes);
} catch (error) {
  console.warn('Attendance routes not available:', error.message);
}

try {
  const assignmentRoutes = require('./routes/assignmentRoutes');
  app.use('/api/assignments', assignmentRoutes);
} catch (error) {
  console.warn('Assignment routes not available:', error.message);
}

try {
  const examRoutes = require('./routes/examRoutes');
  app.use('/api/exams', examRoutes);
} catch (error) {
  console.warn('Exam routes not available:', error.message);
}

try {
  const notificationRoutes = require('./routes/notificationRoutes');
  app.use('/api/notifications', notificationRoutes);
} catch (error) {
  console.warn('Notification routes not available:', error.message);
}

// 404 handler
app.use((req, res) => {
  res.error('Not Found', 404);
});

// Error handling middleware
app.use(errorHandler);

// Export app and server
module.exports = { app, server, io };