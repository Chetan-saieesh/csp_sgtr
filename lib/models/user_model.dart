class UserModel {
  final String id;
  final String username;
  final String password;
  final String role; // 'teacher' or 'authority'
  final String? authorityId; // For teachers, links to authority
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.authorityId,
    required this.name,
    required this.email,
  });

  // For MongoDB (camelCase with _id)
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'password': password,
      'role': role,
      'authorityId': authorityId,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    // Support both MongoDB and Supabase formats
    if (map.containsKey('id') && !map.containsKey('_id')) {
      return UserModel.fromSupabaseMap(map);
    }
    return UserModel(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      authorityId: map['authorityId']?.toString() ?? map['authority_id']?.toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // For Supabase (snake_case with id)
  Map<String, dynamic> toMapForSupabase() {
    return {
      if (id.isNotEmpty) 'id': id,
      'username': username,
      'password': password,
      'role': role,
      'authority_id': authorityId,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromSupabaseMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      authorityId: map['authority_id']?.toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

