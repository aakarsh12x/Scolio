const { server } = require('./app');
const config = require('./config/config');
const databaseService = require('./services/databaseService');

// Initialize database connection
const initializeApp = async () => {
  try {
    // Connect to database
    await databaseService.init();
    console.log('Database connection established');

    // Start server
    const PORT = config.PORT || 3000;
    server.listen(PORT, () => {
      console.log(`Server running in ${config.NODE_ENV} mode on port ${PORT}`);
      console.log(`API Documentation available at http://localhost:${PORT}/api-docs`);
    });
  } catch (error) {
    console.error('Failed to initialize application:', error);
    process.exit(1);
  }
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
  console.error('UNHANDLED REJECTION! Shutting down...');
  console.error(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  console.error('UNCAUGHT EXCEPTION! Shutting down...');
  console.error(err.name, err.message);
  process.exit(1);
});

// Initialize the application
initializeApp();