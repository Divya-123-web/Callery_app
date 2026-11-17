import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/screens/sign_up_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    super.key,
    this.initialCode = 'en',
    this.isOnboarding = false,
  });

  /// Language code that is selected when the screen opens.
  final String initialCode;

  /// true  -> first screen of the app (Select goes to the Welcome/Sign Up screen)
  /// false -> opened later from Settings (Select goes back with the chosen code)
  final bool isOnboarding;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _Language {
  const _Language(this.code, this.name, this.greeting);
  final String code;
  final String name;
  final String greeting;
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const List<_Language> _languages = [
    _Language('en', 'English', 'Hi'),
    _Language('hi', 'Hindi', 'नमस्ते'),
    _Language('bn', 'Bengali', 'হ্যালো'),
    _Language('kn', 'Kannada', 'ನಮಸ್ಕಾರ'),
    _Language('pa', 'Punjabi', 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ'),
    _Language('ta', 'Tamil', 'வணக்கம்'),
    _Language('te', 'Telugu', 'హలో'),
    _Language('fr', 'French', 'Bonjour'),
    _Language('es', 'Spanish', 'Hola'),
  ];

  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCode;
  }

  void _onSelect() {
    // TODO: Save the chosen language (and apply localization) later.
    if (widget.isOnboarding) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Language updated')),
      );
      Navigator.of(context).maybePop(_selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              const Text(
                'Choose Your Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      itemCount: _languages.length,
                      itemBuilder: (context, index) {
                        final lang = _languages[index];
                        final isSelected = lang.code == _selected;
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() => _selected = lang.code),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        lang.greeting,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _RadioDot(selected: isSelected),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSelect,
                  child: const Text('Select'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom radio (avoids the deprecated Radio widget API).
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.textDark, width: 1.6),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textDark,
              ),
            )
          : null,
    );
  }
}