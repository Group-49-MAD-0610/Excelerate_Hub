import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Required for AuthController
import '../../../controllers/auth_controller.dart'; // <-- Required for logic
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/theme_constants.dart';
// Note: Assuming CustomTextField, CustomButton, Validators, and LoadingIndicator exist.
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_indicator.dart';
// Note: I am defining simple validators here for the UI, as they are essential for the form.
import '../../../core/utils/validators.dart';

/// Screen for new user registration
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // We keep the controllers and form key for validation and input management.
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // NEW: For Name field
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.spacing24),
          // Use Consumer to access the AuthController state (isLoading, error)
          child: Consumer<AuthController>(
            builder: (context, authController, child) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and Title (Consistent with Login Screen)
                      _buildLogoWithTagline(context),
                      const SizedBox(height: ThemeConstants.spacing16),
                      Text(
                        'Welcome Onboard!',
                        style: textTheme.headlineMedium?.copyWith(
                          color: ThemeConstants
                              .errorColor, // Consistent with your Login button color
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: ThemeConstants.spacing48),

                      // --- Registration Form ---
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // 1. Name Field (NEW)
                            CustomTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              keyboardType: TextInputType.name,
                              validator: (value) =>
                                  Validators.required(value, 'Name'),
                              prefixIcon: Icons.person_outline,
                            ),
                            const SizedBox(height: ThemeConstants.spacing16),

                            // 2. Email Field
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: ThemeConstants.spacing16),

                            // 3. Password Field
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Create a strong password',
                              obscureText: _obscurePassword,
                              validator: (value) => Validators.password(value),
                              prefixIcon: Icons.lock_outlined,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            const SizedBox(height: ThemeConstants.spacing24),

                            // Error Display
                            if (authController.error != null &&
                                !authController.isLoading)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  authController.error!,
                                  style: TextStyle(color: Colors.pink),
                                ),
                              ),

                            // Register Button
                            if (authController.isLoading)
                              const LoadingIndicator()
                            else
                              CustomButton(
                                text: 'Sign Up',
                                onPressed: () => _handleRegister(
                                  authController,
                                ), // Wires to new function
                                isFullWidth: true,
                                backgroundColor: ThemeConstants.errorColor,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: ThemeConstants.spacing24),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(
                              context,
                            ), // Go back to Login Screen
                            child: Text(
                              'Sign In',
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
              );
            },
          ),
        ),
      ),
    );
  }

  // --- REGISTRATION LOGIC HANDLER (NEW FUNCTIONALITY) ---
  Future<void> _handleRegister(AuthController authController) async {
    // Hide keyboard and clear old errors
    FocusScope.of(context).unfocus();
    authController.clearError();

    // Validate the entire form
    if (_formKey.currentState?.validate() == true) {
      final success = await authController.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Navigate to home only if the Firebase registration was successful.
      if (success && mounted) {
        // Use pushReplacementNamed to prevent user from going back to login screen
        AppRoutes.toHome(context);
      }
      // If registration fails (e.g., email already in use), the AuthController's
      // error state is updated, and the UI rebuilds to show the error message.
    }
  }

  // --- VISUAL BUILDERS (Copied exactly from LoginScreen for consistency) ---
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
