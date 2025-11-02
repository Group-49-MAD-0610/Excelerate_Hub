import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../controllers/auth_controller.dart';

/// Profile screen displaying user information and settings
///
/// This screen provides a comprehensive view of user profile details,
/// achievements, and settings with a clean, modern design.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          final user = authController.currentUser;

          return CustomScrollView(
            slivers: [
              // App Bar with gradient
              _buildAppBar(context),

              // Profile Content
              SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Header
                  _buildProfileHeader(
                    context,
                    user?.name ?? 'Guest User',
                    user?.email ?? '',
                  ),

                  const SizedBox(height: ThemeConstants.spacing24),

                  // Stats Section
                  _buildStatsSection(context),

                  const SizedBox(height: ThemeConstants.spacing24),

                  // Settings Section
                  _buildSettingsSection(context),

                  const SizedBox(height: ThemeConstants.spacing24),

                  // Logout Button
                  _buildLogoutButton(context, authController),

                  const SizedBox(height: ThemeConstants.spacing40),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Builds the app bar consistent with program list screen
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ThemeConstants.surfaceColor,
      foregroundColor: Colors.black87,
      elevation: 0,
      pinned: true,
      floating: false,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      ),
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings coming soon!')),
            );
          },
          tooltip: 'Settings',
        ),
        const SizedBox(width: ThemeConstants.spacing8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: ThemeConstants.outlineColor),
      ),
    );
  }

  /// Builds the profile header with avatar and user info
  Widget _buildProfileHeader(BuildContext context, String name, String email) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with accent color border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.accentColor.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ThemeConstants.accentColor, width: 3),
              ),
              padding: const EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: ThemeConstants.accentColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: ThemeConstants.accentColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: ThemeConstants.spacing16),

          // Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: ThemeConstants.onSurfaceColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: ThemeConstants.spacing4),

          // Email
          Text(
            email,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: ThemeConstants.onSurfaceVariantColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: ThemeConstants.spacing16),

          // Edit Profile Button
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: ThemeConstants.accentColor,
              side: BorderSide(color: ThemeConstants.accentColor, width: 2),
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spacing24,
                vertical: ThemeConstants.spacing12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the statistics section
  Widget _buildStatsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.school_rounded,
              value: '12',
              label: 'Enrolled',
              color: ThemeConstants.primaryColor,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacing12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.workspace_premium_rounded,
              value: '8',
              label: 'Completed',
              color: ThemeConstants.successColor,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacing12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.emoji_events_rounded,
              value: '5',
              label: 'Badges',
              color: ThemeConstants.tertiaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single stat card
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacing8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: ThemeConstants.iconSizeLarge),
          ),
          const SizedBox(height: ThemeConstants.spacing8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: ThemeConstants.onSurfaceColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: ThemeConstants.onSurfaceVariantColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the settings section
  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spacing20),
            child: Text(
              'Settings & Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: ThemeConstants.onSurfaceColor,
              ),
            ),
          ),
          _buildSettingTile(
            context,
            icon: Icons.person_outline_rounded,
            title: 'Account Settings',
            subtitle: 'Manage your account details',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account settings coming soon!')),
              );
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Configure notification preferences',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings coming soon!'),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            context,
            icon: Icons.security_rounded,
            title: 'Privacy & Security',
            subtitle: 'Manage privacy settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon!')),
              );
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            context,
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get help or contact support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & support coming soon!')),
              );
            },
          ),
          _buildDivider(),
          _buildSettingTile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  /// Builds a setting tile
  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing20,
          vertical: ThemeConstants.spacing16,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.spacing8),
              decoration: BoxDecoration(
                color: ThemeConstants.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusSmall,
                ),
              ),
              child: Icon(
                icon,
                color: ThemeConstants.accentColor,
                size: ThemeConstants.iconSizeLarge,
              ),
            ),
            const SizedBox(width: ThemeConstants.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: ThemeConstants.onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      color: ThemeConstants.onSurfaceVariantColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: ThemeConstants.onSurfaceVariantColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a divider
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      child: Divider(height: 1, color: ThemeConstants.outlineColor),
    );
  }

  /// Builds the logout button
  Widget _buildLogoutButton(
    BuildContext context,
    AuthController authController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      child: ElevatedButton.icon(
        onPressed: authController.isLoading
            ? null
            : () => _handleLogout(context, authController),
        icon: authController.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.logout_rounded),
        label: Text(
          authController.isLoading ? 'Logging out...' : 'Logout',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.errorColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: ThemeConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          elevation: ThemeConstants.elevationMedium,
        ),
      ),
    );
  }

  /// Handles logout action
  Future<void> _handleLogout(
    BuildContext context,
    AuthController authController,
  ) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusSmall,
                ),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      final success = await authController.logout();

      if (success && context.mounted) {
        // Navigate to login screen
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      } else if (!success && context.mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authController.error ?? 'Failed to logout',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: ThemeConstants.errorColor,
          ),
        );
      }
    }
  }

  /// Shows the about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeConstants.accentColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Excelerate Hub',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your gateway to excellence in education.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2025 Excelerate Hub. All rights reserved.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusSmall,
                ),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
