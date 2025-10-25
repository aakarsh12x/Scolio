const express = require('express');
const router = express.Router();
const examController = require('../controllers/examController');

/**
 * @swagger
 * components:
 *   schemas:
 *     Exam:
 *       type: object
 *       required:
 *         - title
 *         - classId
 *         - teacherId
 *         - subject
 *         - examDate
 *         - totalMarks
 *         - examType
 *       properties:
 *         id:
 *           type: string
 *           description: Exam ID
 *         title:
 *           type: string
 *           description: Exam title
 *         classId:
 *           type: string
 *           description: Class ID
 *         teacherId:
 *           type: string
 *           description: Teacher ID
 *         subject:
 *           type: string
 *           description: Subject name
 *         examDate:
 *           type: string
 *           format: date
 *           description: Exam date
 *         duration:
 *           type: number
 *           description: Duration in minutes
 *         totalMarks:
 *           type: number
 *           description: Total marks
 *         examType:
 *           type: string
 *           enum: [quiz, test, midterm, final]
 *           description: Type of exam
 *         instructions:
 *           type: string
 *           description: Exam instructions
 */

// Create exam
router.post('/', examController.createExam);

// Get all exams
router.get('/', examController.getAllExams);

// Get exam by ID
router.get('/:id', examController.getExamById);

// Update exam
router.put('/:id', examController.updateExam);

// Delete exam
router.delete('/:id', examController.deleteExam);

// Add exam result
router.post('/:id/result', examController.addExamResult);

// Get exam results
router.get('/:id/results', examController.getExamResults);

// Get student exam history
router.get('/student/:studentId', examController.getStudentExamHistory);

module.exports = router; 