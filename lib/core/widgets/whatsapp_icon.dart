import 'package:flutter/material.dart';

/// WhatsApp-style logo (green speech bubble with a white phone),
/// drawn with code so no image or package is needed.
class WhatsAppIcon extends StatelessWidget {
  const WhatsAppIcon({
    super.key,
    this.size = 30,
    this.color = const Color(0xFF25D366),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _WhatsAppBubblePainter(color),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size * 0.04),
            child: Icon(
              Icons.call_rounded,
              size: size * 0.42,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatsAppBubblePainter extends CustomPainter {
  const _WhatsAppBubblePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final fill = Paint()..color = color;

    // Round bubble.
    canvas.drawCircle(Offset(s / 2, s / 2), s * 0.46, fill);

    // Small tail at the bottom-left.
    final tail = Path()
      ..moveTo(s * 0.16, s * 0.68)
      ..lineTo(s * 0.04, s * 0.97)
      ..lineTo(s * 0.36, s * 0.86)
      ..close();
    canvas.drawPath(tail, fill);

    // White ring inside the bubble.
    canvas.drawCircle(
      Offset(s / 2, s / 2),
      s * 0.33,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.045,
    );
  }

  @override
  bool shouldRepaint(covariant _WhatsAppBubblePainter oldDelegate) =>
      oldDelegate.color != color;
}