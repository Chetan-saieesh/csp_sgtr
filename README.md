# SMART GROCERY TRACKING & REPORTING FOR SCHOOLS

A Flutter web application for smart grocery tracking and reporting for schools.

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

## Deploying to Netlify

This repository contains a GitHub Actions workflow that builds the Flutter web app and deploys the generated static files to Netlify.

### Automated Deployment via GitHub Actions

What the workflow does:
- Installs Flutter (stable channel)
- Runs `flutter pub get` and `flutter build web --release`
- Deploys the `build/web` folder to Netlify using the Netlify GitHub Action

**Setup Steps:**

1. **Create a Netlify Site:**
   - Go to [Netlify](https://app.netlify.com) and sign in
   - Click "Add new site" → "Import an existing project"
   - Connect your GitHub repository
   - Note: You can create an empty site first, we'll configure it via GitHub Actions

2. **Get Netlify Credentials:**
   - Go to [Netlify User Settings → Applications → New access token](https://app.netlify.com/user/applications)
   - Create a new access token and copy it
   - Go to your site settings → General → Site details
   - Copy your **Site ID**

3. **Add GitHub Secrets:**
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `NETLIFY_AUTH_TOKEN` — your Netlify access token
     - `NETLIFY_SITE_ID` — your Netlify site ID

4. **Deploy:**
   - Push to the `main` branch or manually trigger the workflow
   - The workflow will automatically build and deploy to Netlify

### Manual Deployment

If you prefer to deploy manually:

1. **Build locally:**
   ```bash
   flutter build web --release
   ```

2. **Deploy using Netlify CLI:**
   ```bash
   npm install -g netlify-cli
   netlify login
   netlify deploy --prod --dir=build/web
   ```

3. **Or drag and drop:**
   - Go to [Netlify Drop](https://app.netlify.com/drop)
   - Drag and drop your `build/web` folder

### Netlify Configuration

The `netlify.toml` file includes:
- SPA routing configuration (redirects all routes to index.html)
- Security headers
- Cache control for static assets

## Deploying to Vercel

This repository contains a GitHub Actions workflow that builds the Flutter web app and deploys the generated static files to Vercel.

What the workflow does:
- Installs Flutter (stable channel)
- Runs `flutter pub get` and `flutter build web --release`
- Deploys the `build/web` folder to Vercel using the Vercel GitHub Action

Required GitHub repository secrets (set these in your repository Settings → Secrets):
- `VERCEL_TOKEN` — your Vercel personal token (create at https://vercel.com/account/tokens)
- `VERCEL_ORG_ID` — your Vercel organization ID (find in your Vercel project settings)
- `VERCEL_PROJECT_ID` — your Vercel project ID (find in your Vercel project settings)

Notes / tips:
- The workflow runs on pushes to `main`.
- You must create a Vercel project (you can create an empty project) and set the `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` for that project.
- If you prefer to deploy directly from your local machine, you can build locally (`flutter build web`) and use `vercel` CLI to deploy the `build/web` folder.
- If you want Vercel to build on its side, note that Vercel's build environment does not include Flutter by default; using the GitHub Actions approach is recommended.
