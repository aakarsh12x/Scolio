const express = require('express');
const studentController = require('../controllers/studentController');
const router = express.Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     Student:
 *       type: object
 *       required:
 *         - username
 *         - studentId
 *         - rollNumber
 *         - admissionDate
 *         - academicYear
 *       properties:
 *         username:
 *           type: string
 *           description: Username of the user account (must exist)
 *         studentId:
 *           type: string
 *           description: Unique student ID
 *         rollNumber:
 *           type: string
 *           description: Roll number in class
 *         classId:
 *           type: string
 *           description: ID of the class the student belongs to
 *         section:
 *           type: string
 *           description: Section within the class
 *         admissionDate:
 *           type: string
 *           format: date
 *           description: Date of admission
 *         parentId:
 *           type: string
 *           description: ID of the parent/guardian
 *         academicYear:
 *           type: string
 *           description: Academic year (format YYYY-YYYY)
 *         bloodGroup:
 *           type: string
 *           enum: [A+, A-, B+, B-, AB+, AB-, O+, O-]
 *           description: Blood group
 *         healthInfo:
 *           type: object
 *           properties:
 *             allergies:
 *               type: array
 *               items:
 *                 type: string
 *             medicalConditions:
 *               type: array
 *               items:
 *                 type: string
 *             medications:
 *               type: array
 *               items:
 *                 type: string
 *             emergencyContact:
 *               type: string
 *         transportInfo:
 *           type: object
 *           properties:
 *             busNumber:
 *               type: string
 *             routeNumber:
 *               type: string
 *             pickupPoint:
 *               type: string
 *             dropPoint:
 *               type: string
 *         previousSchool:
 *           type: string
 *           description: Name of previous school
 *         achievements:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               description:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date
 *               category:
 *                 type: string
 *         isActive:
 *           type: boolean
 *           description: Whether the student account is active
 *
 *     StudentWithInfo:
 *       allOf:
 *         - $ref: '#/components/schemas/Student'
 *         - type: object
 *           properties:
 *             userInfo:
 *               type: object
 *               properties:
 *                 firstName:
 *                   type: string
 *                 lastName:
 *                   type: string
 *                 email:
 *                   type: string
 *                 phone:
 *                   type: string
 *                 avatarUrl:
 *                   type: string
 *             classInfo:
 *               type: object
 *               properties:
 *                 name:
 *                   type: string
 *                 section:
 *                   type: string
 *                 academicYear:
 *                   type: string
 *             parentInfo:
 *               type: object
 *
 *     StudentList:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *         message:
 *           type: string
 *         data:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/StudentWithInfo'
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
 * /students:
 *   get:
 *     summary: Get all students with pagination and filtering
 *     tags: [Students]
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
 *         description: Number of students per page
 *       - in: query
 *         name: classId
 *         schema:
 *           type: string
 *         description: Filter by class ID
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
 *         description: Students retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/StudentList'
 */
router.get('/', studentController.getAllStudents);

/**
 * @swagger
 * /students/search:
 *   get:
 *     summary: Search students
 *     tags: [Students]
 *     parameters:
 *       - in: query
 *         name: query
 *         required: true
 *         schema:
 *           type: string
 *           minLength: 2
 *         description: Search query
 *       - in: query
 *         name: classId
 *         schema:
 *           type: string
 *         description: Filter by class ID
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
 *               $ref: '#/components/schemas/StudentList'
 *       400:
 *         description: Search query is required
 */
router.get('/search', studentController.searchStudents);

/**
 * @swagger
 * /students/class/{classId}:
 *   get:
 *     summary: Get students by class
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: classId
 *         required: true
 *         schema:
 *           type: string
 *         description: Class ID to filter by
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
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/StudentList'
 *       404:
 *         description: Class not found
 */
router.get('/class/:classId', studentController.getStudentsByClass);

/**
 * @swagger
 * /students/{id}:
 *   get:
 *     summary: Get student by ID
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
 *     responses:
 *       200:
 *         description: Student retrieved successfully
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
 *                   $ref: '#/components/schemas/StudentWithInfo'
 *       404:
 *         description: Student not found
 */
router.get('/:id', studentController.getStudentById);

/**
 * @swagger
 * /students/{id}/attendance:
 *   get:
 *     summary: Get student's attendance records
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Start date for filtering (YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: End date for filtering (YYYY-MM-DD)
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
 *         description: Student attendance records retrieved successfully
 *       404:
 *         description: Student not found
 */
router.get('/:id/attendance', studentController.getStudentAttendance);

/**
 * @swagger
 * /students/{id}/assignments:
 *   get:
 *     summary: Get student's assignments
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [pending, submitted, overdue, all]
 *           default: all
 *         description: Filter by assignment status
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
 *         description: Student assignments retrieved successfully
 *       404:
 *         description: Student not found
 */
router.get('/:id/assignments', studentController.getStudentAssignments);

/**
 * @swagger
 * /students/{id}/exams:
 *   get:
 *     summary: Get student's exam results
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
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
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *     responses:
 *       200:
 *         description: Student exam results retrieved successfully
 *       404:
 *         description: Student not found
 */
router.get('/:id/exams', studentController.getStudentExams);

/**
 * @swagger
 * /students/{id}/timetable:
 *   get:
 *     summary: Get student's timetable
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
 *     responses:
 *       200:
 *         description: Student timetable retrieved successfully
 *       404:
 *         description: Student not found
 *       400:
 *         description: Student is not assigned to any class
 */
router.get('/:id/timetable', studentController.getStudentTimetable);

/**
 * @swagger
 * /students/{id}/dashboard:
 *   get:
 *     summary: Get student dashboard data
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
 *     responses:
 *       200:
 *         description: Student dashboard data retrieved successfully
 *       404:
 *         description: Student not found
 */
router.get('/:id/dashboard', studentController.getStudentDashboard);

/**
 * @swagger
 * /students:
 *   post:
 *     summary: Create a new student
 *     tags: [Students]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Student'
 *     responses:
 *       201:
 *         description: Student created successfully
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
 *                   $ref: '#/components/schemas/StudentWithInfo'
 *       400:
 *         description: Validation error
 *       404:
 *         description: User, class, or parent not found
 *       409:
 *         description: Student profile already exists
 */
router.post('/', studentController.createStudent);

/**
 * @swagger
 * /students/{id}:
 *   put:
 *     summary: Update student
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Student'
 *     responses:
 *       200:
 *         description: Student updated successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Student, class, or parent not found
 */
router.put('/:id', studentController.updateStudent);

/**
 * @swagger
 * /students/{id}:
 *   delete:
 *     summary: Deactivate student (soft delete)
 *     tags: [Students]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Student ID
 *     responses:
 *       200:
 *         description: Student deactivated successfully
 *       404:
 *         description: Student not found
 */
router.delete('/:id', studentController.deleteStudent);

module.exports = router; 