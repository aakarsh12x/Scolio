const Joi = require('joi');

// Validate attendance creation
const validateAttendance = (data) => {
  const schema = Joi.object({
    classId: Joi.string().required()
      .messages({
        'string.empty': 'Class ID is required',
        'any.required': 'Class ID is required'
      }),
    
    date: Joi.date().iso().required()
      .messages({
        'date.base': 'Date must be a valid date',
        'date.format': 'Date must be in ISO format (YYYY-MM-DD)',
        'any.required': 'Date is required'
      }),
    
    subject: Joi.string().allow(null, '').max(100)
      .messages({
        'string.max': 'Subject cannot exceed 100 characters'
      }),
    
    presentStudents: Joi.array().items(Joi.string())
      .messages({
        'array.base': 'Present students must be an array'
      }),
    
    absentStudents: Joi.array().items(Joi.string())
      .messages({
        'array.base': 'Absent students must be an array'
      }),
    
    notes: Joi.string().allow(null, '').max(500)
      .messages({
        'string.max': 'Notes cannot exceed 500 characters'
      }),
    
    totalStudents: Joi.number().integer().min(0)
      .messages({
        'number.base': 'Total students must be a number',
        'number.integer': 'Total students must be an integer',
        'number.min': 'Total students cannot be negative'
      })
  }).or('presentStudents', 'absentStudents')
    .messages({
      'object.missing': 'Either present students or absent students must be provided'
    });

  return schema.validate(data);
};

// Validate attendance update
const validateAttendanceUpdate = (data) => {
  const schema = Joi.object({
    classId: Joi.string()
      .messages({
        'string.empty': 'Class ID cannot be empty'
      }),
    
    date: Joi.date().iso()
      .messages({
        'date.base': 'Date must be a valid date',
        'date.format': 'Date must be in ISO format (YYYY-MM-DD)'
      }),
    
    subject: Joi.string().allow(null, '').max(100)
      .messages({
        'string.max': 'Subject cannot exceed 100 characters'
      }),
    
    presentStudents: Joi.array().items(Joi.string())
      .messages({
        'array.base': 'Present students must be an array'
      }),
    
    absentStudents: Joi.array().items(Joi.string())
      .messages({
        'array.base': 'Absent students must be an array'
      }),
    
    notes: Joi.string().allow(null, '').max(500)
      .messages({
        'string.max': 'Notes cannot exceed 500 characters'
      }),
    
    totalStudents: Joi.number().integer().min(0)
      .messages({
        'number.base': 'Total students must be a number',
        'number.integer': 'Total students must be an integer',
        'number.min': 'Total students cannot be negative'
      })
  });

  return schema.validate(data);
};

// Validate mark attendance
const validateMarkAttendance = (data) => {
  const schema = Joi.object({
    date: Joi.date().iso().required()
      .messages({
        'date.base': 'Date must be a valid date',
        'date.format': 'Date must be in ISO format (YYYY-MM-DD)',
        'any.required': 'Date is required'
      }),
    
    subject: Joi.string().allow(null, '').max(100)
      .messages({
        'string.max': 'Subject cannot exceed 100 characters'
      }),
    
    presentStudents: Joi.array().items(Joi.string())
      .messages({
        'array.base': 'Present students must be an array'
      }),
    
    absentStudents: Joi.array().items(Joi.string())
      .messages({
        'array.base': 'Absent students must be an array'
      }),
    
    notes: Joi.string().allow(null, '').max(500)
      .messages({
        'string.max': 'Notes cannot exceed 500 characters'
      })
  }).or('presentStudents', 'absentStudents')
    .messages({
      'object.missing': 'Either present students or absent students must be provided'
    });

  return schema.validate(data);
};

module.exports = {
  validateAttendance,
  validateAttendanceUpdate,
  validateMarkAttendance
}; 