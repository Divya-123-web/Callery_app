import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../language/screens/language_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: Replace this mock data with real data once the API docs arrive.
  static const String _name = 'Divya';
  static const String _email = 'divya.jo.in';
  static const String _mobile = '9971125588';
  static const String _parentAccount = 'NA';
  static const String _subscription = 'Calley Personal';

  final List<String> _callingLists = ['Test List'];

  String _languageCode = 'en';
  int _selectedList = 0;
  bool _refreshing = false;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openLanguage() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => LanguageScreen(initialCode: _languageCode),
      ),
    );
    if (result != null && mounted) {
      setState(() => _languageCode = result);
    }
  }

  Future<void> _refreshLists() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    // TODO: Call the "get calling lists" API here.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _refreshing = false);
    _showMessage('Calling lists refreshed');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: AppColors.textDark,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      children: [
                        _buildProfileCard(),
                        const SizedBox(height: 22),

                        // PROFILE SETTINGS
                        _Section(
                          title: 'PROFILE SETTINGS',
                          headerColor: const Color(0xFF0F172A),
                          bodyColor: const Color(0xFFF1F5F9),
                          children: [
                            _SettingTile(
                              icon: Icons.language_rounded,
                              label: 'App Language',
                              onTap: _openLanguage,
                            ),
                            const SizedBox(height: 14),
                            _SettingTile(
                              icon: Icons.lock_outline_rounded,
                              label: 'Change Password',
                              onTap: () =>
                                  _showMessage('Change Password coming soon'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // CALLING LISTS
                        _Section(
                          title: 'CALLING LISTS',
                          headerColor: AppColors.navy,
                          bodyColor: Colors.white,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Select Calling List',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: _refreshLists,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.sync_rounded,
                                                color: Colors.white,
                                                size: 22),
                                            SizedBox(width: 8),
                                            Text(
                                              'Refresh',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            for (int i = 0; i < _callingLists.length; i++) ...[
                              _SettingTile(
                                label: _callingLists[i],
                                selected: i == _selectedList,
                                onTap: () {
                                  setState(() => _selectedList = i);
                                  _showMessage(
                                      '${_callingLists[i]} selected');
                                },
                              ),
                              if (i != _callingLists.length - 1)
                                const SizedBox(height: 14),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dim loading overlay while refreshing
        if (_refreshing)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.55),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileCard() {
    const lineStyle = TextStyle(
      fontSize: 15,
      height: 1.5,
      color: Colors.white,
      decoration: TextDecoration.none,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE5506A),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFFFFC857),
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello $_name',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 2),
                Text(_email, style: lineStyle),
                Text(_mobile, style: lineStyle),
                Text('Parent Account: $_parentAccount', style: lineStyle),
                Text('Current Subscription: $_subscription',
                    style: lineStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Section with a dark header strip and a rounded body that overlaps it.
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.headerColor,
    required this.bodyColor,
    required this.children,
  });

  final String title;
  final Color headerColor;
  final Color bodyColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            decoration: BoxDecoration(
              color: bodyColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// One row: optional icon box + label + "arrow in a box" icon.
class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.label,
    required this.onTap,
    this.icon,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightBlue,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: selected
                ? Border.all(color: AppColors.primary, width: 1.6)
                : null,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(icon, color: AppColors.textDark, size: 24),
                ),
                const SizedBox(width: 14),
              ] else
                const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.textDark, width: 1.6),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}