import 'package:callery_app/features/getting_started.dart/screens/getting_started_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../getting_started/screens/getting_started_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // After login, the Getting Started screen is shown first.
  // "Start Calling Now" on that screen opens the Dashboard.
  bool _showGettingStarted = true;

  // Center tab (index 2) is the Dashboard.
  int _currentIndex = 2;

  late final List<Widget> _pages = const [
    _PlaceholderPage(title: 'Home'),
    _PlaceholderPage(title: 'Contacts'),
    DashboardScreen(),
    _PlaceholderPage(title: 'Call Logs'),
    _PlaceholderPage(title: 'Schedule'),
  ];

  @override
  Widget build(BuildContext context) {
    if (_showGettingStarted) {
      return GettingStartedScreen(
        onStartCalling: () => setState(() {
          _showGettingStarted = false;
          _currentIndex = 2;
        }),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          '$title\n(coming soon)',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _icons = <IconData>[
    Icons.home_outlined,
    Icons.contacts_outlined,
    Icons.play_arrow_outlined, // center (Dashboard / Start calling)
    Icons.phone_callback_outlined,
    Icons.edit_calendar_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_icons.length, (i) {
              final isCenter = i == 2;
              final selected = i == currentIndex;

              if (isCenter) {
                return GestureDetector(
                  onTap: () => onTap(i),
                  child: Container(
                    width: 72,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                );
              }

              return InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => onTap(i),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    _icons[i],
                    size: 28,
                    color:
                        selected ? AppColors.primary : AppColors.textDark,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}