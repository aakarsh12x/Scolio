🎓 Scolio – Student Management System

Scolio is a comprehensive school management system that bridges teachers, students, and parents through an intuitive interface.
It features a Node.js backend (Express.js + DynamoDB) and a Flutter frontend, offering a complete end-to-end solution for educational institutions.

.

<img width="345" height="771" alt="Screenshot 2025-10-25 182733" src="https://github.com/user-attachments/assets/8ccc7580-629a-4a41-803e-58ef4c722f15" />


🏗️ Project Structure
scolio-school-management/
├── backend/                 # Node.js Backend (Express.js + DynamoDB)
├── frontend/                # Flutter Frontend
├── start_backend.bat        # Start backend only
├── start_frontend.bat       # Start frontend only
├── start_both.bat           # Start both simultaneously
└── README.md

🚀 Quick Start
▶️ Start Everything
start_both.bat

🧩 Start Individually
# Backend
start_backend.bat

# Frontend
start_frontend.bat

⚙️ Features
🖥️ Backend Features

👨‍🏫 User Management (Teachers, Students, Parents)

🏫 Class Management System

📅 Attendance Tracking

📚 Assignment Handling

🧾 Examination Management

🔔 Notification System

💾 Local Database using DynamoDB Local

📱 Frontend Features

🌐 Cross-Platform (Windows, Android, iOS)

⚡ Real-Time Updates from Backend API

👥 Role-Based Interface (Teacher, Student, Parent)

🎨 Modern Material Design UI

📶 Offline Fallback Support

🌐 API Overview
Endpoint	Description
http://localhost:3000	Main Backend API
http://localhost:3000/health	Health Check
http://localhost:3000/api/*	All API Endpoints
🔑 Demo Credentials
Role	Username	Password
Teacher	teacher	password
Student	student	password
Parent	parent	password
🧩 Requirements
Backend

Node.js v14+

Java 8+ (Required for DynamoDB Local)

Frontend

Flutter SDK v3.5.4+

Windows (or platform-specific) development setup

⚒️ Manual Setup
Backend Setup
cd backend
npm install
node src/index.js

Frontend Setup
cd frontend
flutter pub get
flutter run -d windows

🩺 Troubleshooting
Issue	Possible Fix
Backend won't start	Verify Java installation and environment variables
Frontend won't start	Run flutter doctor to fix SDK issues
API connection failed	Ensure backend is running on port 3000
Database errors	Restart DynamoDB Local instance
🏫 About Scolio

Scolio (derived from scholē, Greek for "school") is a modern, scalable solution designed to streamline academic management.
Built with simplicity and performance in mind, it helps educational institutions stay organized and connected.
