# Athar

Athar is a volunteer management and community platform designed to help organize volunteers, campaigns, tasks, attendance, reporting, emergency requests, and community engagement through a connected mobile application and backend API.

The repository contains a Flutter mobile application backed by a RESTful API built with Node.js, Express.js, MySQL, and Prisma ORM.

## Backend Highlights

* Secure authentication using JWT access and refresh tokens
* User registration, login, logout, and session management
* Volunteer profiles, points, badges, recognition, and leaderboards
* Campaign creation and management
* Task management and volunteer assignment
* Attendance tracking and task check-in
* Reports and volunteer activity tracking
* SOS request creation and status management
* Community feed with posts, likes, and comments
* Announcements and home dashboard data
* Database health and readiness checks
* Postman collection for API testing

## Tech Stack

### Backend

* Node.js
* Express.js
* MySQL
* Prisma ORM
* JWT Authentication
* bcryptjs
* REST APIs
* Docker

### Mobile

* Flutter
* Dart

### Tools

* Git & GitHub
* Postman
* Prisma Studio

## Backend Architecture

```text
backend/
├── prisma/
│   ├── migrations/
│   └── schema.prisma
├── src/
│   ├── config/
│   ├── controllers/
│   ├── middleware/
│   ├── routes/
│   ├── services/
│   ├── utils/
│   ├── validators/
│   ├── app.js
│   └── server.js
├── postman/
├── Dockerfile
└── package.json
```

## Main API Modules

```text
/api/auth
/api/profile
/api/home
/api/announcements
/api/attendance
/api/campaigns
/api/tasks
/api/reports
/api/sos-requests
/api/community
```

## Authentication

The backend implements JWT-based authentication with access and refresh tokens.

Supported authentication operations include:

* Register
* Login
* Refresh access token
* Logout
* Logout from all sessions
* Retrieve authenticated user profile

## Database

The backend uses MySQL with Prisma ORM for database access and schema management.

Core entities include:

* Volunteers
* Authentication Sessions
* Campaigns
* Tasks
* Volunteer Assignments
* Attendance
* Reports
* SOS Requests
* Badges
* Ratings
* Announcements
* Community Posts, Comments, and Likes

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/khalidatef/Athar-App.git
cd Athar-App/backend
```

### 2. Install dependencies

```bash
npm install
```

### 3. Configure environment variables

Create a `.env` file inside the `backend` directory and configure:

```env
DATABASE_URL=
JWT_SECRET=
JWT_REFRESH_SECRET=
JWT_ACCESS_EXPIRES_IN=
JWT_REFRESH_EXPIRES_IN=
PORT=3000
CORS_ORIGINS=
```

### 4. Generate Prisma Client

```bash
npm run prisma:generate
```

### 5. Run database migrations

```bash
npm run prisma:migrate
```

### 6. Start the development server

```bash
npm run dev
```

The API will be available at:

```text
http://localhost:3000/api
```

Health check:

```text
GET /api/health
```

## Docker

The backend includes a Dockerfile for containerized deployment.

From the project root:

```bash
docker build -f backend/Dockerfile -t athar-backend .
docker run --env-file backend/.env -p 3000:3000 athar-backend
```

## API Testing

A Postman collection and environment configurations are included inside the `backend/postman` directory for testing the API endpoints.

## Backend Development

The backend was designed to support the complete volunteer workflow of the application, covering API development, authentication, database modeling, business logic, and integration with the Flutter client.
