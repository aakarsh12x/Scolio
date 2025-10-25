const Joi = require('joi');

// User creation validation schema
const userCreateSchema = Joi.object({
  username: Joi.string()
    .alphanum()
    .min(3)
    .max(30)
    .required()
    .messages({
      'string.alphanum': 'Username must contain only alphanumeric characters',
      'string.min': 'Username must be at least 3 characters long',
      'string.max': 'Username cannot exceed 30 characters',
      'any.required': 'Username is required'
    }),

  email: Joi.string()
    .email()
    .required()
    .messages({
      'string.email': 'Please provide a valid email address',
      'any.required': 'Email is required'
    }),

  userType: Joi.string()
    .valid('teacher', 'student', 'parent', 'admin')
    .required()
    .messages({
      'any.only': 'User type must be one of: teacher, student, parent, admin',
      'any.required': 'User type is required'
    }),

  firstName: Joi.string()
    .min(2)
    .max(50)
    .required()
    .messages({
      'string.min': 'First name must be at least 2 characters long',
      'string.max': 'First name cannot exceed 50 characters',
      'any.required': 'First name is required'
    }),

  lastName: Joi.string()
    .min(2)
    .max(50)
    .required()
    .messages({
      'string.min': 'Last name must be at least 2 characters long',
      'string.max': 'Last name cannot exceed 50 characters',
      'any.required': 'Last name is required'
    }),

  phone: Joi.string()
    .pattern(/^[+]?[1-9][\d\-\(\)\s]{7,15}$/)
    .optional()
    .messages({
      'string.pattern.base': 'Please provide a valid phone number'
    }),

  avatarUrl: Joi.string()
    .uri()
    .optional()
    .messages({
      'string.uri': 'Avatar URL must be a valid URL'
    }),

  address: Joi.object({
    street: Joi.string().max(100).optional(),
    city: Joi.string().max(50).optional(),
    state: Joi.string().max(50).optional(),
    postalCode: Joi.string().max(20).optional(),
    country: Joi.string().max(50).optional()
  }).optional(),

  isActive: Joi.boolean()
    .optional()
    .default(true),

  dateOfBirth: Joi.date()
    .max('now')
    .optional()
    .messages({
      'date.max': 'Date of birth cannot be in the future'
    }),

  gender: Joi.string()
    .valid('male', 'female', 'other')
    .optional(),

  emergencyContact: Joi.object({
    name: Joi.string().max(100).optional(),
    phone: Joi.string().pattern(/^[+]?[1-9][\d\-\(\)\s]{7,15}$/).optional(),
    relationship: Joi.string().max(50).optional()
  }).optional()
});

// User update validation schema (all fields optional)
const userUpdateSchema = Joi.object({
  email: Joi.string()
    .email()
    .optional()
    .messages({
      'string.email': 'Please provide a valid email address'
    }),

  userType: Joi.string()
    .valid('teacher', 'student', 'parent', 'admin')
    .optional()
    .messages({
      'any.only': 'User type must be one of: teacher, student, parent, admin'
    }),

  firstName: Joi.string()
    .min(2)
    .max(50)
    .optional()
    .messages({
      'string.min': 'First name must be at least 2 characters long',
      'string.max': 'First name cannot exceed 50 characters'
    }),

  lastName: Joi.string()
    .min(2)
    .max(50)
    .optional()
    .messages({
      'string.min': 'Last name must be at least 2 characters long',
      'string.max': 'Last name cannot exceed 50 characters'
    }),

  phone: Joi.string()
    .pattern(/^[+]?[1-9][\d\-\(\)\s]{7,15}$/)
    .optional()
    .messages({
      'string.pattern.base': 'Please provide a valid phone number'
    }),

  avatarUrl: Joi.string()
    .uri()
    .optional()
    .messages({
      'string.uri': 'Avatar URL must be a valid URL'
    }),

  address: Joi.object({
    street: Joi.string().max(100).optional(),
    city: Joi.string().max(50).optional(),
    state: Joi.string().max(50).optional(),
    postalCode: Joi.string().max(20).optional(),
    country: Joi.string().max(50).optional()
  }).optional(),

  isActive: Joi.boolean().optional(),

  dateOfBirth: Joi.date()
    .max('now')
    .optional()
    .messages({
      'date.max': 'Date of birth cannot be in the future'
    }),

  gender: Joi.string()
    .valid('male', 'female', 'other')
    .optional(),

  emergencyContact: Joi.object({
    name: Joi.string().max(100).optional(),
    phone: Joi.string().pattern(/^[+]?[1-9][\d\-\(\)\s]{7,15}$/).optional(),
    relationship: Joi.string().max(50).optional()
  }).optional()
}).min(1).messages({
  'object.min': 'At least one field must be provided for update'
});

