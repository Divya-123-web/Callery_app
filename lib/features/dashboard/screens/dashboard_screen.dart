import 'dart:math' as math;

import 'package:callery_app/features/dashboard/widgets/dashboard_empty_view.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../calling_list/screens/calling_list_screen.dart';
import '../widgets/app_drawer.dart';
import 'calling_list_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // TODO: replace this mock data with the API response.
  // false = welcome view ("Load number to call")
  // true  = stats view (chart + tiles)
  final bool _hasCallingList = false;

  final String _userName = 'Swati';
  final String _listName = 'Test List';
  final int _totalCalls = 50;
  final int _pendingCalls = 28;
  final int _doneCalls = 22;
  final int _scheduledCalls = 9;

  // Calling list chosen in the "Calling Lists" popup.
  String? _selectedList;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // Start Calling Now -> Calling Lists popup (7th screen)
  // -> after selecting a list, the calling list dashboard (8th screen).
  Future<void> _onStartCalling() async {
    final result = await CallingListScreen.open(
      context,
      selectedList: _selectedList,
    );
    if (!mounted) return;
    if (result != null) {
      setState(() => _selectedList = result);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CallingListDashboardScreen(listName: result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              Expanded(
                child: _hasCallingList
                    ? _buildStatsView()
                    : DashboardEmptyView(
                        userName: _userName,
                        onStartCalling: _onStartCalling,
                        onWhatsApp: () =>
                            _showMessage('WhatsApp support coming soon.'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- header
  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.menu_rounded,
                size: 30, color: AppColors.textDark),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => _showMessage('Support coming soon.'),
          icon: const Icon(Icons.support_agent_rounded,
              size: 28, color: AppColors.textDark),
        ),
        IconButton(
          onPressed: () => _showMessage('Notifications coming soon.'),
          icon: const Icon(Icons.notifications_none_rounded,
              size: 28, color: AppColors.textDark),
        ),
      ],
    );
  }

  // ------------------------------------------------------------ stats view
  Widget _buildStatsView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildListCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: _buildChart(),
                ),
                Column(
                  children: [
                    _buildStatTiles(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _onStartCalling,
                      child: const Text('Start Calling Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------- list card
  Widget _buildListCard() {
    final initial = _listName.isEmpty ? '?' : _listName[0].toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$_totalCalls',
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'CALLS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 78,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- chart
  Widget _buildChart() {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = math.min(screenWidth * 0.62, 260.0);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return CustomPaint(
          size: Size.square(size),
          painter: _DonutPainter(
            progress: progress,
            segments: [
              _Segment(_doneCalls.toDouble(), const Color(0xFF1E73E8)),
              _Segment(_scheduledCalls.toDouble(), AppColors.schedule),
              _Segment(_pendingCalls.toDouble(), AppColors.pending),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------- stat tiles
  Widget _buildStatTiles() {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'Pending',
            count: _pendingCalls,
            barColor: AppColors.pending,
            backgroundColor: AppColors.pendingBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: 'Done',
            count: _doneCalls,
            barColor: AppColors.done,
            backgroundColor: AppColors.doneBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: 'Schedule',
            count: _scheduledCalls,
            barColor: const Color(0xFF4F2BD6),
            backgroundColor: AppColors.scheduleBg,
          ),
        ),
      ],
    );
  }
}

/// One small summary tile (Pending / Done / Schedule).
class _StatTile extends StatelessWidget {
  final String label;
  final int count;
  final Color barColor;
  final Color backgroundColor;

  const _StatTile({
    required this.label,
    required this.count,
    required this.barColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 52,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        count.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Calls',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A slice of the donut chart.
class _Segment {
  final double value;
  final Color color;

  const _Segment(this.value, this.color);
}

/// Draws the donut chart without any external package.
class _DonutPainter extends CustomPainter {
  final List<_Segment> segments;
  final double progress; // 0..1 (animation)

  _DonutPainter({required this.segments, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<double>(0, (sum, s) => sum + s.value);
    if (total <= 0) return;

    final stroke = size.width * 0.16;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    // Soft grey circle in the middle (as in the design).
    canvas.drawCircle(
      center,
      size.width * 0.24,
      Paint()..color = const Color(0xFFF1F3F6),
    );

    const gap = 0.07; // small space between slices (radians)
    double start = -math.pi / 2; // start at the top

    for (final segment in segments) {
      final sweep = segment.value / total * 2 * math.pi * progress;
      final drawSweep = math.max(sweep - gap, 0.0);

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, start + gap / 2, drawSweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.segments != segments;
  }
}