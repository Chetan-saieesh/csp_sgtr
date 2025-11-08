class GroceryReportItem {
  final String groceryName;
  final double totalQuantity;
  final String unit;

  GroceryReportItem({
    required this.groceryName,
    required this.totalQuantity,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'groceryName': groceryName,
      'totalQuantity': totalQuantity,
      'unit': unit,
    };
  }

  factory GroceryReportItem.fromMap(Map<String, dynamic> map) {
    // Support both MongoDB and Supabase formats
    if (map.containsKey('grocery_name') && !map.containsKey('groceryName')) {
      return GroceryReportItem.fromSupabaseMap(map);
    }
    return GroceryReportItem(
      groceryName: map['groceryName'] ?? map['grocery_name'] ?? '',
      totalQuantity: (map['totalQuantity'] ?? map['total_quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
    );
  }

  // For Supabase (snake_case)
  Map<String, dynamic> toMapForSupabase() {
    return {
      'grocery_name': groceryName,
      'total_quantity': totalQuantity,
      'unit': unit,
    };
  }

  factory GroceryReportItem.fromSupabaseMap(Map<String, dynamic> map) {
    return GroceryReportItem(
      groceryName: map['grocery_name'] ?? '',
      totalQuantity: (map['total_quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
    );
  }
}

class ReportModel {
  final String id;
  final String teacherId;
  final String teacherName;
  final DateTime fromDate;
  final DateTime toDate;
  final List<GroceryReportItem> groceryItems;
  final DateTime submittedAt;
  final String status; // 'submitted', 'viewed'

  ReportModel({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.fromDate,
    required this.toDate,
    required this.groceryItems,
    required this.submittedAt,
    this.status = 'submitted',
  });

  // For MongoDB (camelCase with _id)
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'groceryItems': groceryItems.map((item) => item.toMap()).toList(),
      'submittedAt': submittedAt.toIso8601String(),
      'status': status,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    // Support both MongoDB and Supabase formats
    if (map.containsKey('id') && !map.containsKey('_id')) {
      return ReportModel.fromSupabaseMap(map);
    }
    return ReportModel(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      teacherId: map['teacherId']?.toString() ?? map['teacher_id']?.toString() ?? '',
      teacherName: map['teacherName'] ?? map['teacher_name'] ?? '',
      fromDate: map['fromDate'] is String 
          ? DateTime.parse(map['fromDate']) 
          : DateTime.parse(map['from_date'].toString()),
      toDate: map['toDate'] is String 
          ? DateTime.parse(map['toDate']) 
          : DateTime.parse(map['to_date'].toString()),
      groceryItems: (map['groceryItems'] as List<dynamic>?)
              ?.map((item) => GroceryReportItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      submittedAt: map['submittedAt'] is String 
          ? DateTime.parse(map['submittedAt']) 
          : DateTime.parse(map['submitted_at'].toString()),
      status: map['status'] ?? 'submitted',
    );
  }

  // For Supabase (snake_case with id)
  // Note: groceryItems are stored in a separate table (report_items)
  Map<String, dynamic> toMapForSupabase() {
    return {
      if (id.isNotEmpty) 'id': id,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'from_date': fromDate.toIso8601String().split('T')[0], // Date only
      'to_date': toDate.toIso8601String().split('T')[0], // Date only
      'status': status,
      'submitted_at': submittedAt.toIso8601String(),
    };
  }

  factory ReportModel.fromSupabaseMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id']?.toString() ?? '',
      teacherId: map['teacher_id']?.toString() ?? '',
      teacherName: map['teacher_name'] ?? '',
      fromDate: map['from_date'] is String 
          ? DateTime.parse(map['from_date']) 
          : DateTime.parse(map['from_date'].toString()),
      toDate: map['to_date'] is String 
          ? DateTime.parse(map['to_date']) 
          : DateTime.parse(map['to_date'].toString()),
      groceryItems: [], // Will be loaded separately from report_items table
      submittedAt: map['submitted_at'] is String 
          ? DateTime.parse(map['submitted_at']) 
          : DateTime.parse(map['submitted_at'].toString()),
      status: map['status'] ?? 'submitted',
    );
  }
}