// Profile update validation schema (limited fields)
const profileUpdateSchema = Joi.object({
  firstName: Joi.string()
    .min(2)
    .max(50)
    .optional()
    .messages({
      'string.min': 'First name must be at least 2 characters long',
      'string.max': 'First name cannot exceed 50 characters'
    }),

  lastName: Joi.string()
    .min(2)
    .max(50)
    .optional()
    .messages({
      'string.min': 'Last name must be at least 2 characters long',
      'string.max': 'Last name cannot exceed 50 characters'
    }),

  phone: Joi.string()
    .pattern(/^[+]?[1-9][\d\-\(\)\s]{7,15}$/)
    .optional()
    .messages({
      'string.pattern.base': 'Please provide a valid phone number'
    }),

  avatarUrl: Joi.string()
    .uri()
    .optional()
    .messages({
      'string.uri': 'Avatar URL must be a valid URL'
    }),

  address: Joi.object({
    street: Joi.string().max(100).optional(),
    city: Joi.string().max(50).optional(),
    state: Joi.string().max(50).optional(),
    postalCode: Joi.string().max(20).optional(),
    country: Joi.string().max(50).optional()
  }).optional(),

  dateOfBirth: Joi.date()
    .max('now')
    .optional()
    .messages({
      'date.max': 'Date of birth cannot be in the future'
    }),

  gender: Joi.string()
    .valid('male', 'female', 'other')
    .optional(),

  emergencyContact: Joi.object({
    name: Joi.string().max(100).optional(),
    phone: Joi.string().pattern(/^[+]?[1-9][\d\-\(\)\s]{7,15}$/).optional(),
    relationship: Joi.string().max(50).optional()
  }).optional()
}).min(1).messages({
  'object.min': 'At least one field must be provided for update'
});

// Search validation schema
const searchSchema = Joi.object({
  query: Joi.string()
    .min(2)
    .max(100)
    .required()
    .messages({
      'string.min': 'Search query must be at least 2 characters long',
      'string.max': 'Search query cannot exceed 100 characters',
      'any.required': 'Search query is required'
    }),

  userType: Joi.string()
    .valid('teacher', 'student', 'parent', 'admin')
    .optional(),

  page: Joi.number()
    .integer()
    .min(1)
    .optional()
    .default(1),

  limit: Joi.number()
    .integer()
    .min(1)
    .max(100)
    .optional()
    .default(20)
});

// Validation functions
const validateUser = (data) => {
  return userCreateSchema.validate(data, { abortEarly: false });
};

const validateUserUpdate = (data) => {
  return userUpdateSchema.validate(data, { abortEarly: false });
};

const validateProfileUpdate = (data) => {
  return profileUpdateSchema.validate(data, { abortEarly: false });
};

const validateSearch = (data) => {
  return searchSchema.validate(data, { abortEarly: false });
};

// Pagination validation
const validatePagination = (data) => {
  const schema = Joi.object({
    page: Joi.number().integer().min(1).optional().default(1),
    limit: Joi.number().integer().min(1).max(100).optional().default(20),
    userType: Joi.string().valid('teacher', 'student', 'parent', 'admin').optional(),
    isActive: Joi.boolean().optional(),
    sortBy: Joi.string().valid('createdAt', 'firstName', 'lastName', 'email', 'username').optional().default('createdAt'),
    sortOrder: Joi.string().valid('ASC', 'DESC').optional().default('DESC')
  });

  return schema.validate(data, { abortEarly: false });
};

module.exports = {
  validateUser,
  validateUserUpdate,
  validateProfileUpdate,
  validateSearch,
  validatePagination,
  userCreateSchema,
  userUpdateSchema,
  profileUpdateSchema,
  searchSchema
}; 