const express = require('express');
const classController = require('../controllers/classController');
const router = express.Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     Class:
 *       type: object
 *       required:
 *         - name
 *         - section
 *         - academicYear
 *         - grade
 *       properties:
 *         id:
 *           type: string
 *           description: Auto-generated class ID
 *         name:
 *           type: string
 *           description: Class name
 *         section:
 *           type: string
 *           description: Class section (e.g., A, B, C)
 *         academicYear:
 *           type: string
 *           description: Academic year in format YYYY-YYYY
 *         grade:
 *           type: integer
 *           description: Grade level (1-12)
 *         teacherId:
 *           type: string
 *           description: ID of the teacher assigned to this class
 *         roomNumber:
 *           type: string
 *           description: Room number where the class is held
 *         capacity:
 *           type: integer
 *           description: Maximum number of students
 *         description:
 *           type: string
 *           description: Class description
 *         schedule:
 *           type: object
 *           properties:
 *             startTime:
 *               type: string
 *             endTime:
 *               type: string
 *             days:
 *               type: array
 *               items:
 *                 type: string
 *         timetable:
 *           type: object
 *           properties:
 *             monday:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   subject:
 *                     type: string
 *                   startTime:
 *                     type: string
 *                   endTime:
 *                     type: string
 *                   teacherId:
 *                     type: string
 *             tuesday:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/TimetableEntry'
 *             wednesday:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/TimetableEntry'
 *             thursday:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/TimetableEntry'
 *             friday:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/TimetableEntry'
 *             saturday:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/TimetableEntry'
 *             sunday:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/TimetableEntry'
 *         isActive:
 *           type: boolean
 *           description: Whether the class is active
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 *
 *     TimetableEntry:
 *       type: object
 *       properties:
 *         subject:
 *           type: string
 *         startTime:
 *           type: string
 *         endTime:
 *           type: string
 *         teacherId:
 *           type: string
 *
 *     ClassList:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *         message:
 *           type: string
 *         data:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/Class'
 *         pagination:
 *           type: object
 *           properties:
 *             page:
 *               type: integer
 *             limit:
 *               type: integer
 *             total:
 *               type: integer
 *             pages:
 *               type: integer
 *             hasNext:
 *               type: boolean
 *             hasPrev:
 *               type: boolean
 */

/**
 * @swagger
 * /classes:
 *   get:
 *     summary: Get all classes with pagination and filtering
 *     tags: [Classes]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *         description: Number of classes per page
 *       - in: query
 *         name: academicYear
 *         schema:
 *           type: string
 *         description: Filter by academic year (e.g., 2023-2024)
 *       - in: query
 *         name: isActive
 *         schema:
 *           type: boolean
 *           default: true
 *         description: Filter by active status
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           enum: [createdAt, name, grade]
 *           default: createdAt
 *         description: Sort field
 *       - in: query
 *         name: sortOrder
 *         schema:
 *           type: string
 *           enum: [ASC, DESC]
 *           default: DESC
 *         description: Sort order
 *     responses:
 *       200:
 *         description: Classes retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ClassList'
 */
router.get('/', classController.getAllClasses);

/**
 * @swagger
 * /classes/search:
 *   get:
 *     summary: Search classes
 *     tags: [Classes]
 *     parameters:
 *       - in: query
 *         name: query
 *         required: true
 *         schema:
 *           type: string
 *           minLength: 2
 *         description: Search query
 *       - in: query
 *         name: academicYear
 *         schema:
 *           type: string
 *         description: Filter by academic year (e.g., 2023-2024)
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *     responses:
 *       200:
 *         description: Search results retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ClassList'
 *       400:
 *         description: Search query is required
 */
router.get('/search', classController.searchClasses);

/**
 * @swagger
 * /classes/academic-year/{academicYear}:
 *   get:
 *     summary: Get classes by academic year
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: academicYear
 *         required: true
 *         schema:
 *           type: string
 *         description: Academic year (e.g., 2023-2024)
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *     responses:
 *       200:
 *         description: Classes retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ClassList'
 */
router.get('/academic-year/:academicYear', classController.getClassesByAcademicYear);

/**
 * @swagger
 * /classes/{id}:
 *   get:
 *     summary: Get class by ID
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *     responses:
 *       200:
 *         description: Class retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/Class'
 *       404:
 *         description: Class not found
 */
router.get('/:id', classController.getClassById);

/**
 * @swagger
 * /classes/{id}/students:
 *   get:
 *     summary: Get students in a class
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *     responses:
 *       200:
 *         description: Students retrieved successfully
 *       404:
 *         description: Class not found
 */
router.get('/:id/students', classController.getClassStudents);

/**
 * @swagger
 * /classes/{id}/timetable:
 *   get:
 *     summary: Get class timetable
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *     responses:
 *       200:
 *         description: Timetable retrieved successfully
 *       404:
 *         description: Class not found
 */
router.get('/:id/timetable', classController.getClassTimetable);

/**
 * @swagger
 * /classes/{id}/stats:
 *   get:
 *     summary: Get class statistics
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *     responses:
 *       200:
 *         description: Class statistics retrieved successfully
 *       404:
 *         description: Class not found
 */
router.get('/:id/stats', classController.getClassStats);

/**
 * @swagger
 * /classes:
 *   post:
 *     summary: Create a new class
 *     tags: [Classes]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Class'
 *     responses:
 *       201:
 *         description: Class created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/Class'
 *       400:
 *         description: Validation error
 *       409:
 *         description: Class with same name, section and academic year already exists
 */
router.post('/', classController.createClass);

/**
 * @swagger
 * /classes/{id}:
 *   put:
 *     summary: Update class
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Class'
 *     responses:
 *       200:
 *         description: Class updated successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Class not found
 *       409:
 *         description: Class with same name, section and academic year already exists
 */
router.put('/:id', classController.updateClass);

/**
 * @swagger
 * /classes/{id}/timetable:
 *   put:
 *     summary: Update class timetable
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               timetable:
 *                 type: object
 *                 properties:
 *                   monday:
 *                     type: array
 *                     items:
 *                       $ref: '#/components/schemas/TimetableEntry'
 *                   tuesday:
 *                     type: array
 *                     items:
 *                       $ref: '#/components/schemas/TimetableEntry'
 *                   wednesday:
 *                     type: array
 *                     items:
 *                       $ref: '#/components/schemas/TimetableEntry'
 *                   thursday:
 *                     type: array
 *                     items:
 *                       $ref: '#/components/schemas/TimetableEntry'
 *                   friday:
 *                     type: array
 *                     items:
 *                       $ref: '#/components/schemas/TimetableEntry'
 *                   saturday:
 *                     type: array
 *                     items:
 *                       $ref: '#/components/schemas/TimetableEntry'
 *                   sunday:
 *                     type: array
 *                     items:
 *                       $ref: '#/components/schemas/TimetableEntry'
 *     responses:
 *       200:
 *         description: Timetable updated successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Class not found
 */
router.put('/:id/timetable', classController.updateClassTimetable);

/**
 * @swagger
 * /classes/{id}:
 *   delete:
 *     summary: Delete class (soft delete)
 *     tags: [Classes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *     responses:
 *       200:
 *         description: Class deactivated successfully
 *       400:
 *         description: Cannot delete class with active students
 *       404:
 *         description: Class not found
 */
router.delete('/:id', classController.deleteClass);

module.exports = router; 