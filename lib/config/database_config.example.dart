// Supabase Configuration Template
// Copy this file to database_config.dart and fill in your credentials
// DO NOT commit database_config.dart with real credentials to version control

class DatabaseConfig {
  // Supabase Project URL
  // Get this from your Supabase project settings -> API -> Project URL
  static const String supabaseUrl = 'https://your-project-id.supabase.co';

  // Supabase Anon/Public Key
  // Get this from your Supabase project settings -> API -> Project API keys -> anon public
  static const String supabaseAnonKey = 'your-anon-key-here';

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

