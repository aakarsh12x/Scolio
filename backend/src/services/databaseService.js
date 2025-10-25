const config = require('../config/config');
const postgresConnection = require('../config/database');
const dynamodbConnection = require('../config/dynamodb');
const { v4: uuidv4 } = require('uuid');
const moment = require('moment');

class DatabaseService {
  constructor() {
    this.dbType = config.database.type;
    this.postgres = null;
    this.dynamodb = null;
    this.isInitialized = false;
  }

  async init() {
    try {
      if (this.dbType === 'postgresql') {
        this.postgres = await postgresConnection.connect();
        console.log('Database Service initialized with PostgreSQL');
      } else {
        const { dynamodb, docClient } = await dynamodbConnection.connect();
        this.dynamodb = dynamodbConnection;
        console.log('Database Service initialized with DynamoDB Local');
        
        // Initialize tables
        await this.dynamodb.initializeTables();
      }
      this.isInitialized = true;
    } catch (error) {
      console.error('Error initializing database service:', error);
      throw error;
    }
  }

  async disconnect() {
    if (this.dbType === 'postgresql' && this.postgres) {
      await postgresConnection.disconnect();
    } else if (this.dbType === 'dynamodb' && this.dynamodb) {
      await dynamodbConnection.disconnect();
    }
    this.isInitialized = false;
  }

  // Generic CRUD Operations

