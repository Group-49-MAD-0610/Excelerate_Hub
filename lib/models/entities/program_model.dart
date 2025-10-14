/// Program model representing an educational program
class ProgramModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final String level;
  final String instructorId;
  final String instructorName;
  final String? instructorAvatar;
  final String? imageUrl;
  final List<String> requirements;
  final List<String> outcomes;
  final List<CurriculumWeek> curriculum;
  final int enrollmentCount;
  final double rating;
  final int reviewCount;
  final double? progress;
  final bool isEnrolled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final double? price;
  final bool isFree;
  final List<String> tags;

  const ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.level,
    required this.instructorId,
    required this.instructorName,
    this.instructorAvatar,
    this.imageUrl,
    this.requirements = const [],
    this.outcomes = const [],
    this.curriculum = const [],
    this.enrollmentCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.progress,
    this.isEnrolled = false,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.price,
    this.isFree = true,
    this.tags = const [],
  });

  /// Create ProgramModel from JSON
  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      duration: json['duration'] as String,
      level: json['level'] as String,
      instructorId:
          json['instructorId'] as String? ??
          json['instructor']?['id'] as String? ??
          '',
      instructorName:
          json['instructorName'] as String? ??
          json['instructor']?['name'] as String? ??
          'Unknown',
      instructorAvatar:
          json['instructorAvatar'] as String? ??
          json['instructor']?['avatar'] as String?,
      imageUrl: json['imageUrl'] as String?,
      requirements:
          (json['requirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      outcomes:
          (json['outcomes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      curriculum:
          (json['curriculum'] as List<dynamic>?)
              ?.map((e) => CurriculumWeek.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      enrollmentCount: json['enrollmentCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      progress: (json['progress'] as num?)?.toDouble(),
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      price: (json['price'] as num?)?.toDouble(),
      isFree:
          json['isFree'] as bool? ??
          (json['price'] == null || json['price'] == 0),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );
  }

  /// Convert ProgramModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'level': level,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'instructorAvatar': instructorAvatar,
      'imageUrl': imageUrl,
      'requirements': requirements,
      'outcomes': outcomes,
      'curriculum': curriculum.map((week) => week.toJson()).toList(),
      'enrollmentCount': enrollmentCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'progress': progress,
      'isEnrolled': isEnrolled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'price': price,
      'isFree': isFree,
      'tags': tags,
    };
  }

  /// Create a copy of ProgramModel with updated fields
  ProgramModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? duration,
    String? level,
    String? instructorId,
    String? instructorName,
    String? instructorAvatar,
    String? imageUrl,
    List<String>? requirements,
    List<String>? outcomes,
    List<CurriculumWeek>? curriculum,
    int? enrollmentCount,
    double? rating,
    int? reviewCount,
    double? progress,
    bool? isEnrolled,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    double? price,
    bool? isFree,
    List<String>? tags,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
      imageUrl: imageUrl ?? this.imageUrl,
      requirements: requirements ?? this.requirements,
      outcomes: outcomes ?? this.outcomes,
      curriculum: curriculum ?? this.curriculum,
      enrollmentCount: enrollmentCount ?? this.enrollmentCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      progress: progress ?? this.progress,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      tags: tags ?? this.tags,
    );
  }

  /// Get difficulty level color
  String get levelColor {
    switch (level.toLowerCase()) {
      case 'beginner':
        return '#00C896'; // Success green
      case 'intermediate':
        return '#FFAB00'; // Warning orange
      case 'advanced':
        return '#FF5757'; // Error red
      default:
        return '#6C5CE7'; // Primary purple
    }
  }

  /// Get category icon
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'mobile':
      case 'app development':
        return 'smartphone';
      case 'web':
      case 'web development':
        return 'web';
      case 'design':
      case 'ui/ux':
        return 'palette';
      case 'data':
      case 'data science':
        return 'analytics';
      case 'business':
        return 'business_center';
      default:
        return 'school';
    }
  }

  /// Check if program is completed
  bool get isCompleted => progress != null && progress! >= 100.0;

  /// Check if program is in progress
  bool get isInProgress =>
      progress != null && progress! > 0.0 && progress! < 100.0;

  /// Get formatted price
  String get formattedPrice {
    if (isFree) return 'Free';
    if (price != null) return '\$${price!.toStringAsFixed(2)}';
    return 'Free';
  }

  /// Get progress percentage as string
  String get progressPercentage {
    if (progress == null) return '0%';
    return '${progress!.toInt()}%';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProgramModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProgramModel(id: $id, title: $title, category: $category, level: $level)';
  }
}

/// Curriculum week model
class CurriculumWeek {
  final int week;
  final String title;
  final String description;
  final List<String> topics;
  final bool isCompleted;

  const CurriculumWeek({
    required this.week,
    required this.title,
    this.description = '',
    this.topics = const [],
    this.isCompleted = false,
  });

  /// Create CurriculumWeek from JSON
  factory CurriculumWeek.fromJson(Map<String, dynamic> json) {
    return CurriculumWeek(
      week: json['week'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      topics:
          (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Convert CurriculumWeek to JSON
  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'title': title,
      'description': description,
      'topics': topics,
      'isCompleted': isCompleted,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurriculumWeek && other.week == week;
  }

  @override
  int get hashCode => week.hashCode;

  @override
  String toString() {
    return 'CurriculumWeek(week: $week, title: $title)';
  }
}
