# Quick Start Guide: Login & Feedback Features

## Login Feature

### How to Test Login
1. **Start the app** - Opens at login screen by default
2. **Use test credentials** from `assets/data/users.json`:
   ```
   Email: sarah.j@example.com
   Password: password123
   ```
3. **Try invalid credentials** to see error handling:
   - Wrong email → "Invalid email or password"
   - Wrong password → "Invalid email or password"
   - Invalid email format → "Please enter a valid email address"
   - Empty fields → "Email is required" / "Password is required"

### Login Flow
```
LoginScreen 
  → User enters email/password
  → AuthController.login() validates and authenticates
  → AuthService checks against users.json
  → Success: Navigate to HomeScreen
  → Failure: Display error message
```

### Test User Accounts
From `assets/data/users.json`:
- **Email**: sarah.j@example.com
- **Password**: password123
- **Role**: student

## Feedback Feature

### How to Submit Feedback
1. **Login first** (feedback requires authentication)
2. **Navigate to a program** (from home or programs list)
3. **Click "Write a Review"** or feedback button
4. **Select rating** (1-5 stars, required)
5. **Select category** (optional):
   - Course Content
   - Instructor Quality
   - Learning Materials
   - Platform Usability
   - Technical Issues
   - Suggestions
   - Other
6. **Write feedback** (minimum 20 characters, required)
7. **Submit** - Shows confirmation dialog and success message

### Feedback Flow
```
FeedbackScreen
  → User fills form (rating + comment)
  → Validates inputs (rating selected, comment >= 20 chars)
  → Gets current user from AuthController
  → FeedbackController.submitFeedback()
  → FeedbackRepository.createFeedback()
  → Saves to in-memory cache + SharedPreferences
  → Success: Shows dialog → Navigate back
  → Failure: Display error message
```

### Validation Rules
- **Rating**: Required, must be 1-5 stars
- **Comment**: Required, minimum 20 characters, maximum 500 characters
- **Authentication**: Must be logged in to submit

## Code Usage Examples

### Using AuthController

```dart
// In any widget with Provider access
final authController = Provider.of<AuthController>(context, listen: false);

// Login
final success = await authController.login(
  email: 'sarah.j@example.com',
  password: 'password123',
);

// Check if logged in
if (authController.isAuthenticated) {
  final user = authController.currentUser;
  print('Logged in as: ${user?.name}');
}

// Logout
await authController.logout();
```

### Using FeedbackController

```dart
// In any widget with Provider access
final feedbackController = Provider.of<FeedbackController>(
  context, 
  listen: false,
);

// Submit feedback
final success = await feedbackController.submitFeedback(
  userId: currentUser.id,
  userName: currentUser.name,
  userAvatar: currentUser.avatar,
  programId: 'prog-001',
  programTitle: 'Machine Learning Fundamentals',
  rating: 5,
  comment: 'Great course! Very informative and well structured.',
);

// Load program feedback
await feedbackController.loadProgramFeedback('prog-001');
final programFeedback = feedbackController.programFeedback;
final averageRating = feedbackController.averageRating;

// Load user's feedback
await feedbackController.loadUserFeedback(currentUser.id);
final myFeedback = feedbackController.feedbackList;
```

### Consumer Pattern for Reactive UI

```dart
// Login screen example
Consumer<AuthController>(
  builder: (context, authController, child) {
    return CustomButton(
      text: authController.isLoading ? 'Signing In...' : 'Sign In',
      onPressed: authController.isLoading 
        ? null 
        : () => _handleLogin(context, authController),
    );
  },
)

// Show error messages
if (authController.error != null) {
  Container(
    child: Text(authController.error!),
    // ... styling
  )
}
```

## Data Files

### users.json
Location: `assets/data/users.json`

Sample structure:
```json
{
  "id": "user-001",
  "name": "Sarah",
  "email": "sarah.j@example.com",
  "password": "password123",
  "avatar": "https://i.pravatar.cc/150?u=sarah",
  "role": "student",
  "isActive": true,
  "enrolledPrograms": [],
  "createdAt": "2024-10-01T12:00:00Z",
  "updatedAt": "2024-10-25T15:30:00Z"
}
```

### feedback.json
Location: `assets/data/feedback.json`

Sample structure:
```json
{
  "id": "feedback-001",
  "userId": "user-001",
  "userName": "Sarah",
  "userAvatar": "https://i.pravatar.cc/150?u=sarah",
  "programId": "prog-001",
  "programTitle": "Machine Learning Fundamentals",
  "rating": 5,
  "comment": "This course is absolutely fantastic!...",
  "createdAt": "2024-10-20T14:30:00Z",
  "updatedAt": "2024-10-20T14:30:00Z",
  "isActive": true,
  "helpfulUsers": ["user-002", "user-003"],
  "helpfulCount": 2
}
```

## Error Handling

### Login Errors
- Email not found → "Invalid email or password"
- Wrong password → "Invalid email or password"
- Invalid email format → "Please enter a valid email address"
- Empty email → "Email is required"
- Empty password → "Password is required"

### Feedback Errors
- Not logged in → "Please login to submit feedback"
- No rating selected → "Please select a rating"
- Rating out of range → "Rating must be between 1 and 5"
- Comment too short → "Comment must be at least 20 characters"
- Empty comment → "Comment cannot be empty"

## State Management

All controllers extend `BaseController` which provides:
- `isLoading` - Boolean flag for loading state
- `error` - String message for errors
- `setLoading(bool)` - Set loading state
- `setError(String)` - Set error message
- `clearError()` - Clear error message
- `handleAsync<T>()` - Helper for async operations

## Persistence

### AuthController
- Current user stored in AuthService (in-memory)
- Session validation available
- No persistent login (prototype limitation)

### FeedbackController
- Feedback stored in FeedbackRepository
- In-memory cache for fast access
- Persisted to SharedPreferences
- Survives app restarts
- Initial data from `assets/data/feedback.json`

## Testing Checklist

### Login Feature
- [ ] Login with valid credentials works
- [ ] Login with invalid email shows error
- [ ] Login with invalid password shows error
- [ ] Empty fields show validation errors
- [ ] Invalid email format shows error
- [ ] Success navigates to home screen
- [ ] Loading state shows during authentication
- [ ] Error messages clear on new attempt

### Feedback Feature
- [ ] Can't submit without login
- [ ] Rating is required
- [ ] Comment minimum length enforced
- [ ] Comment maximum length enforced
- [ ] Category selection works (optional)
- [ ] Success dialog shows after submission
- [ ] Success message appears
- [ ] Navigates back after submission
- [ ] Error messages show for validation failures
- [ ] Feedback stored in repository

## Troubleshooting

### "User not found" error
- Check `assets/data/users.json` exists
- Verify email is correct (case-insensitive)
- Ensure password matches exactly

### Feedback not submitting
- Verify user is logged in first
- Check rating is selected (1-5)
- Ensure comment is at least 20 characters
- Check console for detailed error messages

### UI not updating
- Ensure widget uses `Consumer<Controller>` or `Provider.of`
- Check `listen: false` is only used in event handlers
- Verify `notifyListeners()` is called in controller

## Additional Resources

- **Implementation Summary**: See `IMPLEMENTATION_SUMMARY.md` for detailed technical documentation
- **Architecture Patterns**: Review controller and repository patterns used
- **Code Examples**: Check existing controllers for reference implementations
