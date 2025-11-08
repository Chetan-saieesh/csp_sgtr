import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/database_config.dart';
import '../models/user_model.dart';
import '../models/grocery_usage_model.dart';
import '../models/report_model.dart';

class SupabaseService {
  static SupabaseClient? _client;
  static SupabaseClient? get client => _client;
  
  static bool get isInitialized => _client != null;

  static Future<void> initialize() async {
    try {
      // Check if already initialized
      if (_client != null) {
        return;
      }
      
      await Supabase.initialize(
        url: DatabaseConfig.supabaseUrl,
        anonKey: DatabaseConfig.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      print('Supabase initialized successfully');
    } catch (e, stackTrace) {
      print('Error initializing Supabase: $e');
      print('Stack trace: $stackTrace');
      // Don't rethrow - allow app to continue
      // Database operations will fail gracefully later
    }
  }

  // User operations
  static Future<UserModel?> authenticateUser(String username, String password) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return null;
      }
      
      final response = await _client!
          .from(DatabaseConfig.usersTable)
          .select()
          .eq('username', username)
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromSupabaseMap(Map<String, dynamic>.from(response));
      }
      return null;
    } catch (e) {
      print('Error authenticating user: $e');
      return null;
    }
  }

  static Future<List<UserModel>> getTeachersByAuthority(String authorityId) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return [];
      }
      
      final response = await _client!
          .from(DatabaseConfig.usersTable)
          .select()
          .eq('authority_id', authorityId)
          .eq('role', 'teacher');

      return (response as List)
          .map((teacher) => UserModel.fromSupabaseMap(teacher as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching teachers: $e');
      return [];
    }
  }

  static Future<bool> createUser(UserModel user) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return false;
      }
      
      await _client!.from(DatabaseConfig.usersTable).insert(user.toMapForSupabase());
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // Grocery usage operations
  static Future<bool> addGroceryUsage(GroceryUsageModel usage) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return false;
      }
      
      await _client!
          .from(DatabaseConfig.groceryUsageTable)
          .insert(usage.toMapForSupabase());
      return true;
    } catch (e) {
      print('Error adding grocery usage: $e');
      return false;
    }
  }

  static Future<List<GroceryUsageModel>> getGroceryUsageByDateRange(
    String teacherId,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    try {
      // Format dates as YYYY-MM-DD for PostgreSQL date comparison
      final fromDateStr = fromDate.toIso8601String().split('T')[0];
      final toDateStr = toDate.toIso8601String().split('T')[0];
      
      if (_client == null) {
        print('Supabase not initialized');
        return [];
      }
      
      final response = await _client!
          .from(DatabaseConfig.groceryUsageTable)
          .select()
          .eq('teacher_id', teacherId)
          .gte('date', fromDateStr)
          .lte('date', toDateStr)
          .order('date', ascending: false);

      return (response as List)
          .map((item) => GroceryUsageModel.fromSupabaseMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching grocery usage: $e');
      return [];
    }
  }

  // Report operations
  static Future<bool> submitReport(ReportModel report) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return false;
      }
      
      // Start a transaction-like operation
      // First, insert the report
      final reportMap = report.toMapForSupabase();
      final reportResponse = await _client!
          .from(DatabaseConfig.reportsTable)
          .insert(reportMap)
          .select()
          .single();

      final reportId = reportResponse['id'] as String;

      // Then, insert report items
      final reportItems = report.groceryItems.map((item) {
        return {
          'report_id': reportId,
          'grocery_name': item.groceryName,
          'total_quantity': item.totalQuantity,
          'unit': item.unit,
        };
      }).toList();

      if (reportItems.isNotEmpty) {
        await _client!.from(DatabaseConfig.reportItemsTable).insert(reportItems);
      }

      return true;
    } catch (e) {
      print('Error submitting report: $e');
      return false;
    }
  }

  static Future<List<ReportModel>> getReportsByAuthority(String authorityId) async {
    try {
      // Get teachers under this authority
      final teachers = await getTeachersByAuthority(authorityId);
      final teacherIds = teachers.map((t) => t.id).toList();

      if (teacherIds.isEmpty) {
        return [];
      }

      if (_client == null) {
        print('Supabase not initialized');
        return [];
      }
      
      // Get reports from these teachers
      // Build OR filter for multiple teacher IDs
      var query = _client!
          .from(DatabaseConfig.reportsTable)
          .select();
      
      // Use OR filter for multiple teacher IDs
      if (teacherIds.length == 1) {
        query = query.eq('teacher_id', teacherIds[0]);
      } else {
        // Build OR condition: teacher_id=id1 OR teacher_id=id2 OR ...
        final orConditions = teacherIds
            .map((id) => 'teacher_id.eq.$id')
            .join(',');
        query = query.or(orConditions);
      }
      
      final response = await query.order('submitted_at', ascending: false);

      final reportsList = (response as List)
          .map((report) => ReportModel.fromSupabaseMap(report as Map<String, dynamic>))
          .toList();

      // Load report items for each report
      final reportsWithItems = <ReportModel>[];
      for (var report in reportsList) {
        final items = await getReportItems(report.id);
        reportsWithItems.add(ReportModel(
          id: report.id,
          teacherId: report.teacherId,
          teacherName: report.teacherName,
          fromDate: report.fromDate,
          toDate: report.toDate,
          groceryItems: items,
          submittedAt: report.submittedAt,
          status: report.status,
        ));
      }

      return reportsWithItems;
    } catch (e) {
      print('Error fetching reports: $e');
      return [];
    }
  }

  static Future<List<ReportModel>> getReportsByTeacher(String teacherId) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return [];
      }
      
      final response = await _client!
          .from(DatabaseConfig.reportsTable)
          .select()
          .eq('teacher_id', teacherId)
          .order('submitted_at', ascending: false);

      final reports = (response as List)
          .map((report) => ReportModel.fromSupabaseMap(report as Map<String, dynamic>))
          .toList();

      // Load report items for each report
      final reportsWithItems = <ReportModel>[];
      for (var report in reports) {
        final items = await getReportItems(report.id);
        reportsWithItems.add(ReportModel(
          id: report.id,
          teacherId: report.teacherId,
          teacherName: report.teacherName,
          fromDate: report.fromDate,
          toDate: report.toDate,
          groceryItems: items,
          submittedAt: report.submittedAt,
          status: report.status,
        ));
      }

      return reportsWithItems;
    } catch (e) {
      print('Error fetching teacher reports: $e');
      return [];
    }
  }

  static Future<List<GroceryReportItem>> getReportItems(String reportId) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return [];
      }
      
      final response = await _client!
          .from(DatabaseConfig.reportItemsTable)
          .select()
          .eq('report_id', reportId);

      return (response as List)
          .map((item) => GroceryReportItem.fromSupabaseMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching report items: $e');
      return [];
    }
  }

  static Future<bool> updateReportStatus(String reportId, String status) async {
    try {
      if (_client == null) {
        print('Supabase not initialized');
        return false;
      }
      
      await _client!
          .from(DatabaseConfig.reportsTable)
          .update({'status': status})
          .eq('id', reportId);
      return true;
    } catch (e) {
      print('Error updating report status: $e');
      return false;
    }
  }
}

