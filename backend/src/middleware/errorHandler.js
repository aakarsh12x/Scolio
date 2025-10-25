const config = require('../config/config');

const errorHandler = (err, req, res, next) => {
  // Default error values
  let error = { ...err };
  error.message = err.message;

  // Log error
  console.error('Error Stack:', err.stack);

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors).map(val => val.message).join(', ');
    error = {
      statusCode: 400,
      message
    };
  }

  // Mongoose duplicate key error
  if (err.code === 11000) {
    const message = 'Duplicate field value entered';
    error = {
      statusCode: 400,
      message
    };
  }

  // Mongoose bad ObjectId
  if (err.name === 'CastError') {
    const message = 'Resource not found';
    error = {
      statusCode: 404,
      message
    };
  }

  // DynamoDB specific errors
  if (err.code === 'ResourceNotFoundException') {
    error = {
      statusCode: 404,
      message: 'Resource not found'
    };
  }

  if (err.code === 'ValidationException') {
    error = {
      statusCode: 400,
      message: err.message || 'Validation error'
    };
  }

  if (err.code === 'ConditionalCheckFailedException') {
    error = {
      statusCode: 409,
      message: 'Conditional check failed'
    };
  }

  // PostgreSQL specific errors
  if (err.name === 'SequelizeValidationError') {
    const message = err.errors.map(e => e.message).join(', ');
    error = {
      statusCode: 400,
      message
    };
  }

  if (err.name === 'SequelizeUniqueConstraintError') {
    const message = 'Duplicate field value entered';
    error = {
      statusCode: 400,
      message
    };
  }

  if (err.name === 'SequelizeForeignKeyConstraintError') {
    const message = 'Foreign key constraint violation';
    error = {
      statusCode: 400,
      message
    };
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    const message = 'Invalid token';
    error = {
      statusCode: 401,
      message
    };
  }

  if (err.name === 'TokenExpiredError') {
    const message = 'Token expired';
    error = {
      statusCode: 401,
      message
    };
  }

  // Multer errors
  if (err.code === 'LIMIT_FILE_SIZE') {
    const message = 'File too large';
    error = {
      statusCode: 400,
      message
    };
  }

  if (err.code === 'LIMIT_UNEXPECTED_FILE') {
    const message = 'Unexpected file field';
    error = {
      statusCode: 400,
      message
    };
  }

  // Custom application errors
  if (err.isOperational) {
    error = {
      statusCode: err.statusCode || 500,
      message: err.message
    };
  }

  // Default to 500 server error
  const statusCode = error.statusCode || 500;
  const message = error.message || 'Internal Server Error';

  // Create error response
  const errorResponse = {
    success: false,
    message,
    timestamp: new Date().toISOString()
  };

  // Add error details in development
  if (config.NODE_ENV === 'development') {
    errorResponse.error = {
      name: err.name,
      stack: err.stack,
      details: error
    };
  }

  // Add request information for debugging
  if (config.NODE_ENV === 'development') {
    errorResponse.request = {
      method: req.method,
      url: req.originalUrl,
      headers: req.headers,
      body: req.body,
      params: req.params,
      query: req.query
    };
  }

  res.status(statusCode).json(errorResponse);
};

// Custom error class for application-specific errors
class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

// Helper function to catch async errors
const catchAsync = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

// Helper function to handle not found errors
const handleNotFound = (req, res, next) => {
  const err = new AppError(`Route ${req.originalUrl} not found`, 404);
  next(err);
};

// Validation error helper
const handleValidationError = (message, statusCode = 400) => {
  return new AppError(message, statusCode);
};

module.exports = {
  errorHandler,
  AppError,
  catchAsync,
  handleNotFound,
  handleValidationError
}; 