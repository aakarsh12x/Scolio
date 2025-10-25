const express = require('express');
const teacherController = require('../controllers/teacherController');
const router = express.Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     Teacher:
 *       type: object
 *       required:
 *         - username
 *         - employeeId
 *         - subjects
 *         - qualification
 *         - experience
 *         - joinDate
 *       properties:
 *         username:
 *           type: string
 *           description: Username of the user account (must exist)
 *         employeeId:
 *           type: string
 *           description: Unique employee ID for the teacher
 *         subjects:
 *           type: array
 *           items:
 *             type: string
 *           description: List of subjects the teacher can teach
 *         qualification:
 *           type: string
 *           description: Teacher's educational qualification
 *         experience:
 *           type: integer
 *           description: Years of teaching experience
 *         joinDate:
 *           type: string
 *           format: date
 *           description: Date when teacher joined the school
 *         department:
 *           type: string
 *           description: Department the teacher belongs to
 *         designation:
 *           type: string
 *           description: Teacher's job title or position
 *         specializations:
 *           type: array
 *           items:
 *             type: string
 *           description: List of teacher's specializations
 *         certifications:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               issuer:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date
 *               expiryDate:
 *                 type: string
 *                 format: date
 *               certificateUrl:
 *                 type: string
 *                 format: uri
 *         schedule:
 *           type: object
 *           properties:
 *             monday:
 *               type: array
 *               items:
 *                 type: string
 *             tuesday:
 *               type: array
 *               items:
 *                 type: string
 *             wednesday:
 *               type: array
 *               items:
 *                 type: string
 *             thursday:
 *               type: array
 *               items:
 *                 type: string
 *             friday:
 *               type: array
 *               items:
 *                 type: string
 *             saturday:
 *               type: array
 *               items:
 *                 type: string
 *             sunday:
 *               type: array
 *               items:
 *                 type: string
 *         isActive:
 *           type: boolean
 *           description: Whether the teacher account is active
 *
 *     TeacherWithUserInfo:
 *       allOf:
 *         - $ref: '#/components/schemas/Teacher'
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
 *
 *     TeacherList:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *         message:
 *           type: string
 *         data:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/TeacherWithUserInfo'
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
 * /teachers:
 *   get:
 *     summary: Get all teachers with pagination and filtering
 *     tags: [Teachers]
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
 *         description: Number of teachers per page
 *       - in: query
 *         name: subject
 *         schema:
 *           type: string
 *         description: Filter by subject
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
 *         description: Teachers retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/TeacherList'
 */
router.get('/', teacherController.getAllTeachers);

/**
 * @swagger
 * /teachers/search:
 *   get:
 *     summary: Search teachers
 *     tags: [Teachers]
 *     parameters:
 *       - in: query
 *         name: query
 *         required: true
 *         schema:
 *           type: string
 *           minLength: 2
 *         description: Search query
 *       - in: query
 *         name: subject
 *         schema:
 *           type: string
 *         description: Filter by subject
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
 *               $ref: '#/components/schemas/TeacherList'
 *       400:
 *         description: Search query is required
 */
router.get('/search', teacherController.searchTeachers);

/**
 * @swagger
 * /teachers/subject/{subject}:
 *   get:
 *     summary: Get teachers by subject
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: subject
 *         required: true
 *         schema:
 *           type: string
 *         description: Subject to filter by
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
 *         description: Teachers retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/TeacherList'
 */
router.get('/subject/:subject', teacherController.getTeachersBySubject);

/**
 * @swagger
 * /teachers/{id}:
 *   get:
 *     summary: Get teacher by ID
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     responses:
 *       200:
 *         description: Teacher retrieved successfully
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
 *                   $ref: '#/components/schemas/TeacherWithUserInfo'
 *       404:
 *         description: Teacher not found
 */
router.get('/:id', teacherController.getTeacherById);

/**
 * @swagger
 * /teachers/{id}/classes:
 *   get:
 *     summary: Get teacher's classes
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
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
 *         description: Teacher classes retrieved successfully
 *       404:
 *         description: Teacher not found
 */
router.get('/:id/classes', teacherController.getTeacherClasses);

/**
 * @swagger
 * /teachers/{id}/stats:
 *   get:
 *     summary: Get teacher statistics
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     responses:
 *       200:
 *         description: Teacher statistics retrieved successfully
 *       404:
 *         description: Teacher not found
 */
router.get('/:id/stats', teacherController.getTeacherStats);

/**
 * @swagger
 * /teachers/{id}/dashboard:
 *   get:
 *     summary: Get teacher dashboard data
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     responses:
 *       200:
 *         description: Teacher dashboard data retrieved successfully
 *       404:
 *         description: Teacher not found
 */
router.get('/:id/dashboard', teacherController.getTeacherDashboard);

/**
 * @swagger
 * /teachers:
 *   post:
 *     summary: Create a new teacher
 *     tags: [Teachers]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Teacher'
 *     responses:
 *       201:
 *         description: Teacher created successfully
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
 *                   $ref: '#/components/schemas/TeacherWithUserInfo'
 *       400:
 *         description: Validation error
 *       404:
 *         description: User not found
 *       409:
 *         description: Teacher profile already exists
 */
router.post('/', teacherController.createTeacher);

/**
 * @swagger
 * /teachers/{id}:
 *   put:
 *     summary: Update teacher
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Teacher'
 *     responses:
 *       200:
 *         description: Teacher updated successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Teacher not found
 */
router.put('/:id', teacherController.updateTeacher);

/**
 * @swagger
 * /teachers/{id}/subjects:
 *   patch:
 *     summary: Update teacher subjects
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               subjects:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       200:
 *         description: Teacher subjects updated successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Teacher not found
 */
router.patch('/:id/subjects', teacherController.updateSubjects);

/**
 * @swagger
 * /teachers/{id}/assign:
 *   post:
 *     summary: Assign teacher to class
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               classId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Teacher assigned to class successfully
 *       400:
 *         description: Validation error
 *       404:
 *         description: Teacher or class not found
 */
router.post('/:id/assign', teacherController.assignToClass);

/**
 * @swagger
 * /teachers/{id}/remove:
 *   post:
 *     summary: Remove teacher from class
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               classId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Teacher removed from class successfully
 *       400:
 *         description: Validation error or teacher not assigned to class
 *       404:
 *         description: Teacher or class not found
 */
router.post('/:id/remove', teacherController.removeFromClass);

/**
 * @swagger
 * /teachers/{id}:
 *   delete:
 *     summary: Deactivate teacher (soft delete)
 *     tags: [Teachers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Teacher ID
 *     responses:
 *       200:
 *         description: Teacher deactivated successfully
 *       404:
 *         description: Teacher not found
 */
router.delete('/:id', teacherController.deleteTeacher);

module.exports = router; 