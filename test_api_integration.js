const http = require('http');

const baseUrl = 'http://localhost:3000';

// Test endpoints
const endpoints = [
  '/health',
  '/api/users',
  '/api/teachers',
  '/api/students',
  '/api/classes',
  '/api/attendance',
  '/api/assignments',
  '/api/exams',
  '/api/notifications'
];

console.log('🧪 Testing péče School Management API Integration');
console.log('================================================');

async function testEndpoint(endpoint) {
  return new Promise((resolve, reject) => {
    const req = http.get(`${baseUrl}${endpoint}`, (res) => {
      let data = '';
      
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      res.on('end', () => {
        try {
          const jsonData = JSON.parse(data);
          resolve({
            endpoint,
            status: res.statusCode,
            success: jsonData.success,
            message: jsonData.message,
            dataLength: Array.isArray(jsonData.data) ? jsonData.data.length : 'N/A'
          });
        } catch (error) {
          resolve({
            endpoint,
            status: res.statusCode,
            success: false,
            message: 'Invalid JSON response',
            dataLength: 'N/A'
          });
        }
      });
    });
    
    req.on('error', (error) => {
      resolve({
        endpoint,
        status: 'ERROR',
        success: false,
        message: error.message,
        dataLength: 'N/A'
      });
    });
    
    req.setTimeout(5000, () => {
      req.destroy();
      resolve({
        endpoint,
        status: 'TIMEOUT',
        success: false,
        message: 'Request timeout',
        dataLength: 'N/A'
      });
    });
  });
}

async function runTests() {
  console.log('Starting API tests...\n');
  
  for (const endpoint of endpoints) {
    const result = await testEndpoint(endpoint);
    
    const statusIcon = result.success ? '✅' : '❌';
    const statusText = result.status === 200 ? 'OK' : result.status;
    
    console.log(`${statusIcon} ${endpoint.padEnd(20)} | ${statusText} | ${result.message} | Data: ${result.dataLength}`);
  }
  
  console.log('\n================================================');
  console.log('✅ API Integration Test Complete!');
  console.log('');
  console.log('🎯 Next Steps:');
  console.log('1. Start the Flutter frontend: flutter run -d windows');
  console.log('2. Login with demo credentials:');
  console.log('   - Teacher: teacher / password');
  console.log('   - Student: student / password');
  console.log('   - Parent: parent / password');
  console.log('3. Test real data integration in the app');
  console.log('');
  console.log('🔗 Backend API: http://localhost:3000');
  console.log('🏥 Health Check: http://localhost:3000/health');
}

runTests().catch(console.error); 