const { Sequelize } = require('sequelize');
const config = require('./config');

class PostgreSQLConnection {
  constructor() {
    this.sequelize = null;
    this.models = {};
  }

  async connect() {
    try {
      this.sequelize = new Sequelize(config.database.postgres);
      
      // Test the connection
      await this.sequelize.authenticate();
      console.log('PostgreSQL connection established successfully.');
      
      return this.sequelize;
    } catch (error) {
      console.error('Unable to connect to PostgreSQL database:', error);
      throw error;
    }
  }

  async disconnect() {
    if (this.sequelize) {
      await this.sequelize.close();
      console.log('PostgreSQL connection closed.');
    }
  }

  async syncModels(force = false) {
    try {
      await this.sequelize.sync({ force });
      console.log('PostgreSQL models synchronized successfully.');
    } catch (error) {
      console.error('Error synchronizing PostgreSQL models:', error);
      throw error;
    }
  }

  getSequelize() {
    return this.sequelize;
  }

  registerModel(name, model) {
    this.models[name] = model;
  }

  getModel(name) {
    return this.models[name];
  }

  getAllModels() {
    return this.models;
  }

  async createDatabase() {
    const dbConfig = { ...config.database.postgres };
    delete dbConfig.database;
    
    const tempSequelize = new Sequelize('postgres', dbConfig.username, dbConfig.password, {
      ...dbConfig,
      database: 'postgres'
    });

    try {
      await tempSequelize.query(`CREATE DATABASE "${config.database.postgres.database}"`);
      console.log(`Database ${config.database.postgres.database} created successfully.`);
    } catch (error) {
      if (error.original && error.original.code === '42P04') {
        console.log(`Database ${config.database.postgres.database} already exists.`);
      } else {
        console.error('Error creating database:', error);
        throw error;
      }
    } finally {
      await tempSequelize.close();
    }
  }

  async runMigrations() {
    // This would be used for running database migrations in production
    console.log('Running PostgreSQL migrations...');
    // Implementation would go here for actual migration files
  }
}

module.exports = new PostgreSQLConnection(); 