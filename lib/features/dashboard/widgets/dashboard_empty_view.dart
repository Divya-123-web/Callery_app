import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/whatsapp_icon.dart';

/// Dashboard content shown when no calling list has been loaded yet.
class DashboardEmptyView extends StatefulWidget {
  final String userName;
  final VoidCallback onStartCalling;
  final VoidCallback onWhatsApp;

  const DashboardEmptyView({
    super.key,
    required this.userName,
    required this.onStartCalling,
    required this.onWhatsApp,
  });

  @override
  State<DashboardEmptyView> createState() => _DashboardEmptyViewState();
}

class _DashboardEmptyViewState extends State<DashboardEmptyView> {
  static const String _webPanelUrl = 'https://app.getcalley.com';

  late final TapGestureRecognizer _linkRecognizer;

  @override
  void initState() {
    super.initState();
    _linkRecognizer = TapGestureRecognizer()..onTap = _openWebPanel;
  }

  @override
  void dispose() {
    _linkRecognizer.dispose();
    super.dispose();
  }

  Future<void> _openWebPanel() async {
    try {
      final opened = await launchUrl(
        Uri.parse(_webPanelUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && mounted) _showMessage('Could not open the link.');
    } catch (_) {
      if (mounted) _showMessage('Could not open the link.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWelcomeCard(),
        const SizedBox(height: 18),
        Expanded(child: _buildLoadNumberCard()),
        const SizedBox(height: 18),
        _buildBottomActions(),
      ],
    );
  }

  // --------------------------------------------------------- welcome card
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8506A),
            ),
            child: const Icon(Icons.person_rounded,
                size: 40, color: Color(0xFFFFD27A)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello ${widget.userName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Welcome to Calley!',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------- load number card
  Widget _buildLoadNumberCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        color: AppColors.navy,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'LOAD NUMBER TO CALL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          color: AppColors.textDark,
                        ),
                        children: [
                          const TextSpan(text: 'Visit '),
                          TextSpan(
                            text: _webPanelUrl,
                            recognizer: _linkRecognizer,
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          const TextSpan(
                            text: ' to upload numbers that you wish to call '
                                'using Calley Mobile App.',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Illustration scales down on small screens.
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomLeft,
                          child: _UploadIllustration(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------ bottom actions
  Widget _buildBottomActions() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onWhatsApp,
          child: Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.whatsapp, width: 1.6),
            ),
            child: const WhatsAppIcon(size: 32),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton(
            onPressed: widget.onStartCalling,
            child: const Text('Start Calling Now'),
          ),
        ),
      ],
    );
  }
}

/// Simple illustration drawn with widgets: a phone with an upload button
/// and a support agent. Replace with the real image if one is provided.
class _UploadIllustration extends StatelessWidget {
  const _UploadIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 260,
      child: Stack(
        children: [
          // Soft background shapes
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 210,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFE6E9FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  topRight: Radius.circular(120),
                ),
              ),
            ),
          ),
          Positioned(
            left: 130,
            bottom: 0,
            child: Container(
              width: 140,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(90),
                  topRight: Radius.circular(90),
                ),
              ),
            ),
          ),

          // Phone
          Positioned(
            left: 50,
            top: 0,
            child: Container(
              width: 120,
              height: 190,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Align(
                  alignment: const Alignment(0.5, -0.55),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.upload_rounded,
                        size: 22, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // Support agent
          const Positioned(
            left: 70,
            bottom: 0,
            child: Icon(
              Icons.support_agent_rounded,
              size: 150,
              color: Color(0xFFFF7A3D),
            ),
          ),
        ],
      ),
    );
  }
}