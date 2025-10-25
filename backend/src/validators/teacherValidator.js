const Joi = require('joi');

// Teacher creation validation schema
const teacherCreateSchema = Joi.object({
  username: Joi.string()
    .required()
    .messages({
      'any.required': 'Username is required'
    }),

  employeeId: Joi.string()
    .pattern(/^[A-Z0-9]{3,10}$/)
    .required()
    .messages({
      'string.pattern.base': 'Employee ID must be 3-10 uppercase letters or numbers',
      'any.required': 'Employee ID is required'
    }),

  subjects: Joi.array()
    .items(Joi.string())
    .min(1)
    .required()
    .messages({
      'array.min': 'At least one subject must be provided',
      'any.required': 'Subjects are required'
    }),

  qualification: Joi.string()
    .max(100)
    .required()
    .messages({
      'string.max': 'Qualification cannot exceed 100 characters',
      'any.required': 'Qualification is required'
    }),

  experience: Joi.number()
    .integer()
    .min(0)
    .required()
    .messages({
      'number.base': 'Experience must be a number',
      'number.integer': 'Experience must be an integer',
      'number.min': 'Experience cannot be negative',
      'any.required': 'Experience is required'
    }),

  joinDate: Joi.date()
    .max('now')
    .required()
    .messages({
      'date.max': 'Join date cannot be in the future',
      'any.required': 'Join date is required'
    }),

  department: Joi.string()
    .max(50)
    .optional(),

  designation: Joi.string()
    .max(50)
    .optional(),

  specializations: Joi.array()
    .items(Joi.string())
    .optional(),

  certifications: Joi.array()
    .items(Joi.object({
      name: Joi.string().required(),
      issuer: Joi.string().required(),
      date: Joi.date().required(),
      expiryDate: Joi.date().optional(),
      certificateUrl: Joi.string().uri().optional()
    }))
    .optional(),

  schedule: Joi.object({
    monday: Joi.array().items(Joi.string()).optional(),
    tuesday: Joi.array().items(Joi.string()).optional(),
    wednesday: Joi.array().items(Joi.string()).optional(),
    thursday: Joi.array().items(Joi.string()).optional(),
    friday: Joi.array().items(Joi.string()).optional(),
    saturday: Joi.array().items(Joi.string()).optional(),
    sunday: Joi.array().items(Joi.string()).optional()
  }).optional(),

  isActive: Joi.boolean()
    .optional()
    .default(true)
});

// Teacher update validation schema (all fields optional)
const teacherUpdateSchema = Joi.object({
  employeeId: Joi.string()
    .pattern(/^[A-Z0-9]{3,10}$/)
    .optional()
    .messages({
      'string.pattern.base': 'Employee ID must be 3-10 uppercase letters or numbers'
    }),

  subjects: Joi.array()
    .items(Joi.string())
    .min(1)
    .optional()
    .messages({
      'array.min': 'At least one subject must be provided'
    }),

  qualification: Joi.string()
    .max(100)
    .optional()
    .messages({
      'string.max': 'Qualification cannot exceed 100 characters'
    }),

  experience: Joi.number()
    .integer()
    .min(0)
    .optional()
    .messages({
      'number.base': 'Experience must be a number',
      'number.integer': 'Experience must be an integer',
      'number.min': 'Experience cannot be negative'
    }),

  joinDate: Joi.date()
    .max('now')
    .optional()
    .messages({
      'date.max': 'Join date cannot be in the future'
    }),

  department: Joi.string()
    .max(50)
    .optional(),

  designation: Joi.string()
    .max(50)
    .optional(),

  specializations: Joi.array()
    .items(Joi.string())
    .optional(),

  certifications: Joi.array()
    .items(Joi.object({
      name: Joi.string().required(),
      issuer: Joi.string().required(),
      date: Joi.date().required(),
      expiryDate: Joi.date().optional(),
      certificateUrl: Joi.string().uri().optional()
    }))
    .optional(),

  schedule: Joi.object({
    monday: Joi.array().items(Joi.string()).optional(),
    tuesday: Joi.array().items(Joi.string()).optional(),
    wednesday: Joi.array().items(Joi.string()).optional(),
    thursday: Joi.array().items(Joi.string()).optional(),
    friday: Joi.array().items(Joi.string()).optional(),
    saturday: Joi.array().items(Joi.string()).optional(),
    sunday: Joi.array().items(Joi.string()).optional()
  }).optional(),

  isActive: Joi.boolean().optional()
}).min(1).messages({
  'object.min': 'At least one field must be provided for update'
});

// Validation for assigning/removing teacher from class
const classAssignmentSchema = Joi.object({
  classId: Joi.string()
    .required()
    .messages({
      'any.required': 'Class ID is required'
    })
});

// Validation for updating teacher subjects
const subjectsUpdateSchema = Joi.object({
  subjects: Joi.array()
    .items(Joi.string())
    .min(1)
    .required()
    .messages({
      'array.min': 'At least one subject must be provided',
      'any.required': 'Subjects are required'
    })
});

// Validation functions
const validateTeacher = (data) => {
  return teacherCreateSchema.validate(data, { abortEarly: false });
};

const validateTeacherUpdate = (data) => {
  return teacherUpdateSchema.validate(data, { abortEarly: false });
};

const validateClassAssignment = (data) => {
  return classAssignmentSchema.validate(data, { abortEarly: false });
};

const validateSubjectsUpdate = (data) => {
  return subjectsUpdateSchema.validate(data, { abortEarly: false });
};

module.exports = {
  validateTeacher,
  validateTeacherUpdate,
  validateClassAssignment,
  validateSubjectsUpdate,
  teacherCreateSchema,
  teacherUpdateSchema,
  classAssignmentSchema,
  subjectsUpdateSchema
}; 