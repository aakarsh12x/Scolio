const databaseService = require('../services/databaseService');

async function testDatabaseService() {
  try {
    console.log('Testing database service...');
    
    // Initialize the database service
    console.log('Initializing database service...');
    await databaseService.init();
    
    console.log(Database type: );
    
    // Create a user
    console.log('\\nCreating a user...');
    const user = await databaseService.create('Users', {
      username: 'testuser',
      email: 'testuser@scolio.com',
      userType: 'admin',
      firstName: 'Test',
      lastName: 'User',
      isActive: true
    });
    console.log('User created:', user);
    
    // Find the user by ID
    console.log('\\nFinding user by ID...');
    const foundUser = await databaseService.findById('Users', user.id);
    console.log('Found user:', foundUser);
    
    // Update the user
    console.log('\\nUpdating user...');
    const updatedUser = await databaseService.update('Users', user.id, {
      firstName: 'Updated',
      phone: '1234567890'
    });
    console.log('Updated user:', updatedUser);
    
    // Find all users
    console.log('\\nFinding all users...');
    const allUsers = await databaseService.findAll('Users');
    console.log(Found  users);
    
    // Delete the user
    console.log('\\nDeleting user...');
    const deleted = await databaseService.delete('Users', user.id);
    console.log('User deleted:', deleted);
    
    console.log('\\nDatabase service test completed successfully!');
  } catch (error) {
    console.error('Error testing database service:', error);
  } finally {
    // Disconnect from the database
    await databaseService.disconnect();
  }
}

// Run the test
testDatabaseService();
