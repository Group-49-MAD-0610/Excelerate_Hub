# Excelerate Hub - Flutter Application

> **A comprehensive Flutter application for program management and user engagement, built with MVC architecture and modern development practices.**

---

## 📱 **Application Screenshots**

### **Login Screen**
<img src="https://raw.githubusercontent.com/Group-49-MAD-0610/Excelerate_Hub/main/assets/screenshots/login_screen.png" alt="Login Screen" width="300"/>

*Elegant authentication interface featuring the Excelerate logo with gradient bars, "Learn. Engage. Grow." tagline, and streamlined email/password login with accent-colored Sign In button.*

### **Home Dashboard** 
<img src="https://raw.githubusercontent.com/Group-49-MAD-0610/Excelerate_Hub/main/assets/screenshots/home_screen.png" alt="Home Dashboard" width="300"/>

*Personalized dashboard greeting "Hi, Sarah!" with achievement stats (10 Enrolled, 6 Completed, 4 Badges), user experiences section showcasing Machine Learning and Project Management, favorites, and upcoming programs.*

### **Programs Listing**
<img src="https://raw.githubusercontent.com/Group-49-MAD-0610/Excelerate_Hub/main/assets/screenshots/programs_screen.png" alt="Programs Screen" width="300"/>

*Organized program browsing with Enrolled/Upcoming/Favorites tabs. Features Machine Learning Fundamentals from St. Louis University with Program Benefits including Certificate, $1,000 Scholarship, Collaboration, and Creative Thinking skills.*

### **Program Details**
<img src="https://raw.githubusercontent.com/Group-49-MAD-0610/Excelerate_Hub/main/assets/screenshots/program_detail_screen.png" alt="Program Details" width="300"/>

*Comprehensive Machine Learning program page showing 4-week duration, St. Louis University partnership, detailed internship description, and "What You'll Learn" section with project management and real-world application focus.*

---

## 🚀 **App Features Demonstrated**

### **✅ Core Functionality**
- **User Authentication**: Secure login with form validation
- **Navigation Flow**: Seamless navigation between all screens
- **Bottom Navigation**: Consistent navigation bar across main screens
- **Interactive UI**: Responsive buttons, tabs, and card interactions
- **Program Management**: Browse, filter, and view detailed program information

