# CivicTrust 🚦

**AI-Powered Municipal Issue Management Platform**

CivicTrust is a modern municipal operations platform that helps local governments efficiently manage civic complaints by centralizing reports, tracking issues, and supporting AI-powered duplicate detection.

---

## 📌 Problem Statement

Municipal corporations receive complaints from multiple sources such as citizens, ward offices, municipal staff, and verified news agencies. These reports often describe the same real-world issue, resulting in duplicate records, delayed action, inefficient resource allocation, and increased manual effort.

CivicTrust addresses this challenge by providing a centralized platform to manage reports and issues while laying the foundation for AI-powered duplicate detection.

---

## ✨ Features

### 📊 Dashboard
- Live municipal statistics
- Total Reports
- Total Issues
- Assignments Overview
- Audit Activity

### 📝 Reports Management
- Live data from Supabase
- Search reports
- Filter by category
- Filter by status
- Filter by source
- Responsive table interface

### 📍 Issue Management
- Issue tracking
- Department mapping
- Priority management
- Resolution workflow

### 👷 Assignment Tracking
- Officer assignments
- Field task monitoring
- Status tracking

### 📈 Analytics
- Resolution trends
- Operational insights
- Ward-level monitoring

---

## 🏗️ System Architecture

```
Citizens / Ward Offices / Municipality
                │
                ▼
        CivicTrust Frontend
      (React + TypeScript)
                │
                ▼
         Supabase Backend
                │
                ▼
        PostgreSQL Database
                │
                ▼
      Municipal Operations Dashboard
```

---

## 🛠️ Tech Stack

### Frontend
- React
- TypeScript
- TanStack Router
- Tailwind CSS
- shadcn/ui
- Lucide React

### Backend
- Supabase
- PostgreSQL

### Development Tools
- Vite
- Git
- GitHub
- Visual Studio Code

---

## ☁️ Google Technologies

- Google Cloud Platform (Deployment)
- Google AI Studio
- Gemini API (Planned AI Integration)

Future AI capabilities include:

- Duplicate report detection
- Automatic issue grouping
- AI-generated summaries
- Priority prediction
- Category prediction

---

## 🗄️ Database

The project uses a normalized PostgreSQL database hosted on Supabase.

Main tables include:

- Users
- Reports
- Categories
- Departments
- Wards
- Issues
- Assignments
- Field Tasks
- AI Analysis
- Duplicate Candidates
- Audit Logs

---

## 🚀 Getting Started

### Clone the repository

```bash
git clone https://github.com/nsaichandana/civic-issue-sync.git

cd civic-issue-sync
```

### Install dependencies

```bash
npm install
```

### Configure Environment Variables

Create a `.env` file in the project root.

```env
VITE_SUPABASE_URL=your_supabase_project_url

VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Start the development server

```bash
npm run dev
```

Open:

```
http://localhost:8080
```

---

## 📂 Project Structure

```
src/
 ├── components/
 ├── config/
 ├── hooks/
 ├── lib/
 ├── routes/
 ├── services/
 ├── types/

database/
 ├── schema/
 ├── seed/
 ├── policies/

docs/
```

---

## 📸 Screenshots

Add screenshots of:

- Login Page
- Dashboard
- Reports Module
- Issues Module
- Analytics
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/19216014-61f5-4ad9-a4e5-9e2e6d58e32c" />
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/2cfd53dd-c06c-40ae-bb03-08ff941fecd2" />
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/36819dbb-a61c-490a-af34-17ce0bed3aa6" />
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/433a5322-10f0-4c9f-8dbc-a9082cc85291" />




---

## 🚧 Current Status

### ✅ Completed

- Responsive UI
- Supabase Integration
- Dashboard Statistics
- Reports Module
- Search & Filtering
- Relational Database Design
- Modular Project Architecture

### 🚀 Planned

- Gemini AI Integration
- Duplicate Detection
- Authentication
- Google Maps Integration
- Image Analysis
- Notifications
- Advanced Analytics

---

## 🎯 Future Scope

- AI-assisted issue prioritization
- Smart duplicate detection
- Predictive municipal analytics
- Mobile application
- Field worker management
- Citizen notifications
- Real-time collaboration

---

## 👤 Author

**Nunna Saichandana**

GitHub: https://github.com/nsaichandana

---

## 📄 License

This project was developed as part of a hackathon submission and is intended for educational and demonstration purposes.
