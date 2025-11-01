/// Feedback model representing user feedback for programs
class FeedbackModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String programId;
  final String programTitle;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final List<String> helpfulUsers;
  final int helpfulCount;

  const FeedbackModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.programId,
    required this.programTitle,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.helpfulUsers = const [],
    this.helpfulCount = 0,
  });

  /// Create FeedbackModel from JSON
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      programId: json['programId'] as String,
      programTitle: json['programTitle'] as String? ?? '',
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      helpfulUsers:
          (json['helpfulUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      helpfulCount: json['helpfulCount'] as int? ?? 0,
    );
  }

  /// Convert FeedbackModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'programId': programId,
      'programTitle': programTitle,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'helpfulUsers': helpfulUsers,
      'helpfulCount': helpfulCount,
    };
  }

  /// Create a copy of FeedbackModel with updated fields
  FeedbackModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? programId,
    String? programTitle,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    List<String>? helpfulUsers,
    int? helpfulCount,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      programId: programId ?? this.programId,
      programTitle: programTitle ?? this.programTitle,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      helpfulUsers: helpfulUsers ?? this.helpfulUsers,
      helpfulCount: helpfulCount ?? this.helpfulCount,
    );
  }

  /// Get user initials
  String get userInitials {
    final words = userName.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if feedback was updated
  bool get isEdited {
    return updatedAt.isAfter(createdAt.add(const Duration(minutes: 1)));
  }

  /// Get rating stars as string
  String get ratingStars {
    return '★' * rating + '☆' * (5 - rating);
  }

  /// Check if rating is positive (4-5 stars)
  bool get isPositive => rating >= 4;

  /// Check if rating is neutral (3 stars)
  bool get isNeutral => rating == 3;

  /// Check if rating is negative (1-2 stars)
  bool get isNegative => rating <= 2;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FeedbackModel(id: $id, userId: $userId, programId: $programId, rating: $rating)';
  }
}

/// Feedback statistics model
class FeedbackStats {
  final double averageRating;
  final int totalFeedback;
  final Map<int, int> ratingDistribution;

  const FeedbackStats({
    required this.averageRating,
    required this.totalFeedback,
    required this.ratingDistribution,
  });

  /// Create FeedbackStats from JSON
  factory FeedbackStats.fromJson(Map<String, dynamic> json) {
    return FeedbackStats(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalFeedback: json['totalFeedback'] as int,
      ratingDistribution: Map<int, int>.from(
        json['ratingDistribution'] as Map<String, dynamic>,
      ),
    );
  }

  /// Convert FeedbackStats to JSON
  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalFeedback': totalFeedback,
      'ratingDistribution': ratingDistribution,
    };
  }

  /// Get percentage for specific rating
  double getPercentageForRating(int rating) {
    if (totalFeedback == 0) return 0.0;
    final count = ratingDistribution[rating] ?? 0;
    return (count / totalFeedback) * 100;
  }

  /// Get count for specific rating
  int getCountForRating(int rating) {
    return ratingDistribution[rating] ?? 0;
  }

  @override
  String toString() {
    return 'FeedbackStats(averageRating: $averageRating, totalFeedback: $totalFeedback)';
  }
}
