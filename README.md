# Mid-Day Meal Management System

A Flutter web application for managing mid-day meal grocery usage updates.

## Features

### Teacher Account
- Login and enter daily grocery usage details for meal preparation
- For each entry, provide:
  - Date of usage
  - Grocery name
  - Quantity used
- Create a report for any selected period by choosing a "from date" and "to date"
- The report aggregates the total quantity of each grocery used during the selected period
- Submit the generated report to the associated Authority account

### Authority Account
- View submitted reports from teachers under their supervision
- Filter and view reports by teacher
- Update report status

## Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase (PostgreSQL)
- **State Management**: Provider
- **Database**: PostgreSQL (via Supabase)

## Setup

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Supabase account (free tier available)
- Dart SDK

### Installation

1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

2. **Set up Supabase:**
   - Create a Supabase project at [supabase.com](https://supabase.com)
   - Get your Project URL and anon key from Settings → API
   - Update `lib/config/database_config.dart` with your credentials:
     ```dart
     static const String supabaseUrl = 'https://your-project-id.supabase.co';
     static const String supabaseAnonKey = 'your-anon-key-here';
     ```

3. **Create Database Schema:**
   - Open Supabase SQL Editor
   - Run the SQL from `database/supabase_schema.sql`
   - This will create all necessary tables, indexes, and RLS policies

4. **Insert Test Data:**
   - Use the SQL Editor or Table Editor to insert test users
   - See `SUPABASE_SETUP_GUIDE.md` for detailed instructions

5. **Run the App:**
   ```bash
   flutter run -d chrome
   ```

## Database Schema

### Tables
- `users` - User accounts (Teachers and Authorities)
- `grocery_usage` - Daily grocery usage entries
- `reports` - Submitted reports
- `report_items` - Grocery items in each report

### Relationships
- Teachers have a foreign key to Authority (`authority_id`)
- Grocery usage entries are linked to Teachers
- Reports are linked to Teachers
- Report items are linked to Reports

## Project Structure

```
lib/
├── config/
│   └── database_config.dart          # Supabase configuration
├── models/
│   ├── user_model.dart               # User data model
│   ├── grocery_usage_model.dart      # Grocery usage model
│   └── report_model.dart             # Report model
├── providers/
│   └── app_provider.dart             # State management
├── screens/
│   ├── login_screen.dart             # Login page
│   ├── teacher_dashboard.dart        # Teacher dashboard
│   └── authority_dashboard.dart      # Authority dashboard
├── services/
│   ├── auth_service.dart             # Authentication service
│   └── supabase_service.dart         # Supabase database operations
└── main.dart                         # App entry point

database/
└── supabase_schema.sql               # PostgreSQL schema for Supabase
```

## Setup Guide

For detailed setup instructions, see [SUPABASE_SETUP_GUIDE.md](SUPABASE_SETUP_GUIDE.md)

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
   - Supabase PostgreSQL database
   - Row Level Security (RLS) policies
   - Efficient queries with indexes
   - Error handling

## Security Notes

1. **Passwords**: Currently stored in plain text for simplicity. For production:
   - Use password hashing (bcrypt, argon2)
   - Implement Supabase Auth for better security
   - Use secure password storage

2. **API Keys**: 
   - The anon key is safe for client-side use
   - Never expose the service_role key
   - Use environment variables for production

3. **Row Level Security**:
   - RLS policies are included in the schema
   - Review and test all policies
   - Ensure users can only access their own data

## Troubleshooting

### Supabase Connection Issues
- Check Supabase URL and key in `database_config.dart`
- Verify your internet connection
- Check Supabase status page

### Database Errors
- Verify that you ran the SQL schema
- Check Table Editor to see if tables exist
- Verify RLS policies if you get permission errors

### Authentication Issues
- Verify users exist in the database
- Check username and password are correct
- Verify the password field in database

## Future Enhancements

1. Password hashing and encryption
2. Supabase Auth integration
3. Report export (PDF/Excel)
4. Data visualization (charts)
5. Notifications system
6. Mobile app support
7. Multi-language support
8. Advanced filtering and search
9. Audit logging
10. Real-time updates

## License

This project is available under the MIT License.

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [Flutter Documentation](https://flutter.dev/docs)
