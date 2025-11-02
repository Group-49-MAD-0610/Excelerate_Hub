import 'package:excelerate/core/routes/app_routes.dart';
import 'package:excelerate/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Login screen with authentication functionality
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

    return PopScope(
      canPop: false, // Prevent back navigation from login screen
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeConstants.spacing24),
              child: Consumer<AuthController>(
                builder: (context, authController, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLogoWithTagline(context),
                        const SizedBox(height: ThemeConstants.spacing16),

                        Text(
                          'Welcome Back!',
                          style: textTheme.headlineMedium?.copyWith(
                            color: ThemeConstants.accentColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: ThemeConstants.spacing48),

                        // Show error message if any
                        if (authController.error != null)
                          Container(
                            padding: const EdgeInsets.all(
                              ThemeConstants.spacing12,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: ThemeConstants.spacing16,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeConstants.errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                ThemeConstants.borderRadiusSmall,
                              ),
                              border: Border.all(
                                color: ThemeConstants.errorColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: ThemeConstants.errorColor,
                                  size: ThemeConstants.iconSizeMedium,
                                ),
                                const SizedBox(width: ThemeConstants.spacing8),
                                Expanded(
                                  child: Text(
                                    authController.error!,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: ThemeConstants.errorColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Email Field
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          enabled: !authController.isLoading,
                        ),
                        const SizedBox(height: ThemeConstants.spacing16),

                        // Password Field
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outlined,
                          enabled: !authController.isLoading,
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

                        // Sign In Button
                        CustomButton(
                          text: authController.isLoading
                              ? 'Signing In...'
                              : 'Sign In',
                          onPressed: authController.isLoading
                              ? null
                              : () => _handleLogin(context, authController),
                          isFullWidth: true,
                          backgroundColor: ThemeConstants.accentColor,
                        ),
                        const SizedBox(height: ThemeConstants.spacing24),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: authController.isLoading
                                  ? null
                                  : () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.register,
                                    ),
                              child: Text(
                                'Sign Up',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: authController.isLoading
                                      ? ThemeConstants.accentColor.withOpacity(
                                          0.5,
                                        )
                                      : ThemeConstants.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ), // Consumer
            ), // SingleChildScrollView
          ), // Center
        ), // SafeArea
      ), // Scaffold
    ); // PopScope
  } // Widget build

  /// Handle login button press
  Future<void> _handleLogin(
    BuildContext context,
    AuthController authController,
  ) async {
    // Clear previous errors
    authController.clearError();

    // Get input values
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Attempt login
    final success = await authController.login(
      email: email,
      password: password,
    );

    if (success && mounted) {
      // Navigate to home screen on successful login
      AppRoutes.toHome(context);
    }
  }

  // Logo with tagline positioned from center to right
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
            const Spacer(), // Takes up left half of the screen
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
      height: 12, // Expanded from 6 to 12 (*2)
      width: 96, // Expanded from 48 to 96 (*2)
      decoration: BoxDecoration(
        color: ThemeConstants.tertiaryColor,
        borderRadius: BorderRadius.circular(
          4.8,
        ), // Expanded from 2.4 to 4.8 (*2)
      ),
    );
  }
}
