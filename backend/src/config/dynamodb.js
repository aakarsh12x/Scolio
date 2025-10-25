const AWS = require('aws-sdk');
const config = require('./config');
const { v4: uuidv4 } = require('uuid');

class DynamoDBConnection {
  constructor() {
    this.dynamodb = null;
    this.docClient = null;
    this.isConnected = false;
  }

  async connect() {
    try {
      // Configure AWS SDK for DynamoDB Local
      AWS.config.update({
        region: config.database.dynamodb.region,
        endpoint: config.database.dynamodb.endpoint,
        accessKeyId: config.database.dynamodb.accessKeyId || 'local',
        secretAccessKey: config.database.dynamodb.secretAccessKey || 'local'
      });

      this.dynamodb = new AWS.DynamoDB();
      this.docClient = new AWS.DynamoDB.DocumentClient();

      // Test the connection
      await this.listTables();
      this.isConnected = true;
      console.log('DynamoDB Local connection established successfully.');
      
      return { dynamodb: this.dynamodb, docClient: this.docClient };
    } catch (error) {
      console.error('Unable to connect to DynamoDB Local:', error);
      throw error;
    }
  }

  async disconnect() {
    this.isConnected = false;
    console.log('DynamoDB Local connection closed.');
  }

  getDynamoDB() {
    return this.dynamodb;
  }

  getDocClient() {
    return this.docClient;
  }

  async listTables() {
    try {
      const result = await this.dynamodb.listTables().promise();
      return result.TableNames;
    } catch (error) {
      console.error('Error listing DynamoDB tables:', error);
      throw error;
    }
  }

  async createTable(params) {
    try {
      const result = await this.dynamodb.createTable(params).promise();
      console.log(`Table ${params.TableName} created successfully.`);
      return result;
    } catch (error) {
      if (error.code === 'ResourceInUseException') {
        console.log(`Table ${params.TableName} already exists.`);
        return null;
      } else {
        console.error(`Error creating table ${params.TableName}:`, error);
        throw error;
      }
    }
  }

  async deleteTable(tableName) {
    try {
      const result = await this.dynamodb.deleteTable({ TableName: tableName }).promise();
      console.log(`Table ${tableName} deleted successfully.`);
      return result;
    } catch (error) {
      console.error(`Error deleting table ${tableName}:`, error);
      throw error;
    }
  }

  async putItem(tableName, item) {
    try {
      const params = {
        TableName: tableName,
        Item: item
      };
      await this.docClient.put(params).promise();
      return item;
    } catch (error) {
      console.error(`Error putting item in ${tableName}:`, error);
      throw error;
    }
  }

  async getItem(tableName, key) {
    try {
      const params = {
        TableName: tableName,
        Key: key
      };
      const result = await this.docClient.get(params).promise();
      return result.Item;
    } catch (error) {
      console.error(`Error getting item from ${tableName}:`, error);
      throw error;
    }
  }

  async updateItem(tableName, key, updateExpression, expressionAttributeValues, expressionAttributeNames) {
    try {
      const params = {
        TableName: tableName,
        Key: key,
        UpdateExpression: updateExpression,
        ExpressionAttributeValues: expressionAttributeValues,
        ReturnValues: 'ALL_NEW'
      };
      
      if (expressionAttributeNames) {
        params.ExpressionAttributeNames = expressionAttributeNames;
      }
      
      const result = await this.docClient.update(params).promise();
      return result.Attributes;
    } catch (error) {
      console.error(`Error updating item in ${tableName}:`, error);
      throw error;
    }
  }

  async deleteItem(tableName, key) {
    try {
      const params = {
        TableName: tableName,
        Key: key
      };
      await this.docClient.delete(params).promise();
      return true;
    } catch (error) {
      console.error(`Error deleting item from ${tableName}:`, error);
      throw error;
    }
  }

  async query(tableName, keyConditionExpression, expressionAttributeValues, indexName = null) {
    try {
      const params = {
        TableName: tableName,
        KeyConditionExpression: keyConditionExpression,
        ExpressionAttributeValues: expressionAttributeValues
      };
      
      if (indexName) {
        params.IndexName = indexName;
      }
      
      const result = await this.docClient.query(params).promise();
      return result.Items;
    } catch (error) {
      console.error(`Error querying ${tableName}:`, error);
      throw error;
    }
  }

