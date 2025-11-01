/// User model representing a user in the application
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? phoneNumber;
  final String? bio;
  final List<String> enrolledPrograms;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.phoneNumber,
    this.bio,
    this.enrolledPrograms = const [],
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(dynamic value) {
      if (value == null) return DateTime.now().toUtc();
      if (value is String) {
        try {
          return DateTime.parse(value).toUtc();
        } catch (_) {
          return DateTime.now().toUtc();
        }
      }
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
      }
      return DateTime.now().toUtc();
    }

    List<String> _parseEnrolled(dynamic v) {
      if (v is List) {
        return v.where((e) => e != null).map((e) => e.toString()).toList();
      }
      return const [];
    }

    return UserModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      role: (json['role'] ?? 'student').toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      isActive: json.containsKey('isActive')
          ? (json['isActive'] == true || json['isActive'] == 1)
          : true,
      phoneNumber: json['phoneNumber']?.toString(),
      bio: json['bio']?.toString(),
      enrolledPrograms: _parseEnrolled(json['enrolledPrograms']),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (avatar != null) 'avatar': avatar,
      'role': role,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'isActive': isActive,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (bio != null) 'bio': bio,
      'enrolledPrograms': enrolledPrograms,
    };
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? phoneNumber,
    String? bio,
    List<String>? enrolledPrograms,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      enrolledPrograms: enrolledPrograms ?? this.enrolledPrograms,
    );
  }

  /// Check if user is admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  /// Check if user is moderator
  bool get isModerator => role.toLowerCase() == 'moderator';

  /// Check if user is student
  bool get isStudent => role.toLowerCase() == 'student';

  /// Get user initials
  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      final parts = email.split('@');
      final local = parts.isNotEmpty ? parts.first : '';
      return local.isEmpty ? '' : local[0].toUpperCase();
    }
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  /// Get display name
  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role)';
  }
}
