/// Useful extensions for Flutter development
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(
      ' ',
    ).map((word) => word.isNotEmpty ? word.capitalize : word).join(' ');
  }

  /// Check if string is valid email
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Check if string is valid URL
  bool get isValidUrl {
    return RegExp(r'^https?:\/\/[^\s]+$').hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, [String ellipsis = '...']) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Get initials from name
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ');
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }
}

extension ListExtensions<T> on List<T> {
  /// Get element at index or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// Check if list is null or empty
  bool get isNullOrEmpty {
    return isEmpty;
  }

  /// Check if list is not null and not empty
  bool get isNotNullOrEmpty {
    return isNotEmpty;
  }

  /// Add item if condition is true
  void addIf(bool condition, T item) {
    if (condition) {
      add(item);
    }
  }

  /// Add all items if condition is true
  void addAllIf(bool condition, Iterable<T> items) {
    if (condition) {
      addAll(items);
    }
  }
}

extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Format as time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

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
}

extension DoubleExtensions on double {
  /// Format as percentage
  String toPercentage([int decimals = 1]) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Format as currency
  String toCurrency([String symbol = '\$']) {
    return '$symbol${toStringAsFixed(2)}';
  }
}

extension IntExtensions on int {
  /// Format as file size
  String get fileSize {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${units[unitIndex]}';
  }

  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;
}
