const responseMiddleware = (req, res, next) => {
  // Success response helper
  res.success = (data = null, message = 'Success', statusCode = 200) => {
    const response = {
      success: true,
      message,
      timestamp: new Date().toISOString()
    };

    // Only include data if it's provided
    if (data !== null) {
      response.data = data;
    }

    return res.status(statusCode).json(response);
  };

  // Error response helper
  res.error = (message = 'Internal Server Error', statusCode = 500, details = null) => {
    const response = {
      success: false,
      message,
      timestamp: new Date().toISOString()
    };

    // Include error details if provided (only in development)
    if (details && process.env.NODE_ENV === 'development') {
      response.details = details;
    }

    return res.status(statusCode).json(response);
  };

  // Paginated response helper
  res.paginated = (data, pagination, message = 'Data retrieved successfully', statusCode = 200) => {
    const response = {
      success: true,
      message,
      data,
      pagination: {
        page: pagination.page,
        limit: pagination.limit,
        total: pagination.total,
        pages: pagination.pages,
        hasNext: pagination.hasNext,
        hasPrev: pagination.hasPrev
      },
      timestamp: new Date().toISOString()
    };

    return res.status(statusCode).json(response);
  };

  // Created response helper
  res.created = (data, message = 'Resource created successfully') => {
    return res.success(data, message, 201);
  };

  // Updated response helper
  res.updated = (data, message = 'Resource updated successfully') => {
    return res.success(data, message, 200);
  };

  // Deleted response helper
  res.deleted = (message = 'Resource deleted successfully') => {
    return res.success(null, message, 200);
  };

  // Not found response helper
  res.notFound = (message = 'Resource not found') => {
    return res.error(message, 404);
  };

  // Validation error response helper
  res.validationError = (message = 'Validation failed', details = null) => {
    return res.error(message, 400, details);
  };

  // Unauthorized response helper
  res.unauthorized = (message = 'Unauthorized access') => {
    return res.error(message, 401);
  };

  // Forbidden response helper
  res.forbidden = (message = 'Access forbidden') => {
    return res.error(message, 403);
  };

  // Conflict response helper
  res.conflict = (message = 'Resource conflict') => {
    return res.error(message, 409);
  };

  // Too many requests response helper
  res.tooManyRequests = (message = 'Too many requests') => {
    return res.error(message, 429);
  };

  // Internal server error response helper
  res.serverError = (message = 'Internal server error', details = null) => {
    return res.error(message, 500, details);
  };

  // No content response helper
  res.noContent = () => {
    return res.status(204).send();
  };

  next();
};

module.exports = responseMiddleware; 