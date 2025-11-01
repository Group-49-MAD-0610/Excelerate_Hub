import 'package:flutter/foundation.dart';

/// Base controller class with common functionality
abstract class BaseController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  /// Current loading state
  bool get isLoading => _isLoading;

  /// Current error message
  String? get error => _error;

  /// Check if controller is disposed
  bool get isDisposed => _disposed;

  /// Set loading state
  void setLoading(bool loading) {
    if (_disposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void setError(String? error) {
    if (_disposed) return;
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    if (_disposed) return;
    _error = null;
    notifyListeners();
  }

  /// Handle async operations with loading and error states
  Future<T?> handleAsync<T>(Future<T> Function() operation) async {
    try {
      setLoading(true);
      clearError();
      final result = await operation();
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Safe notify listeners (checks if disposed)
  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
