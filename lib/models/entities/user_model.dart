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
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'student',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      enrolledPrograms:
          (json['enrolledPrograms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'phoneNumber': phoneNumber,
      'bio': bio,
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
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Get display name
  String get displayName {
    return name.isNotEmpty ? name : email.split('@')[0];
  }

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
