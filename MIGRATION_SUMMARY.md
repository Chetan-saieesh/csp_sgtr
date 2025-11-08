# Migration Summary: MongoDB to Supabase

## Overview

The application has been successfully migrated from MongoDB to Supabase (PostgreSQL). All database operations now use Supabase instead of MongoDB.

## Changes Made

### 1. Dependencies (`pubspec.yaml`)
- **Removed**: `mongo_dart: ^0.7.1+1`
- **Added**: `supabase_flutter: ^2.5.6`

### 2. Database Service
- **Removed**: `lib/services/mongodb_service.dart` (kept for reference)
- **Created**: `lib/services/supabase_service.dart`
  - All CRUD operations using Supabase client
  - Proper error handling
  - Support for PostgreSQL data types

### 3. Configuration
- **Updated**: `lib/config/database_config.dart`
  - Changed from MongoDB connection string to Supabase URL and anon key
  - Updated table names to match PostgreSQL naming conventions

### 4. Models
All models updated to support both MongoDB and Supabase formats:
- **`user_model.dart`**: Added `toMapForSupabase()` and `fromSupabaseMap()`
- **`grocery_usage_model.dart`**: Added Supabase mapping methods
- **`report_model.dart`**: Added Supabase mapping methods
- **`GroceryReportItem`**: Added Supabase mapping methods

### 5. Services
- **Updated**: `lib/services/auth_service.dart`
  - Changed from `MongoDbService` to `SupabaseService`

### 6. Screens
- **Updated**: `lib/screens/teacher_dashboard.dart`
  - All database calls now use `SupabaseService`
- **Updated**: `lib/screens/authority_dashboard.dart`
  - All database calls now use `SupabaseService`

### 7. Main App
- **Updated**: `lib/main.dart`
  - Changed initialization from `MongoDbService.connect()` to `SupabaseService.initialize()`

### 8. Database Schema
- **Created**: `database/supabase_schema.sql`
  - Complete PostgreSQL schema
  - Tables: `users`, `grocery_usage`, `reports`, `report_items`
  - Indexes for performance
  - Row Level Security (RLS) policies
  - Triggers for auto-updating timestamps
  - Sample test data

## Key Differences

### Database Structure

#### MongoDB (Old)
- Collections: `users`, `grocery_usage`, `reports`
- Document-based (JSON)
- Field names: camelCase (e.g., `teacherId`, `groceryName`)
- ID field: `_id` (ObjectId string)

#### Supabase/PostgreSQL (New)
- Tables: `users`, `grocery_usage`, `reports`, `report_items`
- Relational database (SQL)
- Field names: snake_case (e.g., `teacher_id`, `grocery_name`)
- ID field: `id` (UUID)

### Data Mapping

| MongoDB Field | PostgreSQL Field | Type |
|--------------|------------------|------|
| `_id` | `id` | UUID (auto-generated) |
| `teacherId` | `teacher_id` | UUID (foreign key) |
| `groceryName` | `grocery_name` | VARCHAR |
| `fromDate` | `from_date` | DATE |
| `toDate` | `to_date` | DATE |
| `submittedAt` | `submitted_at` | TIMESTAMP |

### Report Items Storage

#### MongoDB (Old)
- Stored as nested array in `reports` collection
- Single document with all data

#### Supabase/PostgreSQL (New)
- Stored in separate `report_items` table
- Relational design with foreign key to `reports`
- Better for querying and normalization

## Benefits of Migration

1. **Better Web Support**: Supabase works seamlessly with Flutter web
2. **Row Level Security**: Built-in RLS policies for data security
3. **Type Safety**: PostgreSQL provides strong typing
4. **Relationships**: Foreign keys ensure data integrity
5. **Scalability**: PostgreSQL is highly scalable
6. **Real-time**: Supabase supports real-time subscriptions (future feature)
7. **Authentication**: Can easily integrate Supabase Auth (future enhancement)
8. **Free Tier**: Generous free tier for development

## Migration Steps for Users

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Set up Supabase**:
   - Create Supabase project
   - Get project URL and anon key
   - Update `lib/config/database_config.dart`

3. **Create Database Schema**:
   - Run `database/supabase_schema.sql` in Supabase SQL Editor

4. **Insert Test Data**:
   - Use SQL Editor or Table Editor to create test users

5. **Run the App**:
   ```bash
   flutter run -d chrome
   ```

## Files to Update for Credentials

### `lib/config/database_config.dart`
Update these values:
```dart
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

## Testing Checklist

- [ ] Supabase connection successful
- [ ] User authentication works
- [ ] Teacher can add grocery usage
- [ ] Teacher can generate reports
- [ ] Teacher can view report history
- [ ] Authority can view teachers
- [ ] Authority can view reports
- [ ] Authority can filter reports by teacher
- [ ] Authority can update report status
- [ ] Date range queries work correctly
- [ ] Data aggregation works correctly

## Known Issues

1. **Passwords in Plain Text**: 
   - Currently stored without hashing
   - Should implement password hashing for production
   - Consider using Supabase Auth

2. **RLS Policies**: 
   - RLS policies are included but may need adjustment
   - Currently uses custom authentication
   - For testing, RLS can be temporarily disabled

## Future Improvements

1. Implement password hashing
2. Migrate to Supabase Auth
3. Add real-time updates
4. Implement proper error handling
5. Add data validation
6. Add audit logging
7. Implement soft deletes
8. Add database backups

## Rollback Plan

If you need to rollback to MongoDB:
1. Restore `pubspec.yaml` to use `mongo_dart`
2. Restore `lib/services/mongodb_service.dart`
3. Update all service calls back to `MongoDbService`
4. Update `lib/config/database_config.dart` with MongoDB connection string
5. Update `lib/main.dart` to use MongoDB initialization

## Support

For issues or questions:
1. Check `SUPABASE_SETUP_GUIDE.md` for setup instructions
2. Review Supabase documentation
3. Check error messages in browser console
4. Verify database schema is correct
5. Check RLS policies if getting permission errors

