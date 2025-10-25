const databaseService = require('../services/databaseService');
const { catchAsync, AppError } = require('../middleware/errorHandler');
const { validateUser, validateUserUpdate } = require('../validators/userValidator');
const { v4: uuidv4 } = require('uuid');
const moment = require('moment');

class UserController {
  // Get all users with pagination and filtering
  getAllUsers = catchAsync(async (req, res) => {
    const {
      page = 1,
      limit = 20,
      userType,
      search,
      isActive,
      sortBy = 'createdAt',
      sortOrder = 'DESC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: {}
    };

    // Add filters
    if (userType) {
      options.where.userType = userType;
    }

    if (isActive !== undefined) {
      options.where.isActive = isActive === 'true';
    }

    // Search functionality
    if (search) {
      if (databaseService.getDatabaseType() === 'postgresql') {
        options.where[Op.or] = [
          { firstName: { [Op.iLike]: `%${search}%` } },
          { lastName: { [Op.iLike]: `%${search}%` } },
          { email: { [Op.iLike]: `%${search}%` } },
          { username: { [Op.iLike]: `%${search}%` } }
        ];
      }
      // For DynamoDB, we'll filter after retrieval
    }

    const result = await databaseService.paginate('Users', options);

    // Apply search filter for DynamoDB
    if (search && databaseService.getDatabaseType() === 'dynamodb') {
      result.data = result.data.filter(user => 
        (user.firstName && user.firstName.toLowerCase().includes(search.toLowerCase())) ||
        (user.lastName && user.lastName.toLowerCase().includes(search.toLowerCase())) ||
        (user.email && user.email.toLowerCase().includes(search.toLowerCase())) ||
        (user.username && user.username.toLowerCase().includes(search.toLowerCase()))
      );
    }

    res.paginated(result.data, result.pagination, 'Users retrieved successfully');
  });

  // Get user by ID
  getUserById = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    const user = await databaseService.findById('Users', id);
    
    if (!user) {
      throw new AppError('User not found', 404);
    }

