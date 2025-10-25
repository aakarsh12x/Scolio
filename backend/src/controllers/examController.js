const databaseService = require('../services/databaseService');
const { v4: uuidv4 } = require('uuid');

/**
 * Exam Controller
 * Handles all exam-related operations
 */

/**
 * Create a new exam
 */
const createExam = async (req, res) => {
  try {
    const {
      title,
      classId,
      teacherId,
      subject,
      examDate,
      duration,
      totalMarks,
      examType,
      instructions = ''
    } = req.body;

    // Validate required fields
    if (!title || !classId || !teacherId || !subject || !examDate || !totalMarks || !examType) {
      return res.error('Missing required fields', 400);
    }

    // Validate exam type
    const validExamTypes = ['quiz', 'test', 'midterm', 'final'];
    if (!validExamTypes.includes(examType)) {
      return res.error('Invalid exam type', 400);
    }

    // Create exam data
    const examData = {
      id: uuidv4(),
      title,
      classId,
      teacherId,
      subject,
      examDate,
      duration: duration || 60, // Default 60 minutes
      totalMarks,
      examType,
      instructions,
      results: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    // Save to database
    const exam = await databaseService.create('Exams', examData);

    res.success(exam, 'Exam created successfully', 201);
  } catch (error) {
    console.error('Error creating exam:', error);
    res.error('Failed to create exam', 500);
  }
};

/**
 * Get all exams
 */
const getAllExams = async (req, res) => {
  try {
    const { classId, teacherId, subject, examType, page = 1, limit = 10 } = req.query;

    let exams = await databaseService.findAll('Exams');

    // Apply filters
    if (classId) {
      exams = exams.filter(exam => exam.classId === classId);
    }
    if (teacherId) {
      exams = exams.filter(exam => exam.teacherId === teacherId);
    }
    if (subject) {
      exams = exams.filter(exam => exam.subject === subject);
    }
    if (examType) {
      exams = exams.filter(exam => exam.examType === examType);
    }

    // Sort by exam date
    exams.sort((a, b) => new Date(b.examDate) - new Date(a.examDate));

    // Pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedExams = exams.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: exams.length,
      pages: Math.ceil(exams.length / limit),
      hasNext: endIndex < exams.length,
      hasPrev: startIndex > 0
    };

    res.success(paginatedExams, 'Exams retrieved successfully', 200, pagination);
  } catch (error) {
    console.error('Error fetching exams:', error);
    res.error('Failed to fetch exams', 500);
  }
};

/**
 * Get exam by ID
 */
const getExamById = async (req, res) => {
  try {
    const { id } = req.params;

    const exam = await databaseService.findById('Exams', id);

    if (!exam) {
      return res.error('Exam not found', 404);
    }

    res.success(exam, 'Exam retrieved successfully');
  } catch (error) {
    console.error('Error fetching exam:', error);
    res.error('Failed to fetch exam', 500);
  }
};

/**
 * Update exam
 */
const updateExam = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    // Check if exam exists
    const existingExam = await databaseService.findById('Exams', id);
    if (!existingExam) {
      return res.error('Exam not found', 404);
    }

    // Validate exam type if provided
    if (updateData.examType) {
      const validExamTypes = ['quiz', 'test', 'midterm', 'final'];
      if (!validExamTypes.includes(updateData.examType)) {
        return res.error('Invalid exam type', 400);
      }
    }

    // Update exam
    updateData.updatedAt = new Date().toISOString();
    const updatedExam = await databaseService.update('Exams', id, updateData);

    res.success(updatedExam, 'Exam updated successfully');
  } catch (error) {
    console.error('Error updating exam:', error);
    res.error('Failed to update exam', 500);
  }
};

/**
 * Delete exam
 */
const deleteExam = async (req, res) => {
  try {
    const { id } = req.params;

    // Check if exam exists
    const existingExam = await databaseService.findById('Exams', id);
    if (!existingExam) {
      return res.error('Exam not found', 404);
    }

    // Delete exam
    await databaseService.delete('Exams', id);

    res.success(null, 'Exam deleted successfully');
  } catch (error) {
    console.error('Error deleting exam:', error);
    res.error('Failed to delete exam', 500);
  }
};

/**
 * Add exam result
 */
