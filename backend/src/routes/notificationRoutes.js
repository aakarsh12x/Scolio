const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');

/**
 * @swagger
 * components:
 *   schemas:
 *     Notification:
 *       type: object
 *       required:
 *         - title
 *         - message
 *         - type
 *         - senderId
 *       properties:
 *         id:
 *           type: string
 *           description: Notification ID
 *         title:
 *           type: string
 *           description: Notification title
 *         message:
 *           type: string
 *           description: Notification message
 *         type:
 *           type: string
 *           enum: [announcement, reminder, alert, event]
 *           description: Type of notification
 *         senderId:
 *           type: string
 *           description: Sender ID
 *         targetUserTypes:
 *           type: array
 *           items:
 *             type: string
 *           description: Target user types
 *         targetClasses:
 *           type: array
 *           items:
 *             type: string
 *           description: Target classes
 *         targetUsers:
 *           type: array
 *           items:
 *             type: string
 *           description: Target specific users
 *         priority:
 *           type: string
 *           enum: [low, medium, high, urgent]
 *           description: Priority level
 *         scheduledFor:
 *           type: string
 *           format: date-time
 *           description: Scheduled time
 *         expiresAt:
 *           type: string
 *           format: date-time
 *           description: Expiration time
 */

// Create notification
router.post('/', notificationController.createNotification);

// Get all notifications
router.get('/', notificationController.getAllNotifications);

// Get notification by ID
router.get('/:id', notificationController.getNotificationById);

// Update notification
router.put('/:id', notificationController.updateNotification);

// Delete notification
router.delete('/:id', notificationController.deleteNotification);

// Mark notification as read
router.post('/:id/read', notificationController.markAsRead);

// Get notifications for a user
router.get('/user/:userId', notificationController.getUserNotifications);

// Get notification statistics
router.get('/stats', notificationController.getNotificationStats);

module.exports = router; 