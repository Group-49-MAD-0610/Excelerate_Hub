# 🚀 Deployment Guide

This guide covers deploying Excelerate Hub to various platforms.

## 📋 Table of Contents
- [Prerequisites](#prerequisites)
- [Android Deployment](#android-deployment)
- [iOS Deployment](#ios-deployment)
- [Web Deployment](#web-deployment)
- [Desktop Deployment](#desktop-deployment)
- [CI/CD Pipeline](#cicd-pipeline)

## 🔧 Prerequisites

### **Development Environment**
- Flutter SDK ≥ 3.16.0
- Dart SDK ≥ 3.2.0
- Git
- Platform-specific tools (see below)

### **Build Requirements**
- Valid signing certificates
- Environment variables configured
- API keys and secrets

## 📱 Android Deployment

### **Setup Android Signing**

1. **Generate keystore:**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Create key.properties:**
   ```properties
   # android/key.properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=upload
   storeFile=/path/to/upload-keystore.jks
   ```

3. **Configure build.gradle:**
   ```gradle
   // android/app/build.gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

### **Build Commands**

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release

# Split APKs by ABI
flutter build apk --split-per-abi
```

### **Google Play Store Deployment**

1. **Upload to Play Console:**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app or select existing
   - Upload APK/AAB file

2. **Release Management:**
   - Internal testing → Alpha → Beta → Production
   - Configure release notes
   - Set rollout percentage

## 🍎 iOS Deployment

### **Setup iOS Signing**

1. **Apple Developer Account:**
   - Enroll in Apple Developer Program
   - Create App ID
   - Generate certificates and provisioning profiles

2. **Xcode Configuration:**
   ```bash
   # Open iOS project in Xcode
   open ios/Runner.xcworkspace
   ```
   - Configure signing in Xcode
   - Set bundle identifier
   - Configure capabilities

### **Build Commands**

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release

# Create IPA for distribution
flutter build ipa --release
```

### **App Store Deployment**

1. **Upload to App Store Connect:**
   ```bash
   # Using Xcode
   # Product → Archive → Distribute App

   # Using command line
   xcrun altool --upload-app -f build/ios/ipa/*.ipa -u "your@email.com" -p "app-specific-password"
   ```

2. **TestFlight & App Store:**
   - Configure app metadata
   - Upload screenshots
   - Submit for review

## 🌐 Web Deployment

### **Build for Web**

```bash
# Debug build
flutter build web --debug

# Release build
flutter build web --release

# With specific renderer
flutter build web --web-renderer canvaskit
flutter build web --web-renderer html
```

### **Deployment Options**

#### **1. GitHub Pages**
```yaml
# .github/workflows/deploy-web.yml
name: Deploy to GitHub Pages
on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build web --release
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

#### **2. Netlify**
```bash
# Build command
flutter build web --release

# Publish directory
build/web
```

#### **3. Firebase Hosting**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting

# Deploy
flutter build web --release
firebase deploy
```

## 🖥️ Desktop Deployment

### **Windows**

```bash
# Build Windows app
flutter build windows --release

# Create installer (using Inno Setup)
# Configure installer script and build
```

### **macOS**

```bash
# Build macOS app
flutter build macos --release

# Code signing
codesign --deep --force --verify --verbose --sign "Developer ID Application: Your Name" build/macos/Build/Products/Release/ExcelerateHub.app

# Create DMG
hdiutil create -volname "Excelerate Hub" -srcfolder build/macos/Build/Products/Release/ExcelerateHub.app -ov -format UDZO ExcelerateHub.dmg
```

### **Linux**

```bash
# Build Linux app
flutter build linux --release

# Create AppImage or Snap package
# Configure packaging scripts
```

## 🔄 CI/CD Pipeline

### **GitHub Actions Workflow**

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Analyze code
        run: flutter analyze
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      
      - name: Build iOS
        run: flutter build ios --release --no-codesign
      
      - name: Upload iOS build
        uses: actions/upload-artifact@v3
        with:
          name: ios-build
          path: build/ios/iphoneos/

  deploy-web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      
      - name: Build Web
        run: flutter build web --release
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

## 🔐 Environment Configuration

### **Environment Variables**

```yaml
# .env
API_BASE_URL=https://api.excelerate-hub.com
ENVIRONMENT=production
SENTRY_DSN=your_sentry_dsn
ANALYTICS_KEY=your_analytics_key
```

### **Flutter Configuration**

```dart
// lib/core/config/environment.dart
class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
  
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
}
```

## 📊 Monitoring & Analytics

### **Crash Reporting**

```dart
// Setup Sentry
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'your_sentry_dsn';
    },
    appRunner: () => runApp(MyApp()),
  );
}
```

### **Analytics**

```dart
// Setup Firebase Analytics
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  static Future<void> logEvent(String name, Map<String, dynamic> parameters) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }
}
```

## 🚀 Deployment Checklist

### **Pre-deployment**
- [ ] All tests pass
- [ ] Code coverage meets requirements
- [ ] Security vulnerabilities addressed
- [ ] Performance benchmarks met
- [ ] Documentation updated

### **Platform-specific**
- [ ] App icons configured
- [ ] Splash screens configured
- [ ] App metadata updated
- [ ] Store listings prepared
- [ ] Screenshots generated

### **Post-deployment**
- [ ] Monitor crash reports
- [ ] Check analytics data
- [ ] Verify app functionality
- [ ] Update version tags
- [ ] Notify stakeholders

## 🆘 Troubleshooting

### **Common Issues**

1. **Build Failures:**
   - Check Flutter/Dart versions
   - Clear build cache: `flutter clean`
   - Update dependencies: `flutter pub upgrade`

2. **Signing Issues:**
   - Verify certificates validity
   - Check provisioning profiles
   - Ensure bundle IDs match

3. **Performance Issues:**
   - Enable release mode optimizations
   - Remove debug code
   - Optimize images and assets

### **Getting Help**
- 📚 [Flutter Documentation](https://docs.flutter.dev/)
- 💬 [GitHub Discussions](https://github.com/vashirij/Excelerate_Hub/discussions)
- 📧 [Support Email](mailto:jvashiri@grinefalcon.com)

---

**Last Updated:** October 13, 2025  
**Maintained by:** James Vashiri
