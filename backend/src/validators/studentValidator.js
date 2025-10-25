const Joi = require('joi');

// Student creation validation schema
const studentCreateSchema = Joi.object({
  username: Joi.string()
    .required()
    .messages({
      'any.required': 'Username is required'
    }),

  studentId: Joi.string()
    .pattern(/^[A-Z0-9]{3,10}$/)
    .required()
    .messages({
      'string.pattern.base': 'Student ID must be 3-10 uppercase letters or numbers',
      'any.required': 'Student ID is required'
    }),

  rollNumber: Joi.string()
    .max(20)
    .required()
    .messages({
      'string.max': 'Roll number cannot exceed 20 characters',
      'any.required': 'Roll number is required'
    }),

  classId: Joi.string()
    .optional()
    .messages({
      'string.base': 'Class ID must be a string'
    }),

  section: Joi.string()
    .max(10)
    .optional()
    .messages({
      'string.max': 'Section cannot exceed 10 characters'
    }),

  admissionDate: Joi.date()
    .max('now')
    .required()
    .messages({
      'date.max': 'Admission date cannot be in the future',
      'any.required': 'Admission date is required'
    }),

  parentId: Joi.string()
    .optional()
    .messages({
      'string.base': 'Parent ID must be a string'
    }),

  academicYear: Joi.string()
    .pattern(/^\d{4}-\d{4}$/)
    .required()
    .messages({
      'string.pattern.base': 'Academic year must be in format YYYY-YYYY',
      'any.required': 'Academic year is required'
    }),

  bloodGroup: Joi.string()
    .valid('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
    .optional(),

  healthInfo: Joi.object({
    allergies: Joi.array().items(Joi.string()).optional(),
    medicalConditions: Joi.array().items(Joi.string()).optional(),
    medications: Joi.array().items(Joi.string()).optional(),
    emergencyContact: Joi.string().optional()
  }).optional(),

  transportInfo: Joi.object({
    busNumber: Joi.string().optional(),
    routeNumber: Joi.string().optional(),
    pickupPoint: Joi.string().optional(),
    dropPoint: Joi.string().optional()
  }).optional(),

  previousSchool: Joi.string()
    .max(100)
    .optional()
    .messages({
      'string.max': 'Previous school name cannot exceed 100 characters'
    }),

  achievements: Joi.array()
    .items(Joi.object({
      title: Joi.string().required(),
      description: Joi.string().required(),
      date: Joi.date().required(),
      category: Joi.string().optional()
    }))
    .optional(),

  isActive: Joi.boolean()
    .optional()
    .default(true)
});

// Student update validation schema (all fields optional)
const studentUpdateSchema = Joi.object({
  rollNumber: Joi.string()
    .max(20)
    .optional()
    .messages({
      'string.max': 'Roll number cannot exceed 20 characters'
    }),

  classId: Joi.string()
    .optional()
    .messages({
      'string.base': 'Class ID must be a string'
    }),

  section: Joi.string()
    .max(10)
    .optional()
    .messages({
      'string.max': 'Section cannot exceed 10 characters'
    }),

  admissionDate: Joi.date()
    .max('now')
    .optional()
    .messages({
      'date.max': 'Admission date cannot be in the future'
    }),

  parentId: Joi.string()
    .optional()
    .messages({
      'string.base': 'Parent ID must be a string'
    }),

  academicYear: Joi.string()
    .pattern(/^\d{4}-\d{4}$/)
    .optional()
    .messages({
      'string.pattern.base': 'Academic year must be in format YYYY-YYYY'
    }),

  bloodGroup: Joi.string()
    .valid('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
    .optional(),

  healthInfo: Joi.object({
    allergies: Joi.array().items(Joi.string()).optional(),
    medicalConditions: Joi.array().items(Joi.string()).optional(),
    medications: Joi.array().items(Joi.string()).optional(),
    emergencyContact: Joi.string().optional()
  }).optional(),

  transportInfo: Joi.object({
    busNumber: Joi.string().optional(),
    routeNumber: Joi.string().optional(),
    pickupPoint: Joi.string().optional(),
    dropPoint: Joi.string().optional()
  }).optional(),

  previousSchool: Joi.string()
    .max(100)
    .optional()
    .messages({
      'string.max': 'Previous school name cannot exceed 100 characters'
    }),

  achievements: Joi.array()
    .items(Joi.object({
      title: Joi.string().required(),
      description: Joi.string().required(),
      date: Joi.date().required(),
      category: Joi.string().optional()
    }))
    .optional(),

  isActive: Joi.boolean().optional()
}).min(1).messages({
  'object.min': 'At least one field must be provided for update'
});

// Validation for attendance query
const attendanceQuerySchema = Joi.object({
  startDate: Joi.date()
    .optional(),

  endDate: Joi.date()
    .min(Joi.ref('startDate'))
    .optional()
    .messages({
      'date.min': 'End date must be after start date'
    }),

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

// Validation for assignments query
const assignmentsQuerySchema = Joi.object({
  status: Joi.string()
    .valid('pending', 'submitted', 'overdue', 'all')
    .optional()
    .default('all'),

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
const validateStudent = (data) => {
  return studentCreateSchema.validate(data, { abortEarly: false });
};

const validateStudentUpdate = (data) => {
  return studentUpdateSchema.validate(data, { abortEarly: false });
};

const validateAttendanceQuery = (data) => {
  return attendanceQuerySchema.validate(data, { abortEarly: false });
};

const validateAssignmentsQuery = (data) => {
  return assignmentsQuerySchema.validate(data, { abortEarly: false });
};

module.exports = {
  validateStudent,
  validateStudentUpdate,
  validateAttendanceQuery,
  validateAssignmentsQuery,
  studentCreateSchema,
  studentUpdateSchema,
  attendanceQuerySchema,
  assignmentsQuerySchema
}; 