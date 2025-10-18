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
    final colorScheme = Theme.of(context).colorScheme;

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
                _buildLogo(context),
                const SizedBox(height: ThemeConstants.spacing16),

                Text(
                  'Welcome Back!',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ThemeConstants.spacing8),
                Text(
                  'Learn. Engage. Grow.', // This matches the logo's tagline.
                  style: textTheme.titleSmall,
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
                          color: colorScheme.primary,
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

  // Reusing the logo we built for the home screen for brand consistency.
  Widget _buildLogo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildDash(),
            const SizedBox(height: 5),
            _buildDash(),
            const SizedBox(height: 5),
            _buildDash(),
          ],
        ),
        const SizedBox(width: 8),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [ThemeConstants.tertiaryColor, ThemeConstants.errorColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            'xcelerate',
            style: textTheme.displaySmall?.copyWith(fontSize: 38),
          ),
        ),
      ],
    );
  }

  Widget _buildDash() {
    return Container(
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        color: ThemeConstants.tertiaryColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