const addExamResult = async (req, res) => {
  try {
    const { id } = req.params;
    const { studentId, marksObtained, remarks = '' } = req.body;

    if (!studentId || marksObtained === undefined) {
      return res.error('Student ID and marks obtained are required', 400);
    }

    // Get exam
    const exam = await databaseService.findById('Exams', id);
    if (!exam) {
      return res.error('Exam not found', 404);
    }

    // Validate marks
    if (marksObtained < 0 || marksObtained > exam.totalMarks) {
      return res.error(`Marks should be between 0 and ${exam.totalMarks}`, 400);
    }

    // Check if result already exists
    const existingResultIndex = exam.results.findIndex(result => result.studentId === studentId);
    
    // Calculate grade
    const percentage = (marksObtained / exam.totalMarks) * 100;
    let grade;
    if (percentage >= 90) grade = 'A+';
    else if (percentage >= 80) grade = 'A';
    else if (percentage >= 70) grade = 'B+';
    else if (percentage >= 60) grade = 'B';
    else if (percentage >= 50) grade = 'C+';
    else if (percentage >= 40) grade = 'C';
    else grade = 'F';

    const result = {
      studentId,
      marksObtained,
      grade,
      percentage: Math.round(percentage * 100) / 100,
      remarks,
      createdAt: new Date().toISOString()
    };

    if (existingResultIndex !== -1) {
      // Update existing result
      exam.results[existingResultIndex] = result;
    } else {
      // Add new result
      exam.results.push(result);
    }

    exam.updatedAt = new Date().toISOString();

    // Update exam
    const updatedExam = await databaseService.update('Exams', id, exam);

    res.success(updatedExam, 'Exam result added successfully');
  } catch (error) {
    console.error('Error adding exam result:', error);
    res.error('Failed to add exam result', 500);
  }
};

/**
 * Get exam results
 */
const getExamResults = async (req, res) => {
  try {
    const { id } = req.params;

    const exam = await databaseService.findById('Exams', id);
    if (!exam) {
      return res.error('Exam not found', 404);
    }

    // Calculate statistics
    const results = exam.results;
    const totalStudents = results.length;
    
    if (totalStudents === 0) {
      return res.success({
        exam: {
          id: exam.id,
          title: exam.title,
          subject: exam.subject,
          totalMarks: exam.totalMarks
        },
        results: [],
        statistics: {
          totalStudents: 0,
          averageMarks: 0,
          highestMarks: 0,
          lowestMarks: 0,
          passPercentage: 0
        }
      }, 'Exam results retrieved successfully');
    }

    const totalMarks = results.reduce((sum, result) => sum + result.marksObtained, 0);
    const averageMarks = Math.round((totalMarks / totalStudents) * 100) / 100;
    const highestMarks = Math.max(...results.map(r => r.marksObtained));
    const lowestMarks = Math.min(...results.map(r => r.marksObtained));
    const passedStudents = results.filter(r => r.grade !== 'F').length;
    const passPercentage = Math.round((passedStudents / totalStudents) * 100 * 100) / 100;

    const statistics = {
      totalStudents,
      averageMarks,
      highestMarks,
      lowestMarks,
      passPercentage
    };

    res.success({
      exam: {
        id: exam.id,
        title: exam.title,
        subject: exam.subject,
        totalMarks: exam.totalMarks,
        examDate: exam.examDate
      },
      results,
      statistics
    }, 'Exam results retrieved successfully');
  } catch (error) {
    console.error('Error fetching exam results:', error);
    res.error('Failed to fetch exam results', 500);
  }
};

/**
 * Get student exam history
 */
const getStudentExamHistory = async (req, res) => {
  try {
    const { studentId } = req.params;
    const { subject, examType, page = 1, limit = 10 } = req.query;

    // Get all exams
    let exams = await databaseService.findAll('Exams');

    // Filter exams that have results for this student
    let studentExams = exams.map(exam => {
      const studentResult = exam.results.find(result => result.studentId === studentId);
      if (studentResult) {
        return {
          examId: exam.id,
          title: exam.title,
          subject: exam.subject,
          examType: exam.examType,
          examDate: exam.examDate,
          totalMarks: exam.totalMarks,
          result: studentResult
        };
      }
      return null;
    }).filter(exam => exam !== null);

    // Apply filters
    if (subject) {
      studentExams = studentExams.filter(exam => exam.subject === subject);
    }
    if (examType) {
      studentExams = studentExams.filter(exam => exam.examType === examType);
    }

    // Sort by exam date (newest first)
    studentExams.sort((a, b) => new Date(b.examDate) - new Date(a.examDate));

    // Pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedExams = studentExams.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: studentExams.length,
      pages: Math.ceil(studentExams.length / limit),
      hasNext: endIndex < studentExams.length,
      hasPrev: startIndex > 0
    };

    res.success(paginatedExams, 'Student exam history retrieved successfully', 200, pagination);
  } catch (error) {
    console.error('Error fetching student exam history:', error);
    res.error('Failed to fetch student exam history', 500);
  }
};

module.exports = {
  createExam,
  getAllExams,
  getExamById,
  updateExam,
  deleteExam,
  addExamResult,
  getExamResults,
  getStudentExamHistory
}; 