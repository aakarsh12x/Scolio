const databaseService = require('../services/databaseService');
const { v4: uuidv4 } = require('uuid');

/**
 * Assignment Controller
 * Handles all assignment-related operations
 */

/**
 * Create a new assignment
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const createAssignment = async (req, res) => {
  try {
    const {
      title,
      description,
      classId,
      teacherId,
      subject,
      dueDate,
      attachments = [],
      totalMarks = 100
    } = req.body;

    // Validate required fields
    if (!title || !classId || !teacherId || !subject || !dueDate) {
      return res.error('Missing required fields', 400);
    }

    // Create assignment data
    const assignmentData = {
      id: uuidv4(),
      title,
      description,
      classId,
      teacherId,
      subject,
      dueDate,
      attachments,
      totalMarks,
      submissions: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    // Save to database
    const assignment = await databaseService.create('Assignments', assignmentData);

    res.success(assignment, 'Assignment created successfully', 201);
  } catch (error) {
    console.error('Error creating assignment:', error);
    res.error('Failed to create assignment', 500);
  }
};

/**
 * Get all assignments
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const getAllAssignments = async (req, res) => {
  try {
    const { classId, teacherId, subject, page = 1, limit = 10 } = req.query;

    let assignments = await databaseService.findAll('Assignments');

    // Apply filters
    if (classId) {
      assignments = assignments.filter(assignment => assignment.classId === classId);
    }
    if (teacherId) {
      assignments = assignments.filter(assignment => assignment.teacherId === teacherId);
    }
    if (subject) {
      assignments = assignments.filter(assignment => assignment.subject === subject);
    }

    // Pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedAssignments = assignments.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: assignments.length,
      pages: Math.ceil(assignments.length / limit),
      hasNext: endIndex < assignments.length,
      hasPrev: startIndex > 0
    };

    res.success(paginatedAssignments, 'Assignments retrieved successfully', 200, pagination);
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.error('Failed to fetch assignments', 500);
  }
};

/**
 * Get assignment by ID
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const getAssignmentById = async (req, res) => {
  try {
    const { id } = req.params;

    const assignment = await databaseService.findById('Assignments', id);

    if (!assignment) {
      return res.error('Assignment not found', 404);
    }

    res.success(assignment, 'Assignment retrieved successfully');
  } catch (error) {
    console.error('Error fetching assignment:', error);
    res.error('Failed to fetch assignment', 500);
  }
};

/**
 * Update assignment
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const updateAssignment = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    // Check if assignment exists
    const existingAssignment = await databaseService.findById('Assignments', id);
    if (!existingAssignment) {
      return res.error('Assignment not found', 404);
    }

    // Update assignment
    updateData.updatedAt = new Date().toISOString();
    const updatedAssignment = await databaseService.update('Assignments', id, updateData);

    res.success(updatedAssignment, 'Assignment updated successfully');
  } catch (error) {
    console.error('Error updating assignment:', error);
    res.error('Failed to update assignment', 500);
  }
};

/**
 * Delete assignment
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const deleteAssignment = async (req, res) => {
  try {
    const { id } = req.params;

    // Check if assignment exists
    const existingAssignment = await databaseService.findById('Assignments', id);
    if (!existingAssignment) {
      return res.error('Assignment not found', 404);
    }

    // Delete assignment
    await databaseService.delete('Assignments', id);

    res.success(null, 'Assignment deleted successfully');
  } catch (error) {
    console.error('Error deleting assignment:', error);
    res.error('Failed to delete assignment', 500);
  }
};

/**
 * Submit assignment
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const submitAssignment = async (req, res) => {
  try {
    const { id } = req.params;
    const { studentId, attachments = [], remarks = '' } = req.body;

    if (!studentId) {
      return res.error('Student ID is required', 400);
    }

    // Get assignment
    const assignment = await databaseService.findById('Assignments', id);
    if (!assignment) {
      return res.error('Assignment not found', 404);
    }

    // Check if student already submitted
    const existingSubmission = assignment.submissions.find(sub => sub.studentId === studentId);
    if (existingSubmission) {
      return res.error('Assignment already submitted by this student', 400);
    }

    // Create submission
    const submission = {
      studentId,
      submissionDate: new Date().toISOString(),
      attachments,
      remarks,
      grade: null,
      feedback: null,
      gradedAt: null,
      gradedBy: null
    };

    // Add submission to assignment
    assignment.submissions.push(submission);
    assignment.updatedAt = new Date().toISOString();

    // Update assignment
    const updatedAssignment = await databaseService.update('Assignments', id, assignment);

    res.success(updatedAssignment, 'Assignment submitted successfully');
  } catch (error) {
    console.error('Error submitting assignment:', error);
    res.error('Failed to submit assignment', 500);
  }
};

/**
 * Grade assignment submission
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const gradeSubmission = async (req, res) => {
  try {
    const { id } = req.params;
    const { studentId, grade, feedback, gradedBy } = req.body;

    if (!studentId || !grade || !gradedBy) {
      return res.error('Student ID, grade, and grader ID are required', 400);
    }

    // Get assignment
    const assignment = await databaseService.findById('Assignments', id);
    if (!assignment) {
      return res.error('Assignment not found', 404);
    }

    // Find submission
    const submissionIndex = assignment.submissions.findIndex(sub => sub.studentId === studentId);
    if (submissionIndex === -1) {
      return res.error('Submission not found', 404);
    }

    // Update submission
    assignment.submissions[submissionIndex].grade = grade;
    assignment.submissions[submissionIndex].feedback = feedback;
    assignment.submissions[submissionIndex].gradedAt = new Date().toISOString();
    assignment.submissions[submissionIndex].gradedBy = gradedBy;
    assignment.updatedAt = new Date().toISOString();

    // Update assignment
    const updatedAssignment = await databaseService.update('Assignments', id, assignment);

    res.success(updatedAssignment, 'Assignment graded successfully');
  } catch (error) {
    console.error('Error grading assignment:', error);
    res.error('Failed to grade assignment', 500);
  }
};

/**
 * Get assignments for a student
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const getStudentAssignments = async (req, res) => {
  try {
    const { studentId } = req.params;
    const { status, subject, page = 1, limit = 10 } = req.query;

    // Get all assignments
    let assignments = await databaseService.findAll('Assignments');

    // Filter assignments for student's classes
    // Note: This would need to be enhanced with proper class-student relationships
    assignments = assignments.map(assignment => {
      const submission = assignment.submissions.find(sub => sub.studentId === studentId);
      return {
        ...assignment,
        submission: submission || null,
        isSubmitted: !!submission,
        isGraded: submission && submission.grade !== null
      };
    });

    // Apply filters
    if (status === 'submitted') {
      assignments = assignments.filter(assignment => assignment.isSubmitted);
    } else if (status === 'pending') {
      assignments = assignments.filter(assignment => !assignment.isSubmitted);
    } else if (status === 'graded') {
      assignments = assignments.filter(assignment => assignment.isGraded);
    }

    if (subject) {
      assignments = assignments.filter(assignment => assignment.subject === subject);
    }

    // Pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedAssignments = assignments.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: assignments.length,
      pages: Math.ceil(assignments.length / limit),
      hasNext: endIndex < assignments.length,
      hasPrev: startIndex > 0
    };

    res.success(paginatedAssignments, 'Student assignments retrieved successfully', 200, pagination);
  } catch (error) {
    console.error('Error fetching student assignments:', error);
    res.error('Failed to fetch student assignments', 500);
  }
};

module.exports = {
  createAssignment,
  getAllAssignments,
  getAssignmentById,
  updateAssignment,
  deleteAssignment,
  submitAssignment,
  gradeSubmission,
  getStudentAssignments
}; 