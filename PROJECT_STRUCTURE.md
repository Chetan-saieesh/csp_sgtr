# Project Structure

## Directory Overview

```
mid_day_meal_app/
├── lib/
│   ├── config/
│   │   └── database_config.dart          # MongoDB connection configuration
│   ├── models/
│   │   ├── user_model.dart               # User data model (Teacher/Authority)
│   │   ├── grocery_usage_model.dart      # Grocery usage entry model
│   │   └── report_model.dart             # Report model with aggregated data
│   ├── providers/
│   │   └── app_provider.dart             # State management using Provider
│   ├── screens/
│   │   ├── login_screen.dart             # Login page
│   │   ├── teacher_dashboard.dart        # Teacher dashboard with forms
│   │   └── authority_dashboard.dart      # Authority dashboard with reports
│   ├── services/
│   │   ├── auth_service.dart             # Authentication service
│   │   └── mongodb_service.dart          # MongoDB database operations
│   └── main.dart                         # App entry point
├── web/
│   ├── index.html                        # Web app HTML entry point
│   └── manifest.json                     # PWA manifest
├── pubspec.yaml                          # Flutter dependencies
├── README.md                             # Project documentation
├── SETUP_GUIDE.md                        # Setup instructions
└── .gitignore                            # Git ignore rules
```

## File Descriptions

### Models

#### `user_model.dart`
- Represents user accounts (Teacher and Authority)
- Fields: id, username, password, role, authorityId, name, email
- Provides `toMap()` and `fromMap()` methods for MongoDB serialization

#### `grocery_usage_model.dart`
- Represents individual grocery usage entries
- Fields: id, teacherId, date, groceryName, quantity, unit
- Stores daily grocery consumption records

#### `report_model.dart`
- Represents submitted reports with aggregated data
- Contains: id, teacherId, teacherName, fromDate, toDate, groceryItems, submittedAt, status
- `GroceryReportItem` class for aggregated grocery quantities

### Services

#### `mongodb_service.dart`
- Handles all MongoDB database operations
- Methods:
  - `connect()` - Establish MongoDB connection
  - `authenticateUser()` - User authentication
  - `getTeachersByAuthority()` - Get teachers for an authority
  - `addGroceryUsage()` - Add grocery usage entry
  - `getGroceryUsageByDateRange()` - Get usage for date range
  - `submitReport()` - Submit report to database
  - `getReportsByAuthority()` - Get reports for authority
  - `getReportsByTeacher()` - Get reports for teacher
  - `updateReportStatus()` - Update report status

#### `auth_service.dart`
- Manages user authentication state
- Stores current user session
- Provides login/logout functionality

### Providers

#### `app_provider.dart`
- State management using Provider pattern
- Manages authentication state
- Handles user login/logout
- Notifies widgets of state changes

### Screens

#### `login_screen.dart`
- User login interface
- Form validation
- Role-based navigation (Teacher/Authority)

#### `teacher_dashboard.dart`
- Three main sections:
  1. Add Grocery Usage - Form to enter daily usage
  2. Generate Report - Date range selection and report generation
  3. Report History - View submitted reports
- Navigation rail for section switching
- Real-time data loading

#### `authority_dashboard.dart`
- Two-panel layout:
  - Left panel: List of teachers
  - Right panel: Submitted reports
- Teacher filtering
- Report viewing with expandable details
- Report status updates

### Configuration

#### `database_config.dart`
- MongoDB connection string
- Database and collection names
- Centralized configuration

## Data Flow

### Teacher Flow
1. Login → Teacher Dashboard
2. Add Grocery Usage → MongoDB
3. Generate Report → Aggregate data → Submit to MongoDB
4. View Report History → Load from MongoDB

### Authority Flow
1. Login → Authority Dashboard
2. View Teachers → Load from MongoDB
3. Filter by Teacher → Query MongoDB
4. View Reports → Display aggregated data
5. Update Status → Update MongoDB

## Database Schema

### Users Collection
```json
{
  "_id": "string",
  "username": "string",
  "password": "string",
  "role": "teacher" | "authority",
  "authorityId": "string" (for teachers only),
  "name": "string",
  "email": "string"
}
```

### Grocery Usage Collection
```json
{
  "_id": "string",
  "teacherId": "string",
  "date": "ISO8601 string",
  "groceryName": "string",
  "quantity": "number",
  "unit": "string"
}
```

### Reports Collection
```json
{
  "_id": "string",
  "teacherId": "string",
  "teacherName": "string",
  "fromDate": "ISO8601 string",
  "toDate": "ISO8601 string",
  "groceryItems": [
    {
      "groceryName": "string",
      "totalQuantity": "number",
      "unit": "string"
    }
  ],
  "submittedAt": "ISO8601 string",
  "status": "submitted" | "viewed"
}
```

## Key Features

1. **Role-Based Access Control**
   - Teacher and Authority roles
   - Different dashboards for each role
   - Authority can view multiple teachers

2. **Data Aggregation**
   - Automatic aggregation of grocery quantities by date range
   - Grouped by grocery name
   - Total quantity calculation

3. **Report Management**
   - Report generation with date range selection
   - Report submission to authority
   - Report status tracking
   - Report history viewing

4. **User Interface**
   - Clean, modern Material Design
   - Telugu language support
   - Responsive layout
   - Form validation
   - Error handling

5. **Database Integration**
   - Direct MongoDB connection
   - CRUD operations
   - Query optimization
   - Error handling

## Future Enhancements

1. Password hashing and encryption
2. JWT token authentication
3. REST API backend
4. Report export (PDF/Excel)
5. Data visualization (charts)
6. Notifications system
7. Mobile app support
8. Multi-language support
9. Advanced filtering and search
10. Audit logging

