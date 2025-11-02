import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // REQUIRED: To access AuthController
import '../../../controllers/auth_controller.dart'; // REQUIRED: For Login Logic
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/theme_constants.dart';
// Note: Assuming CustomTextField, CustomButton, Validators, and LoadingIndicator exist
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/utils/validators.dart'; // REQUIRED for client-side validation

/// Login screen for user authentication (Week 4 Functional Version).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- STATE AND INPUT MANAGEMENT ---
  final _formKey = GlobalKey<FormState>(); // For form validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // --- WRAP IN CONSUMER TO ACCESS CONTROLLER STATE ---
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(ThemeConstants.spacing24),
                child: Form(
                  // Wrap UI in Form widget
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo/Title (UNTOUCHED)
                      _buildLogoWithTagline(context),
                      const SizedBox(height: ThemeConstants.spacing16),

                      Text(
                        'Welcome Back!',
                        style: textTheme.headlineMedium?.copyWith(
                          color: ThemeConstants.errorColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ThemeConstants.spacing48),

                      // Email Field (Functional validation added)
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: ThemeConstants.spacing16),

                      // Password Field (Functional validation added)
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: _obscurePassword,
                        validator: (value) => Validators.password(value),
                        prefixIcon: Icons.lock_outlined,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: ThemeConstants.spacing24),

                      // --- ERROR DISPLAY (Shows Firebase/validation errors) ---
                      if (authController.error != null &&
                          !authController.isLoading)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            authController.error!,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // --- FUNCTIONAL SIGN IN BUTTON ---
                      if (authController.isLoading)
                        const LoadingIndicator() // Show loading state
                      else
                        CustomButton(
                          text: 'Sign In',
                          onPressed: () => _handleLogin(
                            authController,
                          ), // Wires to functional logic
                          isFullWidth: true,
                          backgroundColor: ThemeConstants.errorColor,
                        ),
                      const SizedBox(height: ThemeConstants.spacing24),

                      // Register Link (UNTOUCHED)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.register,
                            ),
                            child: Text(
                              'Sign Up',
                              style: textTheme.bodyMedium?.copyWith(
                                color: ThemeConstants.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- This is the updated _handleLogin function in your _LoginScreenState ---
  Future<void> _handleLogin(AuthController authController) async {
    // Hide keyboard and clear old errors
    FocusScope.of(context).unfocus();
    authController.clearError();

    // 1. Client-side validation
    if (_formKey.currentState?.validate() == true) {
      // 2. Call the AuthController (which uses Firebase)
      final success = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 3. Navigate to home only if the Firebase login was successful.
      if (success && mounted) {
        // --- ADD SUCCESS MESSAGE BEFORE NAVIGATING ---
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful! Redirecting to Home...'),
            backgroundColor: ThemeConstants.successColor,
          ),
        );

        // Use pushReplacementNamed to prevent user from going back to login screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    }
  }

  // --- VISUAL BUILDERS (UNTOUCHED, Preserving your design) ---
  Widget _buildLogoWithTagline(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        // Logo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildDash(),
                const SizedBox(height: 4),
                _buildDash(),
                const SizedBox(height: 4),
                _buildDash(),
              ],
            ),
            const SizedBox(width: 3.2),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  ThemeConstants.tertiaryColor,
                  ThemeConstants.errorColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                'xcelerate',
                style: textTheme.displaySmall?.copyWith(fontSize: 30.4),
              ),
            ),
          ],
        ),
        // Tagline positioned from center to right with minimal margin
        const SizedBox(height: ThemeConstants.spacing4),
        Row(
          children: [
            const Spacer(),
            Expanded(
              child: Text(
                'Learn. Engage. Grow.',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDash() {
    return Container(
      height: 12,
      width: 96,
      decoration: BoxDecoration(
        color: ThemeConstants.tertiaryColor,
        borderRadius: BorderRadius.circular(4.8),
      ),
    );
  }
}
