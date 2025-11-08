import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase - don't block app startup if it fails
  _initializeSupabase();

  runApp(const MyApp());
}

Future<void> _initializeSupabase() async {
  try {
    await SupabaseService.initialize();
    if (kDebugMode) {
      print('✓ Supabase initialized successfully');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('✗ Failed to initialize Supabase: $e');
      print('Stack trace: $stackTrace');
    }
    // Don't rethrow - let the app continue
    // The app will show an error when trying to use database operations
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'Mid-Day Meal Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