### **✅ Design Implementation**
- **Material Design 3**: Modern UI patterns and components
- **Consistent Branding**: Excelerate color scheme (#F76169) throughout
- **Responsive Layout**: Optimized for mobile devices
- **Typography**: Poppins font family for enhanced readability
- **Icon Integration**: Intuitive iconography for better UX

### **✅ Navigation System**
- **Login → Home**: Direct authentication flow
- **Bottom Tabs**: Programs, Home, Profile navigation
- **Program Details**: Deep navigation with back functionality
- **Search & Filter**: Program discovery capabilities

---

## 📋 **Week 2 Deliverables - UI Prototype**

### **Functional Screens Implemented**
1. **Login Screen** - Complete authentication UI with Excelerate branding
2. **Home Screen** - Interactive dashboard with user achievements and quick access
3. **Program Listing Screen** - Tab-based organization with search functionality  
4. **Program Details Screen** - Comprehensive program information and application flow

### **Technical Implementation**
- ✅ **Navigation System**: Full routing between all screens with AppRoutes
- ✅ **State Management**: Proper state handling across components
- ✅ **UI Consistency**: Material Design 3 with consistent theming
- ✅ **Interactive Elements**: Working buttons, tabs, and navigation
- ✅ **Responsive Design**: Optimized for mobile screen sizes

### **User Journey Flow**
```
Login Screen → Sign In → Home Dashboard → Programs Tab → Program Details → Apply
     ↓              ↓           ↓             ↓              ↓           ↓
Authentication → Dashboard → Program Browse → Details View → Action Flow
```

---

##  **About Excelerate Hub**

Excelerate Hub is a cross-platform Flutter application designed to provide users with seamless access to educational programs, feedback systems, and interactive dashboards. Built with scalability, maintainability, and user experience in mind.

### **Key Features**
- 🔐 **User Authentication** - Secure login and registration
- 📊 **Dashboard** - Interactive program overview and analytics
- 📋 **Program Management** - Browse, view, and manage educational programs
- 💬 **Feedback System** - Submit and manage user feedback
- 🎨 **Modern UI/UX** - Material Design 3 with responsive layouts
- 🌐 **Cross-Platform** - Android, iOS, Web, Windows, macOS, Linux support

---

## **Architecture**

This project follows **MVC (Model-View-Controller)** architecture pattern:
1. **Login Screen** → User authentication  
```
lib/
├── models/          # Data models, repositories, and services
├── views/           # UI screens, widgets, and dialogs
├── controllers/     # Business logic and state management
└── core/           # App configuration, themes, and utilities
```

**State Management:** Provider with ChangeNotifier pattern  
**Dependency Injection:** Constructor injection with Provider  
**API Integration:** Repository pattern with HTTP client  

---

## **Technology Stack**

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.16+ |
| **Language** | Dart 3.2+ |
| **State Management** | Provider |
| **Architecture** | MVC Pattern |
| **Testing** | Unit, Widget, Integration tests |
| **CI/CD** | GitHub Actions |
| **Code Quality** | Flutter Lints, Custom Rules |

---

## **Getting Started**

### **Prerequisites**
- Flutter SDK ≥ 3.16.0
- Dart SDK ≥ 3.2.0
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/vashirij/Excelerate_Hub.git
   cd Excelerate_Hub
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## **Development Guidelines**

- Follow [Coding Standards](docs/CODING_STANDARDS.md)
- Use MVC architecture pattern
- Write comprehensive tests
- Follow Flutter/Dart naming conventions

---

## **Contributing**

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## **Team**
**Group 49 – MA&D 0610**
- **Oswa Zafar** - *Developer
- **Zain	Tahir** - * Snr Developer & Project Manager* 
- **Aleena  Tanveer** -*Developer*
- **Sylvester	Tettey**-*Snr Developer*
- **Jayadev Tripathi**-*UI/UX Lead Designer*
- **Vignesh Venkatesan**- *Team Lead* 
- **James Vashiri** - *Team Lead & Project Manager*  


## 🔗 **Links**

- **Figma Wireframes:** [Design System](https://www.figma.com/design/UKKfcLktEPkRaWalkxqzOs/Wireframe-Designs_Xcelerate-Hub)
- **Documentation:** [Coding Standards](docs/CODING_STANDARDS.md)

---

## 📸 **Adding Screenshots to README**

To complete the documentation with your app screenshots:

1. **Save Screenshots**: Take screenshots of all 4 screens from your device/emulator
2. **File Naming**: Save them as:
   - `login_screen.png`
   - `home_screen.png` 
   - `programs_screen.png`
   - `program_detail_screen.png`
3. **Directory**: Place all screenshots in `assets/screenshots/` folder
4. **Commit**: Add, commit, and push the images to GitHub

```bash
# Add screenshots to the project
git add assets/screenshots/
git commit -m "docs: Add app screenshots for README documentation"
git push origin main
```

---

## 🎯 **Week 2 Submission Checklist**

### **Completed ✅**
- [x] **Login Screen** - Functional with navigation
- [x] **Home Screen** - Dashboard with quick access
- [x] **Program Listing** - Tab organization with search
- [x] **Program Details** - Comprehensive information display
- [x] **Navigation System** - Complete routing between screens
- [x] **UI Consistency** - Material Design 3 theming
- [x] **README Documentation** - Project overview and features

### **Next Steps 📋**
- [ ] Add actual screenshots to `assets/screenshots/` directory
- [ ] Final commit and push to GitHub
- [ ] Optional: Record demo video (2-3 minutes)
- [ ] Submit GitHub repository link

---

<div align="center">

Made with ❤️ by **Group 49 – MA&D 0610**
</div>  

---

## **Tools and Technologies**
- **Frontend:** Flutter  
- **Backend:** Firebase  
- **Design:** Figma  
- **Version Control:** Git & GitHub  

---

## **Repository Information**
This repository contains:
- Initial Flutter project folder structure  
- README.md (project overview and objectives)  
- Version control history (commits and pushes)  

---

## **Project Link**
- **GitHub Repository:** https://github.com/31jay/Excelerate_Flutter_Mobile_Application_Development_Internship/edit/main/README.md
- **Figma Wireframes:** https://www.figma.com/design/UKKfcLktEPkRaWalkxqzOs/Wireframe-Designs_Xcelerate-Hub?node-id=0-1&p=f&t=0gtzVMZDXl0lwZhP-0

---

### **Developed By**
**Group 49 – MA&D 0610**  