  async create(table, data) {
    try {
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        return await model.create(data);
      } else {
        // Add timestamps and ID for DynamoDB
        const timestamp = moment().toISOString();
        const item = {
          ...data,
          id: data.id || uuidv4(),
          createdAt: data.createdAt || timestamp,
          updatedAt: data.updatedAt || timestamp
        };
        
        await this.dynamodb.putItem(table, item);
        return item;
      }
    } catch (error) {
      console.error(`Error creating item in ${table}:`, error);
      throw error;
    }
  }

  async findById(table, id) {
    try {
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        return await model.findByPk(id);
      } else {
        const key = { id };
        return await this.dynamodb.getItem(table, key);
      }
    } catch (error) {
      console.error(`Error finding item by ID in ${table}:`, error);
      throw error;
    }
  }

  async findAll(table, options = {}) {
    try {
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        return await model.findAll(options);
      } else {
        const { limit, offset, where, order } = options;
        let items = await this.dynamodb.scan(table);
        
        // Apply filtering if where clause exists
        if (where) {
          items = items.filter(item => {
            return Object.keys(where).every(key => {
              if (typeof where[key] === 'object' && where[key] !== null) {
                // Handle operators like $eq, $gt, $lt, etc.
                if (where[key].$eq) return item[key] === where[key].$eq;
                if (where[key].$gt) return item[key] > where[key].$gt;
                if (where[key].$gte) return item[key] >= where[key].$gte;
                if (where[key].$lt) return item[key] < where[key].$lt;
                if (where[key].$lte) return item[key] <= where[key].$lte;
                if (where[key].$ne) return item[key] !== where[key].$ne;
                if (where[key].$in) return where[key].$in.includes(item[key]);
                if (where[key].$like) {
                  const regex = new RegExp(where[key].$like.replace(/%/g, '.*'), 'i');
                  return regex.test(item[key]);
                }
                return false;
              }
              return item[key] === where[key];
            });
          });
        }
        
        // Apply sorting
        if (order && order.length > 0) {
          const [field, direction] = order[0];
          items.sort((a, b) => {
            if (direction.toUpperCase() === 'DESC') {
              return a[field] > b[field] ? -1 : 1;
            }
            return a[field] > b[field] ? 1 : -1;
          });
        }
        
        // Apply pagination
        if (offset) {
          items = items.slice(offset);
        }
        if (limit) {
          items = items.slice(0, limit);
        }
        
        return items;
      }
    } catch (error) {
      console.error(`Error finding all items in ${table}:`, error);
      throw error;
    }
  }

  async update(table, id, data) {
    try {
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        const [updatedRows] = await model.update(data, { where: { id } });
        if (updatedRows === 0) {
          throw new Error('Item not found');
        }
        return await model.findByPk(id);
      } else {
        // Check if item exists
        const existingItem = await this.dynamodb.getItem(table, { id });
        if (!existingItem) {
          throw new Error(`Item with id ${id} not found in ${table}`);
        }
        
        // Add updatedAt timestamp
        const updateData = {
          ...data,
          updatedAt: moment().toISOString()
        };
        
        // Build update expression
        const updateExpression = [];
        const expressionAttributeValues = {};
        const expressionAttributeNames = {};
        
        Object.keys(updateData).forEach(key => {
          updateExpression.push(`#${key} = :${key}`);
          expressionAttributeNames[`#${key}`] = key;
          expressionAttributeValues[`:${key}`] = updateData[key];
        });
        
        const params = {
          TableName: table,
          Key: { id },
          UpdateExpression: `SET ${updateExpression.join(', ')}`,
          ExpressionAttributeNames: expressionAttributeNames,
          ExpressionAttributeValues: expressionAttributeValues,
          ReturnValues: 'ALL_NEW'
        };
        
        const result = await this.dynamodb.getDocClient().update(params).promise();
        return result.Attributes;
      }
    } catch (error) {
      console.error(`Error updating item in ${table}:`, error);
      throw error;
    }
  }

  async delete(table, id) {
    try {
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        const deletedRows = await model.destroy({ where: { id } });
        return deletedRows > 0;
      } else {
        await this.dynamodb.deleteItem(table, { id });
        return true;
      }
    } catch (error) {
      console.error(`Error deleting item from ${table}:`, error);
      throw error;
    }
  }

  async findByCondition(table, condition) {
    try {
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        return await model.findAll({ where: condition });
      } else {
        const items = await this.dynamodb.scan(table);
        return items.filter(item => {
          return Object.keys(condition).every(key => item[key] === condition[key]);
        });
      }
    } catch (error) {
      console.error(`Error finding items by condition in ${table}:`, error);
      throw error;
    }
  }

  async findOne(table, condition) {
    try {
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        return await model.findOne({ where: condition });
      } else {
        const items = await this.dynamodb.scan(table);
        return items.find(item => {
          return Object.keys(condition).every(key => item[key] === condition[key]);
        });
      }
    } catch (error) {
      console.error(`Error finding one item in ${table}:`, error);
      throw error;
    }
  }

  async paginate(table, options = {}) {
    try {
      const { page = 1, limit = 20, where = {}, order = [['createdAt', 'DESC']] } = options;
      const offset = (page - 1) * limit;
      
      if (this.dbType === 'postgresql') {
        const model = postgresConnection.getModel(table);
        if (!model) {
          throw new Error(`Model ${table} not found`);
        }
        
        const { count, rows } = await model.findAndCountAll({
          where,
          order,
          limit,
          offset
        });
        
        const pagination = {
          page: parseInt(page),
          limit: parseInt(limit),
          total: count,
          pages: Math.ceil(count / limit),
          hasNext: page * limit < count,
          hasPrev: page > 1
        };
        
        return { data: rows, pagination };
      } else {
        // Get all items matching the condition
        const allItems = await this.findByCondition(table, where);
        
        // Sort items
        if (order && order.length > 0) {
          const [field, direction] = order[0];
          allItems.sort((a, b) => {
            if (direction.toUpperCase() === 'DESC') {
              return a[field] > b[field] ? -1 : 1;
            }
            return a[field] > b[field] ? 1 : -1;
          });
        }
        
        // Apply pagination
        const total = allItems.length;
        const paginatedItems = allItems.slice(offset, offset + limit);
        
        const pagination = {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / limit),
          hasNext: page * limit < total,
          hasPrev: page > 1
        };
        
        return { data: paginatedItems, pagination };
      }
    } catch (error) {
      console.error(`Error paginating items in ${table}:`, error);
      throw error;
    }
  }

  async rawQuery(query, values = []) {
    if (this.dbType === 'postgresql' && this.postgres) {
      return await postgresConnection.query(query, values);
    } else {
      throw new Error('Raw queries are not supported with DynamoDB');
    }
  }

  getConnection() {
    if (this.dbType === 'postgresql') {
      return this.postgres;
    } else {
      return this.dynamodb;
    }
  }

  getDatabaseType() {
    return this.dbType;
  }
}

module.exports = new DatabaseService(); 