# Supabase Setup Guide for SMART GROCERY TRACKING & REPORTING FOR SCHOOLS

## Step 1: Create Supabase Project

1. Go to [Supabase](https://supabase.com)
2. Sign up or log in
3. Click "New Project"
4. Fill in project details:
   - **Name**: Smart Grocery Tracking App (or your preferred name)
   - **Database Password**: Choose a strong password (save it securely)
   - **Region**: Select the closest region to your users
5. Click "Create new project"
6. Wait for the project to be created (takes 2-3 minutes)

## Step 2: Get Project Credentials

1. In your Supabase project dashboard, go to **Settings** → **API**
2. Copy the following:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

## Step 3: Update App Configuration

1. Open `lib/config/database_config.dart`
2. Replace the placeholder values:

```dart
class DatabaseConfig {
  static const String supabaseUrl = 'https://your-project-id.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
  // ... rest of the code
}
```

## Step 4: Create Database Schema

1. In Supabase dashboard, go to **SQL Editor**
2. Click "New query"
3. Open the file `database/supabase_schema.sql` from this project
4. Copy the entire SQL content
5. Paste it into the SQL Editor
6. Click "Run" or press `Ctrl+Enter`
7. Verify that all tables are created:
   - Go to **Table Editor** → You should see:
     - `users`
     - `grocery_usage`
     - `reports`
     - `report_items`

## Step 5: Configure Row Level Security (RLS)

The SQL schema includes RLS policies, but you may need to adjust them based on your authentication setup.

### Option A: Disable RLS for Testing (Not Recommended for Production)

If you want to test without authentication first:

1. Go to **Table Editor**
2. For each table (`users`, `grocery_usage`, `reports`, `report_items`):
   - Click on the table
   - Go to **Settings** tab
   - Toggle off "Enable Row Level Security"

### Option B: Use RLS with Custom Auth (Current Setup)

The provided SQL includes RLS policies that work with the custom authentication in the app. These policies check user IDs directly.

## Step 6: Insert Test Data

### Using SQL Editor

Run this SQL in the SQL Editor:

```sql
-- Insert test authority user
INSERT INTO users (id, username, password, role, name, email) 
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'authority1',
    'password123',
    'authority',
    'Authority User',
    'authority@example.com'
) ON CONFLICT (username) DO NOTHING;

-- Insert test teacher user
INSERT INTO users (id, username, password, role, authority_id, name, email) 
VALUES (
    '00000000-0000-0000-0000-000000000002',
    'teacher1',
    'password123',
    'teacher',
    '00000000-0000-0000-0000-000000000001',
    'Teacher User',
    'teacher@example.com'
) ON CONFLICT (username) DO NOTHING;
```

### Using Table Editor

1. Go to **Table Editor** → `users`
2. Click "Insert" → "Insert row"
3. Add authority user:
   - `id`: `00000000-0000-0000-0000-000000000001` (or generate UUID)
   - `username`: `authority1`
   - `password`: `password123`
   - `role`: `authority`
   - `name`: `Authority User`
   - `email`: `authority@example.com`
4. Click "Save"
5. Repeat for teacher user (make sure `authority_id` matches the authority's `id`)

## Step 7: Install Dependencies and Run App

1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run -d chrome
   ```

## Step 8: Test the Application

1. **Login as Teacher**:
   - Username: `teacher1`
   - Password: `password123`
   - You should see the Teacher Dashboard

2. **Add Grocery Usage**:
   - Go to "Add Grocery" section
   - Enter grocery details
   - Submit and verify it's saved

3. **Generate Report**:
   - Go to "Generate Report" section
   - Select date range
   - Generate and submit report

4. **Login as Authority**:
   - Username: `authority1`
   - Password: `password123`
   - You should see the Authority Dashboard
   - View submitted reports from teachers

## Troubleshooting

### Connection Issues

1. **Check Supabase URL and Key**:
   - Verify in `lib/config/database_config.dart`
   - Make sure there are no extra spaces

2. **Check Network**:
   - Ensure your internet connection is stable
   - Check if Supabase is accessible from your location

3. **Check Supabase Status**:
   - Visit [Supabase Status Page](https://status.supabase.com)

### Database Errors

1. **Table Not Found**:
   - Verify that you ran the SQL schema
   - Check Table Editor to see if tables exist

2. **Permission Denied**:
   - Check RLS policies
   - For testing, you can temporarily disable RLS
   - Or verify that RLS policies match your authentication setup

3. **Foreign Key Violations**:
   - Ensure test users are created correctly
   - Verify `authority_id` in teacher records matches an existing authority `id`

### Authentication Issues

1. **Login Fails**:
   - Verify users exist in the database
   - Check username and password are correct
   - Verify the password field in database matches what you're entering

2. **User Not Found**:
   - Check the `users` table in Supabase
   - Verify the query in `SupabaseService.authenticateUser()`

## Security Recommendations

### For Production:

1. **Password Hashing**:
   - Never store passwords in plain text
   - Use bcrypt or similar hashing algorithm
   - Update the authentication logic to hash passwords before storing
   - Hash passwords before comparing during login

2. **Use Supabase Auth**:
   - Consider migrating to Supabase's built-in authentication
   - It provides email/password, OAuth, and more
   - Better security and user management

3. **Environment Variables**:
   - Don't commit credentials to version control
   - Use environment variables or secure storage
   - Consider using `.env` files (not committed to git)

4. **RLS Policies**:
   - Review and test all RLS policies
   - Ensure users can only access their own data
   - Test edge cases

5. **API Keys**:
   - The anon key is safe for client-side use
   - Never expose the service_role key
   - Use service_role key only on backend servers

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)

## Next Steps

1. Implement password hashing
2. Add email verification
3. Add password reset functionality
4. Implement proper error handling
5. Add data validation
6. Set up automated backups
7. Configure monitoring and alerts
8. Plan for scaling

