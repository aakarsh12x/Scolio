const express = require('express');
const router = express.Router();
const assignmentController = require('../controllers/assignmentController');

/**
 * @swagger
 * components:
 *   schemas:
 *     Assignment:
 *       type: object
 *       required:
 *         - title
 *         - classId
 *         - teacherId
 *         - subject
 *         - dueDate
 *       properties:
 *         id:
 *           type: string
 *           description: Assignment ID
 *         title:
 *           type: string
 *           description: Assignment title
 *         description:
 *           type: string
 *           description: Assignment description
 *         classId:
 *           type: string
 *           description: Class ID
 *         teacherId:
 *           type: string
 *           description: Teacher ID
 *         subject:
 *           type: string
 *           description: Subject name
 *         dueDate:
 *           type: string
 *           format: date
 *           description: Due date
 *         attachments:
 *           type: array
 *           items:
 *             type: string
 *           description: File attachments
 *         totalMarks:
 *           type: number
 *           description: Total marks
 *         submissions:
 *           type: array
 *           items:
 *             type: object
 *           description: Student submissions
 */

/**
 * @swagger
 * /api/assignments:
 *   post:
 *     summary: Create a new assignment
 *     tags: [Assignments]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Assignment'
 *     responses:
 *       201:
 *         description: Assignment created successfully
 *       400:
 *         description: Bad request
 *       500:
 *         description: Server error
 */
router.post('/', assignmentController.createAssignment);

/**
 * @swagger
 * /api/assignments:
 *   get:
 *     summary: Get all assignments
 *     tags: [Assignments]
 *     parameters:
 *       - in: query
 *         name: classId
 *         schema:
 *           type: string
 *         description: Filter by class ID
 *       - in: query
 *         name: teacherId
 *         schema:
 *           type: string
 *         description: Filter by teacher ID
 *       - in: query
 *         name: subject
 *         schema:
 *           type: string
 *         description: Filter by subject
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *         description: Items per page
 *     responses:
 *       200:
 *         description: List of assignments
 *       500:
 *         description: Server error
 */
router.get('/', assignmentController.getAllAssignments);

/**
 * @swagger
 * /api/assignments/{id}:
 *   get:
 *     summary: Get assignment by ID
 *     tags: [Assignments]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Assignment ID
 *     responses:
 *       200:
 *         description: Assignment details
 *       404:
 *         description: Assignment not found
 *       500:
 *         description: Server error
 */
router.get('/:id', assignmentController.getAssignmentById);

/**
 * @swagger
 * /api/assignments/{id}:
 *   put:
 *     summary: Update assignment
 *     tags: [Assignments]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Assignment ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Assignment'
 *     responses:
 *       200:
 *         description: Assignment updated successfully
 *       404:
 *         description: Assignment not found
 *       500:
 *         description: Server error
 */
router.put('/:id', assignmentController.updateAssignment);

/**
 * @swagger
 * /api/assignments/{id}:
 *   delete:
 *     summary: Delete assignment
 *     tags: [Assignments]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Assignment ID
 *     responses:
 *       200:
 *         description: Assignment deleted successfully
 *       404:
 *         description: Assignment not found
 *       500:
 *         description: Server error
 */
router.delete('/:id', assignmentController.deleteAssignment);

/**
 * @swagger
 * /api/assignments/{id}/submit:
 *   post:
 *     summary: Submit assignment
 *     tags: [Assignments]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Assignment ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - studentId
 *             properties:
 *               studentId:
 *                 type: string
 *               attachments:
 *                 type: array
 *                 items:
 *                   type: string
 *               remarks:
 *                 type: string
 *     responses:
 *       200:
 *         description: Assignment submitted successfully
 *       400:
 *         description: Bad request
 *       404:
 *         description: Assignment not found
 *       500:
 *         description: Server error
 */
router.post('/:id/submit', assignmentController.submitAssignment);

/**
 * @swagger
 * /api/assignments/{id}/grade:
 *   post:
 *     summary: Grade assignment submission
 *     tags: [Assignments]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Assignment ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - studentId
 *               - grade
 *               - gradedBy
 *             properties:
 *               studentId:
 *                 type: string
 *               grade:
 *                 type: string
 *               feedback:
 *                 type: string
 *               gradedBy:
 *                 type: string
 *     responses:
 *       200:
 *         description: Assignment graded successfully
 *       400:
 *         description: Bad request
 *       404:
 *         description: Assignment or submission not found
 *       500:
 *         description: Server error
 */
router.post('/:id/grade', assignmentController.gradeSubmission);

module.exports = router; 