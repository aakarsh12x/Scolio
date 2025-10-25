const databaseService = require('../services/databaseService');
const { v4: uuidv4 } = require('uuid');

// Test data
const testData = {
  users: [
    {
      username: 'admin',
      email: 'admin@scolio.com',
      userType: 'admin',
      firstName: 'Admin',
      lastName: 'User',
      isActive: true
    },
    {
      username: 'teacher1',
      email: 'teacher1@scolio.com',
      userType: 'teacher',
      firstName: 'John',
      lastName: 'Smith',
      isActive: true
    },
    {
      username: 'student1',
      email: 'student1@scolio.com',
      userType: 'student',
      firstName: 'Jane',
      lastName: 'Doe',
      isActive: true
    }
  ],
  teachers: [
    {
      username: 'teacher1',
      employeeId: 'EMP001',
      subjects: ['Mathematics', 'Physics'],
      qualification: 'M.Sc. Mathematics',
      isActive: true
    }
  ],
  classes: [
    {
      name: 'Class 10',
      section: 'A',
      academicYear: '2023-2024',
      grade: 10,
      roomNumber: '101',
      capacity: 30,
      description: 'Senior class for science stream',
      isActive: true
    }
  ]
};

// Test functions
const testUserCRUD = async () => {
  console.log('\n=== Testing User CRUD Operations ===');
  
  try {
    // Create users
    console.log('Creating users...');
    const createdUsers = [];
    
    for (const userData of testData.users) {
      const user = await databaseService.create('Users', userData);
      console.log(`Created user: ${user.username} (${user.id})`);
      createdUsers.push(user);
    }
    
    // Find user by ID
    console.log('\nFinding user by ID...');
    const foundUser = await databaseService.findById('Users', createdUsers[0].id);
    console.log(`Found user: ${foundUser.username} (${foundUser.id})`);
    
    // Find user by condition
    console.log('\nFinding user by condition...');
    const foundByEmail = await databaseService.findOne('Users', { email: 'teacher1@scolio.com' });
    console.log(`Found user by email: ${foundByEmail.username} (${foundByEmail.id})`);
    
    // Update user
    console.log('\nUpdating user...');
    const updatedUser = await databaseService.update('Users', createdUsers[0].id, {
      firstName: 'Updated Admin',
      phone: '1234567890'
    });
    console.log(`Updated user: ${updatedUser.firstName} (${updatedUser.id})`);
    
    // Get all users with pagination
    console.log('\nGetting all users with pagination...');
    const paginatedUsers = await databaseService.paginate('Users', {
      page: 1,
      limit: 10,
      where: { isActive: true }
    });
    console.log(`Found ${paginatedUsers.data.length} users`);
    console.log('Pagination info:', paginatedUsers.pagination);
    
    return createdUsers;
  } catch (error) {
    console.error('Error in user CRUD test:', error);
    throw error;
  }
};

const testTeacherCRUD = async (users) => {
  console.log('\n=== Testing Teacher CRUD Operations ===');
  
  try {
    // Create teachers
    console.log('Creating teachers...');
    const createdTeachers = [];
    
    for (const teacherData of testData.teachers) {
      const teacher = await databaseService.create('Teachers', teacherData);
      console.log(`Created teacher: ${teacher.username} (${teacher.id})`);
      createdTeachers.push(teacher);
    }
    
    // Find teacher by ID
    console.log('\nFinding teacher by ID...');
    const foundTeacher = await databaseService.findById('Teachers', createdTeachers[0].id);
    console.log(`Found teacher: ${foundTeacher.username} (${foundTeacher.id})`);
    
    // Update teacher
    console.log('\nUpdating teacher...');
    const updatedTeacher = await databaseService.update('Teachers', createdTeachers[0].id, {
      subjects: ['Mathematics', 'Physics', 'Chemistry'],
      designation: 'Senior Teacher'
    });
    console.log(`Updated teacher: ${updatedTeacher.username} (${updatedTeacher.id})`);
    console.log(`Subjects: ${updatedTeacher.subjects.join(', ')}`);
    
    return createdTeachers;
  } catch (error) {
    console.error('Error in teacher CRUD test:', error);
    throw error;
  }
};

const testClassCRUD = async (teachers) => {
  console.log('\n=== Testing Class CRUD Operations ===');
  
  try {
    // Create classes
    console.log('Creating classes...');
    const createdClasses = [];
    
    for (const classData of testData.classes) {
      const classWithTeacher = {
        ...classData,
        teacherId: teachers[0].id
      };
      
      const classEntity = await databaseService.create('Classes', classWithTeacher);
      console.log(`Created class: ${classEntity.name} (${classEntity.id})`);
      createdClasses.push(classEntity);
    }
    
    // Find class by ID
    console.log('\nFinding class by ID...');
    const foundClass = await databaseService.findById('Classes', createdClasses[0].id);
    console.log(`Found class: ${foundClass.name} (${foundClass.id})`);
    
    // Update class
    console.log('\nUpdating class...');
    const updatedClass = await databaseService.update('Classes', createdClasses[0].id, {
      capacity: 35,
      description: 'Updated description for senior science class'
    });
    console.log(`Updated class: ${updatedClass.name} (${updatedClass.id})`);
    console.log(`New capacity: ${updatedClass.capacity}`);
    
    return createdClasses;
  } catch (error) {
    console.error('Error in class CRUD test:', error);
    throw error;
  }
};

const testAttendance = async (classes) => {
  console.log('\n=== Testing Attendance Operations ===');
  
  try {
    // Create student
    console.log('Creating a student...');
    const student = await databaseService.create('Students', {
      username: 'student1',
      rollNumber: 'R001',
      classId: classes[0].id,
      admissionYear: '2023',
      isActive: true
    });
    console.log(`Created student: ${student.username} (${student.id})`);
    
    // Create attendance record
    console.log('\nCreating attendance record...');
    const today = new Date().toISOString().split('T')[0];
    
    const attendance = await databaseService.create('Attendance', {
      classId: classes[0].id,
      date: today,
      presentStudents: [student.id],
      absentStudents: [],
      totalStudents: 1,
      subject: 'Mathematics'
    });
    
    console.log(`Created attendance record for ${attendance.date} (${attendance.id})`);
    
    // Find attendance by ID
    console.log('\nFinding attendance by ID...');
    const foundAttendance = await databaseService.findById('Attendance', attendance.id);
    console.log(`Found attendance record for ${foundAttendance.date}`);
    console.log(`Present students: ${foundAttendance.presentStudents.length}`);
    
    // Find attendance by class
    console.log('\nFinding attendance by class...');
    const classAttendance = await databaseService.findByCondition('Attendance', { classId: classes[0].id });
    console.log(`Found ${classAttendance.length} attendance records for class ${classes[0].name}`);
    
    return attendance;
  } catch (error) {
    console.error('Error in attendance test:', error);
    throw error;
  }
};

// Run all tests
const runTests = async () => {
  try {
    console.log('Initializing database service...');
    await databaseService.init();
    
    console.log('\nStarting backend tests with DynamoDB Local...');
    
    // Run tests in sequence
    const users = await testUserCRUD();
    const teachers = await testTeacherCRUD(users);
    const classes = await testClassCRUD(teachers);
    const attendance = await testAttendance(classes);
    
    console.log('\n=== All tests completed successfully! ===');
  } catch (error) {
    console.error('Test failed:', error);
  } finally {
    await databaseService.disconnect();
  }
};

// Run the tests
runTests(); 