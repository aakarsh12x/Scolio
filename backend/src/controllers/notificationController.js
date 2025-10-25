const databaseService = require('../services/databaseService');
const { v4: uuidv4 } = require('uuid');

/**
 * Notification Controller
 * Handles all notification-related operations
 */

/**
 * Create a new notification
 */
const createNotification = async (req, res) => {
  try {
    const {
      title,
      message,
      type,
      senderId,
      targetUserTypes = [],
      targetClasses = [],
      targetUsers = [],
      priority = 'medium',
      scheduledFor,
      expiresAt,
      attachments = []
    } = req.body;

    // Validate required fields
    if (!title || !message || !type || !senderId) {
      return res.error('Missing required fields', 400);
    }

    // Validate notification type
    const validTypes = ['announcement', 'reminder', 'alert', 'event'];
    if (!validTypes.includes(type)) {
      return res.error('Invalid notification type', 400);
    }

    // Validate priority
    const validPriorities = ['low', 'medium', 'high', 'urgent'];
    if (!validPriorities.includes(priority)) {
      return res.error('Invalid priority level', 400);
    }

    // Create notification data
    const notificationData = {
      id: uuidv4(),
      title,
      message,
      type,
      senderId,
      targetUserTypes,
      targetClasses,
      targetUsers,
      priority,
      scheduledFor: scheduledFor || new Date().toISOString(),
      expiresAt,
      attachments,
      reads: [], // Array of {userId, readAt}
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    // Save to database
    const notification = await databaseService.create('Notifications', notificationData);

    res.success(notification, 'Notification created successfully', 201);
  } catch (error) {
    console.error('Error creating notification:', error);
    res.error('Failed to create notification', 500);
  }
};

/**
 * Get all notifications
 */
const getAllNotifications = async (req, res) => {
  try {
    const { type, priority, senderId, page = 1, limit = 10 } = req.query;

    let notifications = await databaseService.findAll('Notifications');

    // Apply filters
    if (type) {
      notifications = notifications.filter(notification => notification.type === type);
    }
    if (priority) {
      notifications = notifications.filter(notification => notification.priority === priority);
    }
    if (senderId) {
      notifications = notifications.filter(notification => notification.senderId === senderId);
    }

    // Filter out expired notifications
    const now = new Date().toISOString();
    notifications = notifications.filter(notification => 
      !notification.expiresAt || notification.expiresAt > now
    );

    // Sort by scheduled time (newest first)
    notifications.sort((a, b) => new Date(b.scheduledFor) - new Date(a.scheduledFor));

    // Pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedNotifications = notifications.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: notifications.length,
      pages: Math.ceil(notifications.length / limit),
      hasNext: endIndex < notifications.length,
      hasPrev: startIndex > 0
    };

    res.success(paginatedNotifications, 'Notifications retrieved successfully', 200, pagination);
  } catch (error) {
    console.error('Error fetching notifications:', error);
    res.error('Failed to fetch notifications', 500);
  }
};

/**
 * Get notification by ID
 */
const getNotificationById = async (req, res) => {
  try {
    const { id } = req.params;

    const notification = await databaseService.findById('Notifications', id);

    if (!notification) {
      return res.error('Notification not found', 404);
    }

    res.success(notification, 'Notification retrieved successfully');
  } catch (error) {
    console.error('Error fetching notification:', error);
    res.error('Failed to fetch notification', 500);
  }
};

/**
 * Update notification
 */
const updateNotification = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    // Check if notification exists
    const existingNotification = await databaseService.findById('Notifications', id);
    if (!existingNotification) {
      return res.error('Notification not found', 404);
    }

    // Validate notification type if provided
    if (updateData.type) {
      const validTypes = ['announcement', 'reminder', 'alert', 'event'];
      if (!validTypes.includes(updateData.type)) {
        return res.error('Invalid notification type', 400);
      }
    }

    // Validate priority if provided
    if (updateData.priority) {
      const validPriorities = ['low', 'medium', 'high', 'urgent'];
      if (!validPriorities.includes(updateData.priority)) {
        return res.error('Invalid priority level', 400);
      }
    }

    // Update notification
    updateData.updatedAt = new Date().toISOString();
    const updatedNotification = await databaseService.update('Notifications', id, updateData);

    res.success(updatedNotification, 'Notification updated successfully');
  } catch (error) {
    console.error('Error updating notification:', error);
    res.error('Failed to update notification', 500);
  }
};

/**
 * Delete notification
 */
const deleteNotification = async (req, res) => {
  try {
    const { id } = req.params;

    // Check if notification exists
    const existingNotification = await databaseService.findById('Notifications', id);
    if (!existingNotification) {
      return res.error('Notification not found', 404);
    }

    // Delete notification
    await databaseService.delete('Notifications', id);

    res.success(null, 'Notification deleted successfully');
  } catch (error) {
    console.error('Error deleting notification:', error);
    res.error('Failed to delete notification', 500);
  }
};

/**
 * Mark notification as read
 */
