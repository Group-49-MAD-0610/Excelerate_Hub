#  Contributing to Excelerate Hub

We love your input! We want to make contributing to Excelerate Hub as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.16.0
- Dart SDK ≥ 3.2.0
- Git
- GitHub account
- Code editor (VS Code/Android Studio)

### Development Setup

1. **Fork the repository**
   - Go to [Excelerate Hub](https://github.com/vashirij/Excelerate_Hub)
   - Click the "Fork" button

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Excelerate_Hub.git
   cd Excelerate_Hub
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/vashirij/Excelerate_Hub.git
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Verify setup**
   ```bash
   flutter doctor
   flutter test
   ```

## How to Contribute

### 1. **Create an Issue**
Before starting work, create an issue to discuss:
- Bug reports
- Feature requests
- Code improvements
- Documentation updates

### 2. **Branch Naming Convention**
```bash
# Feature branches
feature/user-authentication
feature/program-listing
feature/feedback-system

# Bug fixes
bugfix/login-validation
bugfix/api-timeout

# Documentation
docs/readme-update
docs/api-documentation

# Refactoring
refactor/controller-optimization
refactor/widget-structure
```

### 3. **Development Workflow**

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes**
   - Follow [Coding Standards](docs/CODING_STANDARDS.md)
   - Write tests for new features
   - Update documentation

3. **Test your changes**
   ```bash
   # Run all tests
   flutter test
   
   # Run specific tests
   flutter test test/unit/
   flutter test test/widget/
   
   # Check code formatting
   flutter analyze
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add user authentication system"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Go to your fork on GitHub
   - Click "Compare & pull request"
   - Fill out the PR template

## Coding Standards

### **Code Style**
- Follow [Coding Standards](CODING_STANDARDS.md)
- Use MVC architecture pattern
- Follow Flutter/Dart naming conventions
- Use meaningful variable and function names
- Add comments for complex logic

### **Testing Requirements**
- Write unit tests for business logic
- Write widget tests for UI components
- Maintain minimum 80% code coverage
- All tests must pass before PR approval

### **Documentation**
- Update README if needed
- Add inline comments for complex code
- Update API documentation
- Include code examples

## 🔍 Pull Request Process

### **PR Requirements**
- [ ] Follows coding standards
- [ ] Includes appropriate tests
- [ ] Documentation updated
- [ ] All tests pass
- [ ] No merge conflicts
- [ ] Descriptive commit messages

### **PR Template**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

### **Review Process**
1. **Automated Checks**: CI/CD pipeline runs tests
2. **Code Review**: Maintainers review changes
3. **Feedback**: Address review comments
4. **Approval**: Get approval from maintainer
5. **Merge**: Changes merged to main branch

## Bug Reports

### **Before Submitting**
- Check existing issues
- Update to latest version
- Test on multiple devices/platforms

### **Bug Report Template**
```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What should happen

**Screenshots**
Add screenshots if applicable

**Environment:**
- Device: [e.g. iPhone 12, Pixel 5]
- OS: [e.g. iOS 15, Android 12]
- Flutter version: [e.g. 3.16.0]
- App version: [e.g. 1.0.0]
```

##  Feature Requests

### **Feature Request Template**
```markdown
**Feature Description**
Clear description of the feature

**Use Case**
Why is this feature needed?

**Proposed Solution**
How should this be implemented?

**Alternatives**
Alternative solutions considered

**Additional Context**
Screenshots, mockups, or examples
```

## Commit Message Guidelines

### **Format**
```
type(scope): brief description

Longer description if needed

Fixes #issue-number
```

### **Types**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting changes
- `refactor`: Code restructuring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### **Examples**
```bash
feat(auth): add user login functionality
fix(api): resolve timeout issue in program fetch
docs(readme): update installation instructions
style(views): format login screen code
refactor(controllers): optimize state management
test(unit): add tests for program repository
```

## Development Guidelines

### **MVC Architecture**
- **Models**: Data handling and business logic
- **Views**: UI components and screens
- **Controllers**: State management and user interactions

### **State Management**
- Use Provider with ChangeNotifier
- Controllers handle business logic
- Views only contain UI code
- Proper disposal of resources

### **Error Handling**
- Use try-catch blocks appropriately
- Provide user-friendly error messages
- Log errors for debugging
- Handle edge cases

### **Performance**
- Use const constructors
- Optimize widget rebuilds
- Implement lazy loading
- Dispose controllers properly

## 🚫 What Not to Do

- Don't push directly to main branch
- Don't commit large files or binaries
- Don't include personal API keys
- Don't ignore test failures
- Don't submit PRs without description
- Don't include unrelated changes

## Recognition

Moderators will be:
- Added to README moderators section
- Mentioned in release notes
- Credited in app about section
- Featured on project documentation

##  Getting Help

-  **GitHub Discussions**: For questions and general discussion
-  **GitHub Issues**: For bug reports and feature requests
- **Email**: [grinefalcon2@gmail.com](mailto:grinefalcon2@gmail.com)
-  **Documentation**: Check existing docs first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## Thank You

Thank you for contributing to Excelerate Hub! Your efforts help make this project better for everyone.

**Happy Coding!**