    res.success(user, 'User retrieved successfully');
  });

  // Create new user
  createUser = catchAsync(async (req, res) => {
    // Validate input
    const { error, value } = validateUser(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if username already exists
    const existingUser = await databaseService.findOne('Users', { username: value.username });
    if (existingUser) {
      throw new AppError('Username already exists', 409);
    }

    // Check if email already exists
    const existingEmail = await databaseService.findOne('Users', { email: value.email });
    if (existingEmail) {
      throw new AppError('Email already exists', 409);
    }

    // Prepare user data
    const userData = {
      ...value,
      isActive: value.isActive !== undefined ? value.isActive : true,
      lastLogin: null
    };

    // Create user
    const user = await databaseService.create('Users', userData);

    res.created(user, 'User created successfully');
  });

  // Update user
  updateUser = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    // Validate input
    const { error, value } = validateUserUpdate(req.body);
    if (error) {
      throw new AppError(error.details[0].message, 400);
    }

    // Check if user exists
    const existingUser = await databaseService.findById('Users', id);
    if (!existingUser) {
      throw new AppError('User not found', 404);
    }

    // Check if email is being changed and if it's unique
    if (value.email && value.email !== existingUser.email) {
      const emailExists = await databaseService.findOne('Users', { email: value.email });
      if (emailExists) {
        throw new AppError('Email already exists', 409);
      }
    }

    // Update user
    const updatedUser = await databaseService.update('Users', id, value);

    res.updated(updatedUser, 'User updated successfully');
  });

  // Delete user (soft delete - set isActive to false)
  deleteUser = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if user exists
    const existingUser = await databaseService.findById('Users', id);
    if (!existingUser) {
      throw new AppError('User not found', 404);
    }

    // Soft delete by setting isActive to false
    await databaseService.update('Users', id, { isActive: false });

    res.deleted('User deactivated successfully');
  });

  // Permanently delete user
  permanentlyDeleteUser = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if user exists
    const existingUser = await databaseService.findById('Users', id);
    if (!existingUser) {
      throw new AppError('User not found', 404);
    }

    // Permanently delete user
    await databaseService.delete('Users', id);

    res.deleted('User permanently deleted');
  });

  // Activate user
  activateUser = catchAsync(async (req, res) => {
    const { id } = req.params;

    // Check if user exists
    const existingUser = await databaseService.findById('Users', id);
    if (!existingUser) {
      throw new AppError('User not found', 404);
    }

    // Activate user
    const updatedUser = await databaseService.update('Users', id, { isActive: true });

    res.updated(updatedUser, 'User activated successfully');
  });

  // Get users by type
  getUsersByType = catchAsync(async (req, res) => {
    const { userType } = req.params;
    const { page = 1, limit = 20, isActive = true } = req.query;

    // Validate user type
    const validUserTypes = ['teacher', 'student', 'parent', 'admin'];
    if (!validUserTypes.includes(userType)) {
      throw new AppError('Invalid user type', 400);
    }

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: {
        userType,
        isActive: isActive === 'true'
      }
    };

    const result = await databaseService.paginate('Users', options);

    res.paginated(result.data, result.pagination, `${userType}s retrieved successfully`);
  });

  // Search users
  searchUsers = catchAsync(async (req, res) => {
    const { query, userType, page = 1, limit = 20 } = req.query;

    if (!query) {
      throw new AppError('Search query is required', 400);
    }

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      where: { isActive: true }
    };

    if (userType) {
      options.where.userType = userType;
    }

    let users;
    if (databaseService.getDatabaseType() === 'postgresql') {
      // PostgreSQL search with ILIKE
      const { Op } = require('sequelize');
      options.where[Op.or] = [
        { firstName: { [Op.iLike]: `%${query}%` } },
        { lastName: { [Op.iLike]: `%${query}%` } },
        { email: { [Op.iLike]: `%${query}%` } },
        { username: { [Op.iLike]: `%${query}%` } }
      ];
      const result = await databaseService.paginate('Users', options);
      users = result;
    } else {
      // DynamoDB search
      const allUsers = await databaseService.findByCondition('Users', options.where);
      const filteredUsers = allUsers.filter(user => 
        (user.firstName && user.firstName.toLowerCase().includes(query.toLowerCase())) ||
        (user.lastName && user.lastName.toLowerCase().includes(query.toLowerCase())) ||
        (user.email && user.email.toLowerCase().includes(query.toLowerCase())) ||
        (user.username && user.username.toLowerCase().includes(query.toLowerCase()))
      );
      
      // Manual pagination for DynamoDB
      const startIndex = (parseInt(page) - 1) * parseInt(limit);
      const endIndex = startIndex + parseInt(limit);
      const paginatedUsers = filteredUsers.slice(startIndex, endIndex);
      
      users = {
        data: paginatedUsers,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: filteredUsers.length,
          pages: Math.ceil(filteredUsers.length / parseInt(limit)),
          hasNext: endIndex < filteredUsers.length,
          hasPrev: parseInt(page) > 1
        }
      };
    }

    res.paginated(users.data, users.pagination, 'Search results retrieved successfully');
  });

  // Get user profile (simplified version without sensitive data)
  getUserProfile = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    const user = await databaseService.findById('Users', id);
    
    if (!user) {
      throw new AppError('User not found', 404);
    }

    // Remove sensitive information
    const profile = {
      username: user.username,
      email: user.email,
      userType: user.userType,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      address: user.address,
      isActive: user.isActive,
      lastLogin: user.lastLogin,
      createdAt: user.createdAt
    };

    res.success(profile, 'User profile retrieved successfully');
  });

  // Update user profile
  updateUserProfile = catchAsync(async (req, res) => {
    const { id } = req.params;
    
    // Only allow certain fields to be updated in profile
    const allowedFields = ['firstName', 'lastName', 'phone', 'address', 'avatarUrl'];
    const updateData = {};
    
    Object.keys(req.body).forEach(key => {
      if (allowedFields.includes(key)) {
        updateData[key] = req.body[key];
      }
    });

    if (Object.keys(updateData).length === 0) {
      throw new AppError('No valid fields to update', 400);
    }

    // Check if user exists
    const existingUser = await databaseService.findById('Users', id);
    if (!existingUser) {
      throw new AppError('User not found', 404);
    }

    // Update user profile
    const updatedUser = await databaseService.update('Users', id, updateData);

    res.updated(updatedUser, 'Profile updated successfully');
  });

  // Get user statistics
  getUserStats = catchAsync(async (req, res) => {
    const stats = {};

    // Get counts by user type
    const userTypes = ['teacher', 'student', 'parent', 'admin'];
    
    for (const type of userTypes) {
      const users = await databaseService.findByCondition('Users', { userType: type, isActive: true });
      stats[type] = users.length;
    }

    // Get total active and inactive users
    const activeUsers = await databaseService.findByCondition('Users', { isActive: true });
    const inactiveUsers = await databaseService.findByCondition('Users', { isActive: false });
    
    stats.total = activeUsers.length + inactiveUsers.length;
    stats.active = activeUsers.length;
    stats.inactive = inactiveUsers.length;

    // Get recent registrations (last 30 days)
    const thirtyDaysAgo = moment().subtract(30, 'days').toISOString();
    const recentUsers = activeUsers.filter(user => 
      moment(user.createdAt).isAfter(thirtyDaysAgo)
    );
    stats.recentRegistrations = recentUsers.length;

    res.success(stats, 'User statistics retrieved successfully');
  });
}

module.exports = new UserController(); 