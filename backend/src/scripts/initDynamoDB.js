const AWS = require('aws-sdk');
const config = require('../config/config');

// Configure DynamoDB
const dynamoConfig = {
  region: 'local',
  endpoint: config.database.dynamodb.endpoint || 'http://localhost:8000',
  accessKeyId: 'local',
  secretAccessKey: 'local'
};

const dynamoDB = new AWS.DynamoDB(dynamoConfig);
const documentClient = new AWS.DynamoDB.DocumentClient(dynamoConfig);

// Table definitions
const tables = [
  {
    TableName: 'Users',
    KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
    AttributeDefinitions: [
      { AttributeName: 'id', AttributeType: 'S' },
      { AttributeName: 'username', AttributeType: 'S' },
      { AttributeName: 'email', AttributeType: 'S' },
      { AttributeName: 'userType', AttributeType: 'S' }
    ],
    GlobalSecondaryIndexes: [
      {
        IndexName: 'UsernameIndex',
        KeySchema: [{ AttributeName: 'username', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      },
      {
        IndexName: 'EmailIndex',
        KeySchema: [{ AttributeName: 'email', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      },
      {
        IndexName: 'UserTypeIndex',
        KeySchema: [{ AttributeName: 'userType', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      }
    ],
    ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
  },
  {
    TableName: 'Teachers',
    KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
    AttributeDefinitions: [
      { AttributeName: 'id', AttributeType: 'S' },
      { AttributeName: 'username', AttributeType: 'S' }
    ],
    GlobalSecondaryIndexes: [
      {
        IndexName: 'UsernameIndex',
        KeySchema: [{ AttributeName: 'username', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      }
    ],
    ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
  },
  {
    TableName: 'Students',
    KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
    AttributeDefinitions: [
      { AttributeName: 'id', AttributeType: 'S' },
      { AttributeName: 'username', AttributeType: 'S' },
      { AttributeName: 'classId', AttributeType: 'S' }
    ],
    GlobalSecondaryIndexes: [
      {
        IndexName: 'UsernameIndex',
        KeySchema: [{ AttributeName: 'username', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      },
      {
        IndexName: 'ClassIndex',
        KeySchema: [{ AttributeName: 'classId', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      }
    ],
    ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
  },
  {
    TableName: 'Classes',
    KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
    AttributeDefinitions: [
      { AttributeName: 'id', AttributeType: 'S' },
      { AttributeName: 'academicYear', AttributeType: 'S' },
      { AttributeName: 'teacherId', AttributeType: 'S' }
    ],
    GlobalSecondaryIndexes: [
      {
        IndexName: 'AcademicYearIndex',
        KeySchema: [{ AttributeName: 'academicYear', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      },
      {
        IndexName: 'TeacherIndex',
        KeySchema: [{ AttributeName: 'teacherId', KeyType: 'HASH' }],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      }
    ],
    ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
  },
  {
    TableName: 'Attendance',
    KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
    AttributeDefinitions: [
      { AttributeName: 'id', AttributeType: 'S' },
      { AttributeName: 'classId', AttributeType: 'S' },
      { AttributeName: 'date', AttributeType: 'S' }
    ],
    GlobalSecondaryIndexes: [
      {
        IndexName: 'ClassDateIndex',
        KeySchema: [
          { AttributeName: 'classId', KeyType: 'HASH' },
          { AttributeName: 'date', KeyType: 'RANGE' }
        ],
        Projection: { ProjectionType: 'ALL' },
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      }
    ],
    ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
  }
];

// Sample data for testing
const sampleData = {
  Users: [
    {
      id: 'user1',
      username: 'admin',
      email: 'admin@scolio.com',
      userType: 'admin',
      firstName: 'Admin',
      lastName: 'User',
      isActive: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    {
      id: 'user2',
      username: 'teacher1',
      email: 'teacher1@scolio.com',
      userType: 'teacher',
      firstName: 'John',
      lastName: 'Smith',
      isActive: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    {
      id: 'user3',
      username: 'student1',
      email: 'student1@scolio.com',
      userType: 'student',
      firstName: 'Jane',
      lastName: 'Doe',
      isActive: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
  ],
  Teachers: [
    {
      id: 'teacher1',
      username: 'teacher1',
      employeeId: 'EMP001',
      subjects: ['Mathematics', 'Physics'],
      qualification: 'M.Sc. Mathematics',
      isActive: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
  ],
  Students: [
    {
      id: 'student1',
      username: 'student1',
      rollNumber: 'R001',
      classId: 'class1',
      admissionYear: '2023',
      isActive: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
  ],
  Classes: [
    {
      id: 'class1',
      name: 'Class 10',
      section: 'A',
      academicYear: '2023-2024',
      grade: 10,
      teacherId: 'teacher1',
      roomNumber: '101',
      capacity: 30,
      isActive: true,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
  ],
  Attendance: [
    {
      id: 'attendance1',
      classId: 'class1',
      date: new Date().toISOString().split('T')[0],
      presentStudents: ['student1'],
      absentStudents: [],
      totalStudents: 1,
      subject: 'Mathematics',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
  ]
};

// Create tables
async function createTable(tableDefinition) {
  try {
    console.log(`Creating table: ${tableDefinition.TableName}`);
    await dynamoDB.createTable(tableDefinition).promise();
    console.log(`Table created: ${tableDefinition.TableName}`);
    return true;
  } catch (error) {
    if (error.code === 'ResourceInUseException') {
      console.log(`Table already exists: ${tableDefinition.TableName}`);
      return true;
    }
    console.error(`Error creating table ${tableDefinition.TableName}:`, error);
    return false;
  }
}

// Insert sample data
async function insertSampleData(tableName, items) {
  console.log(`Inserting sample data into ${tableName}`);
  
  for (const item of items) {
    try {
      await documentClient.put({
        TableName: tableName,
        Item: item
      }).promise();
      console.log(`Inserted item with id ${item.id} into ${tableName}`);
    } catch (error) {
      console.error(`Error inserting item into ${tableName}:`, error);
    }
  }
}

// List tables
async function listTables() {
  try {
    const data = await dynamoDB.listTables().promise();
    console.log('Tables in DynamoDB Local:');
    console.log(data.TableNames);
  } catch (error) {
    console.error('Error listing tables:', error);
  }
}

// Initialize DynamoDB Local
async function initializeDynamoDB() {
  try {
    console.log('Initializing DynamoDB Local...');
    
    // Create tables
    for (const tableDefinition of tables) {
      await createTable(tableDefinition);
    }
    
    // Wait for tables to be active
    console.log('Waiting for tables to be active...');
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // Insert sample data
    for (const [tableName, items] of Object.entries(sampleData)) {
      await insertSampleData(tableName, items);
    }
    
    // List tables
    await listTables();
    
    console.log('DynamoDB Local initialization complete!');
  } catch (error) {
    console.error('Error initializing DynamoDB Local:', error);
  }
}

// Run initialization
initializeDynamoDB();

module.exports = { dynamoDB, documentClient }; 