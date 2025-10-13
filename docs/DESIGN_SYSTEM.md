# 🎨 Design System

This document outlines the design system for Excelerate Hub, ensuring consistent UI/UX across the application.

## 📋 Table of Contents
- [Design Principles](#design-principles)
- [Color Palette](#color-palette)
- [Typography](#typography)
- [Components](#components)
- [Layout & Spacing](#layout--spacing)
- [Icons & Images](#icons--images)
- [Accessibility](#accessibility)

## 🎯 Design Principles

### **1. Clarity**
- Clear visual hierarchy
- Intuitive navigation
- Meaningful labels and instructions

### **2. Consistency**
- Uniform components across screens
- Consistent interaction patterns
- Standardized spacing and sizing

### **3. Accessibility**
- WCAG 2.1 AA compliance
- High contrast ratios
- Screen reader support
- Keyboard navigation

### **4. Responsiveness**
- Mobile-first design
- Adaptive layouts
- Touch-friendly interactions

## 🎨 Color Palette

### **Primary Colors (Excelerate Hub Brand)**
```dart
// lib/core/themes/app_colors.dart
class AppColors {
  // Primary Brand Colors - Educational Theme
  static const Color primary = Color(0xFF6C5CE7);      // Purple - Learning/Education
  static const Color primaryLight = Color(0xFF9B8CE8); // Light Purple
  static const Color primaryDark = Color(0xFF5A4FCF);  // Dark Purple
  
  // Secondary Colors - Growth & Progress
  static const Color secondary = Color(0xFF00D2D3);     // Teal - Growth
  static const Color secondaryLight = Color(0xFF4DDBDC); // Light Teal
  static const Color secondaryDark = Color(0xFF00A8A9);  // Dark Teal
  
  // Accent Colors
  static const Color accent = Color(0xFFFF6B6B);        // Coral - Engagement
  static const Color accentLight = Color(0xFFFF9F9F);   // Light Coral
}
```

### **Semantic Colors**
```dart
class AppColors {
  // Status Colors - Educational Context
  static const Color success = Color(0xFF00B894);    // Green - Completed/Success
  static const Color warning = Color(0xFFE17055);    // Orange - In Progress/Warning
  static const Color error = Color(0xFFD63031);      // Red - Error/Failed
  static const Color info = Color(0xFF74B9FF);       // Blue - Information
  
  // Neutral Colors - Clean Educational Interface
  static const Color background = Color(0xFFF8F9FA);  // Off-white background
  static const Color surface = Color(0xFFFFFFFF);     // Pure white cards/surfaces
  static const Color surfaceVariant = Color(0xFFF1F3F4); // Light gray variant
  static const Color onSurface = Color(0xFF1A1D29);   // Dark text
  static const Color onSurfaceVariant = Color(0xFF5F6368); // Secondary text
  static const Color onBackground = Color(0xFF2D3748); // Body text
  
  // Educational Specific Colors
  static const Color courseCard = Color(0xFFF7F8FC);  // Light purple background
  static const Color programBadge = Color(0xFFE8F4FD); // Light blue for badges
  static const Color feedbackHighlight = Color(0xFFFFF2E8); // Light orange for feedback
}
```

### **Color Usage Guidelines**

| Color | Usage | Example |
|-------|--------|---------|
| Primary (Purple) | Main navigation, primary CTAs, progress indicators | AppBar, primary buttons, active tab indicators |
| Secondary (Teal) | Progress states, achievements, secondary actions | Progress bars, achievement badges, secondary buttons |
| Accent (Coral) | Notifications, highlights, interactive elements | Notification dots, featured content, hover states |
| Success (Green) | Course completion, successful submissions | Completed lessons, successful form submissions |
| Warning (Orange) | In-progress states, important notices | Pending assignments, important announcements |
| Error (Red) | Validation errors, failed states | Form errors, failed submissions |
| Course Card | Background for program/course cards | Program listing cards, course preview cards |
| Program Badge | Category tags, skill levels | Course category chips, difficulty level badges |

## 📝 Typography

### **Font Family**
- **Primary:** Inter (Modern, educational-friendly)
- **Secondary:** Roboto (Material Design compatibility)
- **Fallback:** System default sans-serif

### **Typography Hierarchy - Educational Focus**

### **Text Styles - Excelerate Hub**
```dart
// lib/core/themes/app_text_styles.dart
class AppTextStyles {
  // Page Titles & Hero Text
  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle heroTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  // Section Headers
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );
  
  static const TextStyle subsectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.5,
  );
  
  // Body Text - Educational Content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
  );
  
  // Interactive Elements
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
  );
  
  // Navigation & Labels
  static const TextStyle tabLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.2,
  );
  
  static const TextStyle chipLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.2,
  );
  
  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.2,
  );
  
  // Metadata & Supporting Text
  static const TextStyle metadata = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.3,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    height: 1.2,
  );
}
```

### **Typography Guidelines - Educational Context**

| Style | Usage | Example |
|-------|--------|---------|
| Page Title | Main screen headers | "My Programs", "Course Details" |
| Hero Title | Feature announcements, welcome messages | Dashboard hero section |
| Section Title | Content section headers | "Featured Programs", "Recent Feedback" |
| Card Title | Program/course titles | Program card titles, lesson names |
| Subsection Title | Component headers | Form section headers, filter categories |
| Body Large | Main descriptive content | Program descriptions, article content |
| Body Medium | Supporting content | Course requirements, instructor bio |
| Body Small | Metadata, fine print | Timestamps, additional info |
| Button Large | Primary actions | "Enroll Now", "Submit Feedback" |
| Button Medium | Secondary actions | "View Details", "Save" |
| Tab Label | Navigation elements | Bottom navigation, tab bar |
| Chip Label | Category tags, filters | Course categories, skill levels |
| Metadata | Timestamps, stats | "Published 2 days ago", "4.8 rating" |

## 🧩 Components

### **Buttons**

#### **Primary Button (Call-to-Action)**
```dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primary.withOpacity(0.3),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl, 
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text, 
                    style: AppTextStyles.buttonText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (icon != null) ...[
                    SizedBox(width: AppSpacing.sm),
                    Icon(icon, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
```

#### **Secondary Button (Alternative Action)**
```dart
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          side: BorderSide(
            color: AppColors.primary, 
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl, 
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              SizedBox(width: AppSpacing.sm),
            ],
            Text(
              text, 
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### **Ghost Button (Subtle Action)**
```dart
class GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondary,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, 
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            SizedBox(width: AppSpacing.sm),
          ],
          Text(
            text,
            style: AppTextStyles.buttonText.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
```

### **Input Fields**

```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.onSurface.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
```

### **Cards**

```dart
class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: AppColors.primary.withOpacity(0.1),
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.surfaceVariant,
          width: 1,
        ),
      ),
      color: AppColors.courseCard,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Program Image with Overlay
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.8), AppColors.secondary.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        program.imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Duration Badge
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          program.duration,
                          style: AppTextStyles.chipLabel.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              // Program Title
              Text(
                program.title,
                style: AppTextStyles.cardTitle.copyWith(color: AppColors.onSurface),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.sm),
              // Program Description
              Text(
                program.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.md),
              // Category & Rating Row
              Row(
                children: [
                  // Category Chip
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.programBadge,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      program.category.toUpperCase(),
                      style: AppTextStyles.chipLabel.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${program.rating}',
                        style: AppTextStyles.metadata.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              // Progress Indicator (if enrolled)
              if (program.progress != null) ...[
                LinearProgressIndicator(
                  value: program.progress! / 100,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  '${program.progress}% Complete',
                  style: AppTextStyles.metadata.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

## 📐 Layout & Spacing

### **Spacing Scale - Excelerate Hub**
```dart
class AppSpacing {
  static const double xs = 4.0;    // Micro spacing
  static const double sm = 8.0;    // Small spacing
  static const double md = 12.0;   // Medium spacing  
  static const double lg = 16.0;   // Large spacing (base)
  static const double xl = 20.0;   // Extra large
  static const double xxl = 24.0;  // Section spacing
  static const double xxxl = 32.0; // Major section spacing
  static const double huge = 40.0; // Hero section spacing
}
```

### **Breakpoints**
```dart
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;
}
```

### **Layout Guidelines - Educational Interface**

#### **Screen Padding & Margins**
- Mobile: 16dp horizontal, 12dp vertical
- Tablet: 20dp horizontal, 16dp vertical  
- Desktop: 24dp horizontal, 20dp vertical

#### **Component Spacing - Educational Context**
- Between major sections: 32dp
- Between cards/programs: 16dp
- Between form fields: 12dp
- Between related buttons: 8dp
- Card internal padding: 16dp
- Program card image margin: 12dp
- Navigation item spacing: 20dp

#### **Educational Content Spacing**
- Course title to description: 8dp
- Description to metadata: 12dp
- Between lesson items: 12dp
- Between feedback items: 16dp
- Form label to input: 4dp
- Error message spacing: 8dp

## 🎭 Icons & Images

### **Icon Usage**
```dart
class AppIcons {
  // Navigation
  static const IconData home = Icons.home;
  static const IconData programs = Icons.school;
  static const IconData feedback = Icons.feedback;
  static const IconData profile = Icons.person;
  
  // Actions
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData share = Icons.share;
  
  // Status
  static const IconData success = Icons.check_circle;
  static const IconData warning = Icons.warning;
  static const IconData error = Icons.error;
  static const IconData info = Icons.info;
}
```

### **Image Guidelines**

#### **Aspect Ratios**
- Program cards: 16:9
- User avatars: 1:1 (circular)
- Hero images: 21:9
- Thumbnails: 4:3

#### **Image Optimization**
- Use WebP format when possible
- Provide multiple resolutions (1x, 2x, 3x)
- Implement lazy loading
- Use placeholder images

## ♿ Accessibility

### **Color Contrast**
All color combinations meet WCAG AA standards:
- Normal text: 4.5:1 minimum
- Large text: 3:1 minimum
- UI components: 3:1 minimum

### **Touch Targets**
- Minimum size: 48x48 dp
- Recommended size: 56x56 dp
- Adequate spacing between targets

### **Screen Reader Support**
```dart
// Example with Semantics
Semantics(
  label: 'Add new program',
  hint: 'Double tap to create a new program',
  button: true,
  child: FloatingActionButton(
    onPressed: _addProgram,
    child: Icon(Icons.add),
  ),
)
```

### **Focus Management**
- Logical tab order
- Visible focus indicators
- Skip links for navigation

## 🌙 Dark Mode Support

### **Dark Theme Colors**
```dart
class AppColorsDark {
  static const Color primary = Color(0xFF90CAF9);      // Light Blue
  static const Color background = Color(0xFF121212);    // Dark Gray
  static const Color surface = Color(0xFF1E1E1E);      // Medium Dark
  static const Color onSurface = Color(0xFFE0E0E0);    // Light Gray
  static const Color onBackground = Color(0xFFB3B3B3);  // Medium Light
}
```

### **Theme Configuration**
```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headline1,
      headlineMedium: AppTextStyles.headline2,
      // ... other text styles
    ),
  );
  
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsDark.primary,
      brightness: Brightness.dark,
    ),
    // ... dark theme configuration
  );
}
```

## 📱 Responsive Design

### **Layout Adaptation**
```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= AppBreakpoints.desktop) {
      return desktop ?? tablet ?? mobile;
    } else if (screenWidth >= AppBreakpoints.tablet) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
```

### **Adaptive Components**
```dart
class AdaptiveDialog extends StatelessWidget {
  final String title;
  final Widget content;
  
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= AppBreakpoints.desktop;
    
    if (isDesktop) {
      return Dialog(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.headline6),
              SizedBox(height: 16),
              content,
            ],
          ),
        ),
      );
    } else {
      return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.headline6),
              SizedBox(height: 16),
              content,
            ],
          ),
        ),
      );
    }
  }
}
```

## 🎬 Animations & Transitions

### **Animation Guidelines**
- Duration: 200-300ms for micro-interactions
- Duration: 300-500ms for screen transitions
- Easing: Use Material motion curves

### **Common Animations**
```dart
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
}
```

## 🎯 Icon System

### **Educational Icons**

| Category | Icons | Usage Context |
|----------|--------|---------------|
| **Learning** | `Icons.school`, `Icons.menu_book`, `Icons.lightbulb` | Courses, lessons, insights |
| **Progress** | `Icons.trending_up`, `Icons.check_circle`, `Icons.star` | Achievements, completion, ratings |
| **Navigation** | `Icons.home`, `Icons.search`, `Icons.person`, `Icons.settings` | Bottom navigation, app bar |
| **Actions** | `Icons.play_arrow`, `Icons.pause`, `Icons.bookmark`, `Icons.share` | Media controls, save, share |
| **Categories** | `Icons.code`, `Icons.design_services`, `Icons.business`, `Icons.science` | Program categories |

### **Icon Sizing**

```dart
class AppIcons {
  // Icon sizes for educational context
  static const double small = 16.0;    // Inline icons, chips
  static const double medium = 20.0;   // Button icons, list items
  static const double large = 24.0;    // Navigation, primary actions
  static const double xLarge = 32.0;   // Feature highlights
  static const double hero = 48.0;     // Empty states, onboarding
}
```

### **Icon Usage Examples**

```dart
// Course Category Icons
Widget buildCategoryIcon(String category) {
  IconData iconData;
  Color iconColor;
  
  switch (category.toLowerCase()) {
    case 'programming':
      iconData = Icons.code;
      iconColor = AppColors.primary;
      break;
    case 'design':
      iconData = Icons.palette;
      iconColor = AppColors.secondary;
      break;
    case 'business':
      iconData = Icons.business_center;
      iconColor = AppColors.success;
      break;
    case 'data':
      iconData = Icons.analytics;
      iconColor = AppColors.info;
      break;
    default:
      iconData = Icons.school;
      iconColor = AppColors.onSurfaceVariant;
  }
  
  return Container(
    padding: EdgeInsets.all(AppSpacing.sm),
    decoration: BoxDecoration(
      color: iconColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(
      iconData,
      size: AppIcons.large,
      color: iconColor,
    ),
  );
}

// Progress Status Icons
Widget buildProgressIcon(double progress) {
  if (progress >= 100) {
    return Icon(
      Icons.check_circle,
      color: AppColors.success,
      size: AppIcons.medium,
    );
  } else if (progress > 0) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: progress / 100,
          strokeWidth: 2,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
        ),
        Text(
          '${progress.toInt()}%',
          style: AppTextStyles.metadata.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  } else {
    return Icon(
      Icons.play_circle_outline,
      color: AppColors.onSurfaceVariant,
      size: AppIcons.medium,
    );
  }
}
```

## � Responsive Design

### **Breakpoints**

```dart
class AppBreakpoints {
  static const double mobile = 360;    // Small phones
  static const double tablet = 768;    // Tablets, large phones landscape
  static const double desktop = 1024;  // Desktop, web app
  static const double large = 1440;    // Large screens
}
```

### **Educational Layout Patterns**

#### **Mobile-First Course Cards**
```dart
class ResponsiveCourseGrid extends StatelessWidget {
  final List<Program> programs;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;
        
        if (constraints.maxWidth < AppBreakpoints.tablet) {
          // Mobile: Single column for focus
          crossAxisCount = 1;
          childAspectRatio = 1.3;
        } else if (constraints.maxWidth < AppBreakpoints.desktop) {
          // Tablet: Two columns for browsing
          crossAxisCount = 2;
          childAspectRatio = 1.1;
        } else {
          // Desktop: Three columns for overview
          crossAxisCount = 3;
          childAspectRatio = 1.0;
        }
        
        return GridView.builder(
          padding: EdgeInsets.all(AppSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: programs.length,
          itemBuilder: (context, index) => ProgramCard(
            program: programs[index],
            onTap: () => _navigateToProgram(programs[index]),
          ),
        );
      },
    );
  }
}
```

#### **Adaptive Navigation**
```dart
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppBreakpoints.tablet;
    
    return AppBar(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      centerTitle: !isTablet, // Center on mobile, left on tablet/desktop
      title: Text(
        title,
        style: isTablet 
            ? AppTextStyles.headlineSmall 
            : AppTextStyles.titleLarge,
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.surfaceVariant,
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 1);
}
```

### **Safe Area & Accessibility**

```dart
class SafeContentWrapper extends StatelessWidget {
  final Widget child;
  final bool includeBottom;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: includeBottom,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.md,
        ),
        child: child,
      ),
    );
  }
}
```

## �📚 Resources

### **Design Tools**
- [Figma Design System](https://www.figma.com/design/UKKfcLktEPkRaWalkxqzOs/Wireframe-Designs_Xcelerate-Hub)
- [Material Design Guidelines](https://material.io/design)
- [Flutter Design Patterns](https://docs.flutter.dev/ui)

### **Accessibility Resources**
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)

---

**Last Updated:** October 13, 2025  
**Maintained by:** James Vashiri
