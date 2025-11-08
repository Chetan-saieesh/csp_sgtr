// Supabase Configuration
// Replace with your Supabase project credentials

class DatabaseConfig {
  // Supabase Project URL
  // Get this from your Supabase project settings -> API -> Project URL
  static const String supabaseUrl = 'https://eezbbodfhlnrgrlzeapy.supabase.co';

  // Supabase Anon/Public Key
  // Get this from your Supabase project settings -> API -> Project API keys -> anon public
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlemJib2RmaGxucmdybHplYXB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2MTQxNjksImV4cCI6MjA3ODE5MDE2OX0.t5pNsCbSAR0VfiuIjdN0CmMQlwS0tzdWtiVGhCv84LE';

  // Database table names
  static const String usersTable = 'users';
  static const String groceryUsageTable = 'grocery_usage';
  static const String reportsTable = 'reports';
  static const String reportItemsTable = 'report_items';
}

// IMPORTANT NOTES:
// 1. Never commit real credentials to version control
// 2. Use environment variables for production
// 3. For Flutter web, Supabase works perfectly with Row Level Security (RLS)
// 4. Make sure to enable RLS policies in your Supabase dashboard
// 5. The anon key is safe to use in client-side code (it's public)
// 6. For sensitive operations, use service role key on backend only
