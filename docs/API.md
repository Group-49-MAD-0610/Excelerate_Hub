# 🔌 API Documentation

This document describes the API endpoints used in the Excelerate Hub application.

## 📋 Table of Contents
- [Base URL](#base-url)
- [Error Handling](#error-handling)
- [Development & Testing](#development--testing)

## 🌐 Base URL

```
https://api.excelerate-hub.com/v1
```

## ❌ Error Handling

All API responses follow a consistent error format:

### **Error Response Structure**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed"
  },
  "timestamp": "2024-01-20T10:30:00Z"
}
```

## 🔧 Development & Testing

### **Mock API for Development**
When backend is not available, use mock responses:

```dart
class MockApiService implements ApiService {
  @override
  Future<List<Program>> getPrograms() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      Program(
        id: 'mock_1',
        title: 'Flutter Basics',
        description: 'Learn Flutter fundamentals',
        category: 'mobile',
      ),
    ];
  }
}
```

### **Testing API Calls**
```dart
group('API Service Tests', () {
  test('should fetch programs successfully', () async {
    // Arrange
    final mockDio = MockDio();
    final apiService = ApiService(dio: mockDio);
    
    when(mockDio.get('/programs')).thenAnswer(
      (_) async => Response(
        data: {'data': {'programs': [mockProgramJson]}},
        statusCode: 200,
      ),
    );
    
    // Act
    final programs = await apiService.getPrograms();
    
    // Assert
    expect(programs, isA<List<Program>>());
    expect(programs.length, 1);
  });
});
```

---

## 📞 Support

For API-related questions or issues:
- 📧 **Email**: [api-support@excelerate-hub.com](mailto:api-support@excelerate-hub.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/vashirij/Excelerate_Hub/issues)
- 📚 **Documentation**: Check this document first

---

**Last Updated:** October 13, 2025  
**API Version:** v1.0  
**Maintained by:** James Vashiri
