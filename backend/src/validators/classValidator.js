const Joi = require('joi');

// Validate class creation
const validateClass = (data) => {
  const schema = Joi.object({
    name: Joi.string().required().trim().max(100)
      .messages({
        'string.empty': 'Class name is required',
        'string.max': 'Class name cannot exceed 100 characters',
        'any.required': 'Class name is required'
      }),
    
    section: Joi.string().required().trim().max(20)
      .messages({
        'string.empty': 'Section is required',
        'string.max': 'Section cannot exceed 20 characters',
        'any.required': 'Section is required'
      }),
    
    academicYear: Joi.string().required().trim().pattern(/^\d{4}-\d{4}$/)
      .messages({
        'string.empty': 'Academic year is required',
        'string.pattern.base': 'Academic year must be in format YYYY-YYYY',
        'any.required': 'Academic year is required'
      }),
    
    grade: Joi.number().integer().min(1).max(12).required()
      .messages({
        'number.base': 'Grade must be a number',
        'number.integer': 'Grade must be an integer',
        'number.min': 'Grade must be at least 1',
        'number.max': 'Grade cannot exceed 12',
        'any.required': 'Grade is required'
      }),
    
    teacherId: Joi.string().allow(null, '')
      .messages({
        'string.base': 'Teacher ID must be a string'
      }),
    
    roomNumber: Joi.string().allow(null, '').max(20)
      .messages({
        'string.max': 'Room number cannot exceed 20 characters'
      }),
    
    capacity: Joi.number().integer().min(1).max(100).default(30)
      .messages({
        'number.base': 'Capacity must be a number',
        'number.integer': 'Capacity must be an integer',
        'number.min': 'Capacity must be at least 1',
        'number.max': 'Capacity cannot exceed 100'
      }),
    
    description: Joi.string().allow(null, '').max(500)
      .messages({
        'string.max': 'Description cannot exceed 500 characters'
      }),
    
    schedule: Joi.object({
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/),
      days: Joi.array().items(
        Joi.string().valid('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')
      )
    }).allow(null),
    
    timetable: Joi.object({
      monday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      tuesday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      wednesday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      thursday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      friday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      saturday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      sunday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      }))
    }).allow(null)
  });

  return schema.validate(data);
};

// Validate class update
const validateClassUpdate = (data) => {
  const schema = Joi.object({
    name: Joi.string().trim().max(100)
      .messages({
        'string.max': 'Class name cannot exceed 100 characters'
      }),
    
    section: Joi.string().trim().max(20)
      .messages({
        'string.max': 'Section cannot exceed 20 characters'
      }),
    
    academicYear: Joi.string().trim().pattern(/^\d{4}-\d{4}$/)
      .messages({
        'string.pattern.base': 'Academic year must be in format YYYY-YYYY'
      }),
    
    grade: Joi.number().integer().min(1).max(12)
      .messages({
        'number.base': 'Grade must be a number',
        'number.integer': 'Grade must be an integer',
        'number.min': 'Grade must be at least 1',
        'number.max': 'Grade cannot exceed 12'
      }),
    
    teacherId: Joi.string().allow(null, '')
      .messages({
        'string.base': 'Teacher ID must be a string'
      }),
    
    roomNumber: Joi.string().allow(null, '').max(20)
      .messages({
        'string.max': 'Room number cannot exceed 20 characters'
      }),
    
    capacity: Joi.number().integer().min(1).max(100)
      .messages({
        'number.base': 'Capacity must be a number',
        'number.integer': 'Capacity must be an integer',
        'number.min': 'Capacity must be at least 1',
        'number.max': 'Capacity cannot exceed 100'
      }),
    
    description: Joi.string().allow(null, '').max(500)
      .messages({
        'string.max': 'Description cannot exceed 500 characters'
      }),
    
    schedule: Joi.object({
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/),
      days: Joi.array().items(
        Joi.string().valid('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')
      )
    }).allow(null),
    
    timetable: Joi.object({
      monday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      tuesday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      wednesday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      thursday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      friday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      saturday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      })),
      sunday: Joi.array().items(Joi.object({
        subject: Joi.string().required(),
        startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
        teacherId: Joi.string().allow(null, '')
      }))
    }).allow(null),
    
    isActive: Joi.boolean()
  });

  return schema.validate(data);
};

// Validate timetable update
const validateTimetable = (data) => {
  const schema = Joi.object({
    monday: Joi.array().items(Joi.object({
      subject: Joi.string().required(),
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      teacherId: Joi.string().allow(null, '')
    })).default([]),
    tuesday: Joi.array().items(Joi.object({
      subject: Joi.string().required(),
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      teacherId: Joi.string().allow(null, '')
    })).default([]),
    wednesday: Joi.array().items(Joi.object({
      subject: Joi.string().required(),
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      teacherId: Joi.string().allow(null, '')
    })).default([]),
    thursday: Joi.array().items(Joi.object({
      subject: Joi.string().required(),
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      teacherId: Joi.string().allow(null, '')
    })).default([]),
    friday: Joi.array().items(Joi.object({
      subject: Joi.string().required(),
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      teacherId: Joi.string().allow(null, '')
    })).default([]),
    saturday: Joi.array().items(Joi.object({
      subject: Joi.string().required(),
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      teacherId: Joi.string().allow(null, '')
    })).default([]),
    sunday: Joi.array().items(Joi.object({
      subject: Joi.string().required(),
      startTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      endTime: Joi.string().pattern(/^([01]\d|2[0-3]):([0-5]\d)$/).required(),
      teacherId: Joi.string().allow(null, '')
    })).default([])
  });

  return schema.validate(data);
};

module.exports = {
  validateClass,
  validateClassUpdate,
  validateTimetable
}; 