const markAsRead = async (req, res) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;

    if (!userId) {
      return res.error('User ID is required', 400);
    }

    // Get notification
    const notification = await databaseService.findById('Notifications', id);
    if (!notification) {
      return res.error('Notification not found', 404);
    }

    // Check if already read by this user
    const existingRead = notification.reads.find(read => read.userId === userId);
    if (existingRead) {
      return res.success(notification, 'Notification already marked as read');
    }

    // Add read record
    notification.reads.push({
      userId,
      readAt: new Date().toISOString()
    });

    notification.updatedAt = new Date().toISOString();

    // Update notification
    const updatedNotification = await databaseService.update('Notifications', id, notification);

    res.success(updatedNotification, 'Notification marked as read');
  } catch (error) {
    console.error('Error marking notification as read:', error);
    res.error('Failed to mark notification as read', 500);
  }
};

/**
 * Get notifications for a specific user
 */
const getUserNotifications = async (req, res) => {
  try {
    const { userId } = req.params;
    const { type, priority, unreadOnly, page = 1, limit = 10 } = req.query;

    // Get user details to determine user type and classes
    const user = await databaseService.findById('Users', userId);
    if (!user) {
      return res.error('User not found', 404);
    }

    let notifications = await databaseService.findAll('Notifications');

    // Filter notifications for this user
    notifications = notifications.filter(notification => {
      // Check if notification is targeted to this user specifically
      if (notification.targetUsers.includes(userId)) {
        return true;
      }

      // Check if notification is targeted to user's type
      if (notification.targetUserTypes.includes(user.userType)) {
        return true;
      }

      // Check if notification is targeted to user's classes (for students/teachers)
      if (notification.targetClasses.length > 0) {
        // This would need to be enhanced with proper class-user relationships
        return false; // Placeholder
      }

      return false;
    });

    // Filter out expired notifications
    const now = new Date().toISOString();
    notifications = notifications.filter(notification => 
      !notification.expiresAt || notification.expiresAt > now
    );

    // Apply additional filters
    if (type) {
      notifications = notifications.filter(notification => notification.type === type);
    }
    if (priority) {
      notifications = notifications.filter(notification => notification.priority === priority);
    }
    if (unreadOnly === 'true') {
      notifications = notifications.filter(notification => 
        !notification.reads.some(read => read.userId === userId)
      );
    }

    // Add read status to each notification
    notifications = notifications.map(notification => ({
      ...notification,
      isRead: notification.reads.some(read => read.userId === userId),
      readAt: notification.reads.find(read => read.userId === userId)?.readAt || null
    }));

    // Sort by priority and date
    const priorityOrder = { urgent: 4, high: 3, medium: 2, low: 1 };
    notifications.sort((a, b) => {
      if (a.priority !== b.priority) {
        return priorityOrder[b.priority] - priorityOrder[a.priority];
      }
      return new Date(b.scheduledFor) - new Date(a.scheduledFor);
    });

    // Pagination
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedNotifications = notifications.slice(startIndex, endIndex);

    const pagination = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: notifications.length,
      pages: Math.ceil(notifications.length / limit),
      hasNext: endIndex < notifications.length,
      hasPrev: startIndex > 0
    };

    // Calculate unread count
    const unreadCount = notifications.filter(n => !n.isRead).length;

    res.success({
      notifications: paginatedNotifications,
      unreadCount
    }, 'User notifications retrieved successfully', 200, pagination);
  } catch (error) {
    console.error('Error fetching user notifications:', error);
    res.error('Failed to fetch user notifications', 500);
  }
};

/**
 * Get notification statistics
 */
const getNotificationStats = async (req, res) => {
  try {
    const { senderId } = req.query;

    let notifications = await databaseService.findAll('Notifications');

    if (senderId) {
      notifications = notifications.filter(notification => notification.senderId === senderId);
    }

    const now = new Date().toISOString();
    const activeNotifications = notifications.filter(notification => 
      !notification.expiresAt || notification.expiresAt > now
    );

    const stats = {
      total: notifications.length,
      active: activeNotifications.length,
      expired: notifications.length - activeNotifications.length,
      byType: {
        announcement: notifications.filter(n => n.type === 'announcement').length,
        reminder: notifications.filter(n => n.type === 'reminder').length,
        alert: notifications.filter(n => n.type === 'alert').length,
        event: notifications.filter(n => n.type === 'event').length
      },
      byPriority: {
        urgent: notifications.filter(n => n.priority === 'urgent').length,
        high: notifications.filter(n => n.priority === 'high').length,
        medium: notifications.filter(n => n.priority === 'medium').length,
        low: notifications.filter(n => n.priority === 'low').length
      },
      totalReads: notifications.reduce((sum, n) => sum + n.reads.length, 0)
    };

    res.success(stats, 'Notification statistics retrieved successfully');
  } catch (error) {
    console.error('Error fetching notification statistics:', error);
    res.error('Failed to fetch notification statistics', 500);
  }
};

module.exports = {
  createNotification,
  getAllNotifications,
  getNotificationById,
  updateNotification,
  deleteNotification,
  markAsRead,
  getUserNotifications,
  getNotificationStats
}; 