  async scan(tableName, filterExpression = null, expressionAttributeValues = null) {
    try {
      const params = {
        TableName: tableName
      };
      
      if (filterExpression) {
        params.FilterExpression = filterExpression;
        params.ExpressionAttributeValues = expressionAttributeValues;
      }
      
      const result = await this.docClient.scan(params).promise();
      return result.Items;
    } catch (error) {
      console.error(`Error scanning ${tableName}:`, error);
      throw error;
    }
  }

  async initializeTables() {
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
      },
      {
        TableName: 'Assignments',
        KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
        AttributeDefinitions: [
          { AttributeName: 'id', AttributeType: 'S' },
          { AttributeName: 'classId', AttributeType: 'S' },
          { AttributeName: 'teacherId', AttributeType: 'S' },
          { AttributeName: 'dueDate', AttributeType: 'S' }
        ],
        GlobalSecondaryIndexes: [
          {
            IndexName: 'ClassIndex',
            KeySchema: [{ AttributeName: 'classId', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          },
          {
            IndexName: 'TeacherIndex',
            KeySchema: [{ AttributeName: 'teacherId', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          },
          {
            IndexName: 'DueDateIndex',
            KeySchema: [{ AttributeName: 'dueDate', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          }
        ],
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      },
      {
        TableName: 'Exams',
        KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
        AttributeDefinitions: [
          { AttributeName: 'id', AttributeType: 'S' },
          { AttributeName: 'classId', AttributeType: 'S' },
          { AttributeName: 'teacherId', AttributeType: 'S' },
          { AttributeName: 'examDate', AttributeType: 'S' }
        ],
        GlobalSecondaryIndexes: [
          {
            IndexName: 'ClassIndex',
            KeySchema: [{ AttributeName: 'classId', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          },
          {
            IndexName: 'TeacherIndex',
            KeySchema: [{ AttributeName: 'teacherId', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          },
          {
            IndexName: 'ExamDateIndex',
            KeySchema: [{ AttributeName: 'examDate', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          }
        ],
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      },
      {
        TableName: 'Notifications',
        KeySchema: [{ AttributeName: 'id', KeyType: 'HASH' }],
        AttributeDefinitions: [
          { AttributeName: 'id', AttributeType: 'S' },
          { AttributeName: 'senderId', AttributeType: 'S' },
          { AttributeName: 'scheduledFor', AttributeType: 'S' },
          { AttributeName: 'type', AttributeType: 'S' }
        ],
        GlobalSecondaryIndexes: [
          {
            IndexName: 'SenderIndex',
            KeySchema: [{ AttributeName: 'senderId', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          },
          {
            IndexName: 'ScheduledIndex',
            KeySchema: [{ AttributeName: 'scheduledFor', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          },
          {
            IndexName: 'TypeIndex',
            KeySchema: [{ AttributeName: 'type', KeyType: 'HASH' }],
            Projection: { ProjectionType: 'ALL' },
            ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
          }
        ],
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 }
      }
    ];

    console.log('Initializing DynamoDB tables...');
    for (const table of tables) {
      await this.createTable(table);
    }
    console.log('DynamoDB tables initialized successfully.');
  }

  // Helper function to generate sample data for testing
  async insertSampleData() {
    const sampleData = {
      Users: [
        {
          id: uuidv4(),
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
          id: uuidv4(),
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
          id: uuidv4(),
          username: 'student1',
          email: 'student1@scolio.com',
          userType: 'student',
          firstName: 'Jane',
          lastName: 'Doe',
          isActive: true,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
      ]
    };

    console.log('Inserting sample data...');
    for (const [tableName, items] of Object.entries(sampleData)) {
      for (const item of items) {
        await this.putItem(tableName, item);
      }
    }
    console.log('Sample data inserted successfully.');
  }
}

module.exports = new DynamoDBConnection(); 