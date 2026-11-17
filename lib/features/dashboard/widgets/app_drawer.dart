import 'dart:math' as math;

import 'package:callery_app/features/getting_started.dart/screens/getting_started_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/screens/sign_in_screen.dart';
import '../../getting_started/screens/getting_started_screen.dart';
import '../../settings/screens/settings_screen.dart';

/// Side menu shown from the Dashboard (matches the Figma drawer).
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // TODO: replace with real user data / package version later.
  static const String _name = 'Divya';
  static const String _plan = 'Personal';
  static const String _email = 'divya@2004@gmail.com';
  static const String _version = '1.01.52';

  /// Closes the drawer, then opens [screen].
  void _open(BuildContext context, Widget screen) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute(builder: (_) => screen));
  }

  /// Closes the drawer, then shows a short message.
  void _comingSoon(BuildContext context, String feature) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature coming soon.')));
  }

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: clear the saved login session here.
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = math.min(MediaQuery.of(context).size.width * 0.78, 340.0);

    return Drawer(
      width: width,
      backgroundColor: AppColors.lightBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 14, 12, 20),
              children: [
                _DrawerItem(
                  icon: Icons.rocket_launch_outlined,
                  label: 'Getting Started',
                  onTap: () => _open(context, const GettingStartedScreen()),
                ),
                _DrawerItem(
                  icon: Icons.cloud_sync_outlined,
                  label: 'Sync Data',
                  onTap: () => _comingSoon(context, 'Sync Data'),
                ),
                _DrawerItem(
                  icon: Icons.widgets_outlined,
                  label: 'Gamification',
                  onTap: () => _comingSoon(context, 'Gamification'),
                ),
                _DrawerItem(
                  icon: Icons.perm_phone_msg_outlined,
                  label: 'Send Logs',
                  onTap: () => _comingSoon(context, 'Send Logs'),
                ),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => _open(context, const SettingsScreen()),
                ),
                _DrawerItem(
                  icon: Icons.headset_mic_outlined,
                  label: 'Help?',
                  onTap: () => _comingSoon(context, 'Help'),
                ),
                _DrawerItem(
                  icon: Icons.person_off_outlined,
                  label: 'Cancel Subscription',
                  onTap: () => _comingSoon(context, 'Cancel Subscription'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: AppColors.border, height: 1),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(4, 6, 0, 10),
                  child: Text(
                    'App Info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _DrawerItem(
                  icon: Icons.badge_outlined,
                  label: 'About Us',
                  onTap: () => _comingSoon(context, 'About Us'),
                ),
                _DrawerItem(
                  icon: Icons.policy_outlined,
                  label: 'Privacy Policy',
                  onTap: () => _comingSoon(context, 'Privacy Policy'),
                ),
                _DrawerItem(
                  icon: Icons.verified_outlined,
                  label: 'Version $_version',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.share_outlined,
                  label: 'Share App',
                  onTap: () => _comingSoon(context, 'Share App'),
                ),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- header
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18,
        MediaQuery.of(context).padding.top + 18,
        16,
        20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8506A),
            ),
            child: const Icon(Icons.person_rounded,
                size: 36, color: Color(0xFFFFD27A)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        _name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '•',
                      style: TextStyle(fontSize: 14, color: Color(0xFFFFD27A)),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      _plan,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFD27A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One menu row: [round icon] Label
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 26, color: AppColors.textDark),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}