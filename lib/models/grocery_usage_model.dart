class GroceryUsageModel {
  final String id;
  final String teacherId;
  final DateTime date;
  final String groceryName;
  final double quantity;
  final String unit; // e.g., 'kg', 'liters', 'pieces'

  GroceryUsageModel({
    required this.id,
    required this.teacherId,
    required this.date,
    required this.groceryName,
    required this.quantity,
    this.unit = 'kg',
  });

  // For MongoDB (camelCase with _id)
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'teacherId': teacherId,
      'date': date.toIso8601String(),
      'groceryName': groceryName,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory GroceryUsageModel.fromMap(Map<String, dynamic> map) {
    // Support both MongoDB and Supabase formats
    if (map.containsKey('id') && !map.containsKey('_id')) {
      return GroceryUsageModel.fromSupabaseMap(map);
    }
    return GroceryUsageModel(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      teacherId: map['teacherId']?.toString() ?? map['teacher_id']?.toString() ?? '',
      date: map['date'] is String 
          ? DateTime.parse(map['date']) 
          : DateTime.parse(map['date'].toString()),
      groceryName: map['groceryName'] ?? map['grocery_name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
    );
  }

  // For Supabase (snake_case with id)
  Map<String, dynamic> toMapForSupabase() {
    return {
      if (id.isNotEmpty) 'id': id,
      'teacher_id': teacherId,
      'date': date.toIso8601String().split('T')[0], // Date only (YYYY-MM-DD)
      'grocery_name': groceryName,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory GroceryUsageModel.fromSupabaseMap(Map<String, dynamic> map) {
    return GroceryUsageModel(
      id: map['id']?.toString() ?? '',
      teacherId: map['teacher_id']?.toString() ?? '',
      date: map['date'] is String 
          ? DateTime.parse(map['date']) 
          : DateTime.parse(map['date'].toString()),
      groceryName: map['grocery_name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
    );
  }
}

