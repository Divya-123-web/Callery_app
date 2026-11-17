import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Reusable Calley logo (icon + "CALLEY / AUTOMATIC CALL DIALER").
/// Built with Flutter widgets. Replace with the real image asset if provided.
class CalleyLogo extends StatelessWidget {
  const CalleyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const SweepGradient(
            colors: [
              Color(0xFFFFD500),
              Color(0xFFFF3D81),
              Color(0xFF7C4DFF),
              Color(0xFF00C2FF),
              Color(0xFF1FD65F),
              Color(0xFFFFD500),
            ],
          ).createShader(bounds),
          child: const Icon(
            Icons.phone_in_talk_rounded,
            size: 58,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'CALLEY',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
                color: Color(0xFF1E9BF0),
                height: 1.1,
              ),
            ),
            Text(
              'AUTOMATIC CALL DIALER',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}