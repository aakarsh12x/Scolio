const express = require('express');
const attendanceController = require('../controllers/attendanceController');
const router = express.Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     Attendance:
 *       type: object
 *       required:
 *         - classId
 *         - date
 *       properties:
 *         id:
 *           type: string
 *           description: Auto-generated attendance record ID
 *         classId:
 *           type: string
 *           description: ID of the class
 *         date:
 *           type: string
 *           format: date
 *           description: Date of attendance in ISO format (YYYY-MM-DD)
 *         subject:
 *           type: string
 *           description: Subject for which attendance was taken
 *         presentStudents:
 *           type: array
 *           items:
 *             type: string
 *           description: Array of student IDs who were present
 *         absentStudents:
 *           type: array
 *           items:
 *             type: string
 *           description: Array of student IDs who were absent
 *         totalStudents:
 *           type: integer
 *           description: Total number of students in the class
 *         notes:
 *           type: string
 *           description: Additional notes about the attendance
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 *
 *     AttendanceList:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *         message:
 *           type: string
 *         data:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/Attendance'
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
 * /attendance:
 *   get:
 *     summary: Get all attendance records with pagination and filtering
 *     tags: [Attendance]
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
 *         description: Number of records per page
 *       - in: query
 *         name: classId
 *         schema:
 *           type: string
 *         description: Filter by class ID
 *       - in: query
 *         name: date
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by specific date (YYYY-MM-DD)
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by start date (YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by end date (YYYY-MM-DD)
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           enum: [date, createdAt]
 *           default: date
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
 *         description: Attendance records retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/AttendanceList'
 */
router.get('/', attendanceController.getAllAttendance);

/**
 * @swagger
 * /attendance/{id}:
 *   get:
 *     summary: Get attendance record by ID
 *     tags: [Attendance]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Attendance record ID
 *     responses:
 *       200:
 *         description: Attendance record retrieved successfully
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
 *                   $ref: '#/components/schemas/Attendance'
 *       404:
 *         description: Attendance record not found
 */
router.get('/:id', attendanceController.getAttendanceById);

/**
 * @swagger
 * /attendance/class/{classId}:
 *   get:
 *     summary: Get attendance records for a specific class
 *     tags: [Attendance]
 *     parameters:
 *       - in: path
 *         name: classId
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
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *         description: Number of records per page
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by start date (YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by end date (YYYY-MM-DD)
 *     responses:
 *       200:
 *         description: Attendance records retrieved successfully
 *       404:
 *         description: Class not found
 */
router.get('/class/:classId', attendanceController.getClassAttendance);

/**
 * @swagger
 * /attendance/class/{classId}/stats:
 *   get:
 *     summary: Get attendance statistics for a class
 *     tags: [Attendance]
 *     parameters:
 *       - in: path
 *         name: classId
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by start date (YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by end date (YYYY-MM-DD)
 *     responses:
 *       200:
 *         description: Attendance statistics retrieved successfully
 *       404:
 *         description: Class not found
 */
router.get('/class/:classId/stats', attendanceController.getClassAttendanceStats);

/**
 * @swagger
 * /attendance/student/{studentId}:
 *   get:
 *     summary: Get attendance records for a specific student
 *     tags: [Attendance]
 *     parameters:
 *       - in: path
 *         name: studentId
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
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
 *         description: Number of records per page
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by start date (YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by end date (YYYY-MM-DD)
 *     responses:
 *       200:
 *         description: Attendance records retrieved successfully
 *       404:
 *         description: Student not found
 */
router.get('/student/:studentId', attendanceController.getStudentAttendance);

/**
 * @swagger
 * /attendance:
 *   post:
 *     summary: Create a new attendance record
 *     tags: [Attendance]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - classId
 *               - date
 *             properties:
 *               classId:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date
 *               subject:
 *                 type: string
 *               presentStudents:
 *                 type: array
 *                 items:
 *                   type: string
 *               absentStudents:
 *                 type: array
 *                 items:
 *                   type: string
 *               notes:
 *                 type: string
 *     responses:
 *       201:
 *         description: Attendance record created successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Class not found
 *       409:
 *         description: Attendance record for this class and date already exists
 */
router.post('/', attendanceController.createAttendance);

/**
 * @swagger
 * /attendance/class/{classId}/mark:
 *   post:
 *     summary: Mark attendance for a class
 *     tags: [Attendance]
 *     parameters:
 *       - in: path
 *         name: classId
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
 *             required:
 *               - date
 *             properties:
 *               date:
 *                 type: string
 *                 format: date
 *               subject:
 *                 type: string
 *               presentStudents:
 *                 type: array
 *                 items:
 *                   type: string
 *               absentStudents:
 *                 type: array
 *                 items:
 *                   type: string
 *               notes:
 *                 type: string
 *     responses:
 *       201:
 *         description: Attendance record created successfully
 *       200:
 *         description: Attendance record updated successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Class not found
 */
router.post('/class/:classId/mark', attendanceController.markAttendance);

/**
 * @swagger
 * /attendance/{id}:
 *   put:
 *     summary: Update attendance record
 *     tags: [Attendance]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Attendance record ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               classId:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date
 *               subject:
 *                 type: string
 *               presentStudents:
 *                 type: array
 *                 items:
 *                   type: string
 *               absentStudents:
 *                 type: array
 *                 items:
 *                   type: string
 *               notes:
 *                 type: string
 *     responses:
 *       200:
 *         description: Attendance record updated successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Attendance record not found
 *       409:
 *         description: Attendance record for this class and date already exists
 */
router.put('/:id', attendanceController.updateAttendance);

/**
 * @swagger
 * /attendance/{id}:
 *   delete:
 *     summary: Delete attendance record
 *     tags: [Attendance]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Attendance record ID
 *     responses:
 *       200:
 *         description: Attendance record deleted successfully
 *       404:
 *         description: Attendance record not found
 */
router.delete('/:id', attendanceController.deleteAttendance);

module.exports = router; 