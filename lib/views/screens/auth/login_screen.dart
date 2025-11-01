import 'package:excelerate/core/routes/app_routes.dart';
import 'package:excelerate/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';

import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Login screen UI for the Week 2 prototype.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // We keep the controllers to allow the user to type in the fields.
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
    // We can get theme data directly without needing a Consumer for this prototype.
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeConstants.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // I've replaced the simple Text with the stylized logo we built for consistency.
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

                // --- UI for Email and Password Fields ---

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: ThemeConstants.spacing16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: _obscurePassword,
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

                // --- Sign In Button with Direct Navigation ---
                CustomButton(
                  text: 'Sign In',
                  onPressed: () {
                    // For Week 2, we just navigate directly to the home screen.
                    // No need to check email or password.
                    AppRoutes.toHome(context);
                  },
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
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: Text(
                        'Sign Up',
                        style: textTheme.bodyMedium?.copyWith(
                          color: ThemeConstants.accentColor,
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
    );
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
