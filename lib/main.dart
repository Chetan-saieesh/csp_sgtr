import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app immediately - don't wait for Supabase initialization
  runApp(const MyApp());

  // Initialize Supabase in the background (non-blocking) with retry
  // Fire and forget - run in background without blocking
  Future.microtask(() => _initializeSupabase());
}

Future<void> _initializeSupabase() async {
  if (kDebugMode) {
    debugPrint('Starting Supabase initialization...');
  }

  try {
    // Use retry logic with timeout
    final success =
        await SupabaseService.initializeWithRetry(maxRetries: 3).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        if (kDebugMode) {
          debugPrint('⚠ Supabase initialization timed out after 30 seconds');
        }
        return false;
      },
    );

    if (success) {
      if (kDebugMode) {
        debugPrint('✓ Supabase initialized successfully');
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            '✗ Failed to initialize Supabase - app will continue but database features may not work');
      }
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('✗ Unexpected error during Supabase initialization: $e');
      debugPrint('Stack trace: $stackTrace');
    }
    // App continues even if Supabase fails
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'SMART GROCERY TRACKING & REPORTING FOR SCHOOLS',
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
