import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../data/house_model.dart';

class HouseVisualWidget extends StatefulWidget {
  const HouseVisualWidget({
    super.key,
    required this.tier,
    this.height = 220,
    this.isInteractive = false,
  });

  final HouseTier tier;
  final double height;
  final bool isInteractive;

  @override
  State<HouseVisualWidget> createState() => _HouseVisualWidgetState();
}

class _HouseVisualWidgetState extends State<HouseVisualWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.tier.gradientColors,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.tier.accentColor.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HousePainter(
                      level: widget.tier.level,
                      progress: _animController.value,
                      accentColor: widget.tier.accentColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.tier.accentColor.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.shield_fill,
                          size: 13,
                          color: widget.tier.accentColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'LV. ${widget.tier.level} • ${widget.tier.category.toUpperCase()}',
                          style: TextStyle(
                            color: widget.tier.accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: CupertinoColors.white.withValues(alpha: 0.15),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.tier.title,
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.tier.perkDescription,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: CupertinoColors.white.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.tier.accentColor.withValues(
                              alpha: 0.25,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${widget.tier.dailyIncomeEP} EP/day',
                            style: TextStyle(
                              color: widget.tier.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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
      },
    );
  }
}

class _HousePainter extends CustomPainter {
  _HousePainter({
    required this.level,
    required this.progress,
    required this.accentColor,
  });

  final int level;
  final double progress;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSkyDetails(canvas, size);
    _drawGround(canvas, size);

    switch (level) {
      case 1:
        _drawLevel1Hut(canvas, size);
        break;
      case 2:
        _drawLevel2Cabin(canvas, size);
        break;
      case 3:
        _drawLevel3Bungalow(canvas, size);
        break;
      case 4:
        _drawLevel4Duplex(canvas, size);
        break;
      case 5:
        _drawLevel5Penthouse(canvas, size);
        break;
      case 6:
        _drawLevel6Villa(canvas, size);
        break;
      case 7:
        _drawLevel7Mansion(canvas, size);
        break;
      case 8:
        _drawLevel8Chateau(canvas, size);
        break;
      case 9:
        _drawLevel9CyberCitadel(canvas, size);
        break;
      case 10:
        _drawLevel10EclipseSanctuary(canvas, size);
        break;
      default:
        _drawLevel1Hut(canvas, size);
    }
  }

  void _drawSkyDetails(Canvas canvas, Size size) {
    final starPaint = Paint()..color = CupertinoColors.white.withValues(alpha: 0.6);
    final random = math.Random(level * 42);
    for (int i = 0; i < 28; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * (size.height * 0.55);
      final twinkle = 0.4 + 0.6 * math.sin((progress * 2 * math.pi) + i);
      starPaint.color = CupertinoColors.white.withValues(alpha: twinkle.clamp(0.2, 0.9));
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5 + 0.5, starPaint);
    }

    if (level == 10) {
      final coronaPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFF43F5E).withValues(alpha: 0.8),
            const Color(0xFFF59E0B).withValues(alpha: 0.4),
            CupertinoColors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.32), radius: 65));
      canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.32), 65, coronaPaint);

      final sunPaint = Paint()..color = CupertinoColors.black;
      canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.32), 32, sunPaint);

      final ringPaint = Paint()
        ..color = const Color(0xFFFCD34D).withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.32), 34, ringPaint);
    }
  }

  void _drawGround(Canvas canvas, Size size) {
    final groundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accentColor.withValues(alpha: 0.25),
          CupertinoColors.black.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.68, size.width, size.height * 0.32));

    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.68, size.width * 0.65, size.height * 0.71)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.73, size.width, size.height * 0.70)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, groundPaint);
  }

  void _drawLevel1Hut(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    final hutPath = Path()
      ..moveTo(cx - 38, cy)
      ..lineTo(cx, cy - 42)
      ..lineTo(cx + 38, cy)
      ..close();
    final hutPaint = Paint()..color = const Color(0xFF78350F);
    canvas.drawPath(hutPath, hutPaint);

    final doorPath = Path()
      ..moveTo(cx - 10, cy)
      ..lineTo(cx - 10, cy - 20)
      ..lineTo(cx + 10, cy - 20)
      ..lineTo(cx + 10, cy)
      ..close();
    canvas.drawPath(doorPath, Paint()..color = const Color(0xFF291003));

    final fireX = cx + 55;
    final fireY = cy + 2;
    canvas.drawCircle(Offset(fireX, fireY), 6, Paint()..color = const Color(0xFF57534E));
    final flicker = 6 + 3 * math.sin(progress * 8 * math.pi);
    canvas.drawCircle(Offset(fireX, fireY - 4), flicker, Paint()..color = const Color(0xFFF97316));
    canvas.drawCircle(Offset(fireX, fireY - 6), flicker * 0.6, Paint()..color = const Color(0xFFFDE047));
  }

  void _drawLevel2Cabin(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    canvas.drawRect(
      Rect.fromLTWH(cx - 45, cy - 35, 90, 35),
      Paint()..color = const Color(0xFF92400E),
    );

    final roof = Path()
      ..moveTo(cx - 55, cy - 35)
      ..lineTo(cx, cy - 56)
      ..lineTo(cx + 55, cy - 35)
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFF451A03));

    canvas.drawRect(Rect.fromLTWH(cx + 22, cy - 62, 12, 28), Paint()..color = const Color(0xFF57534E));
    final smokeOffset = 5 * math.sin(progress * 4 * math.pi);
    canvas.drawCircle(Offset(cx + 28 + smokeOffset, cy - 70), 5, Paint()..color = CupertinoColors.white.withValues(alpha: 0.35));
    canvas.drawCircle(Offset(cx + 30 + smokeOffset * 1.5, cy - 80), 7, Paint()..color = CupertinoColors.white.withValues(alpha: 0.2));

    canvas.drawRect(Rect.fromLTWH(cx - 30, cy - 26, 16, 16), Paint()..color = const Color(0xFFFEF08A));
    canvas.drawRect(Rect.fromLTWH(cx + 5, cy - 26, 16, 16), Paint()..color = const Color(0xFFFEF08A));
    canvas.drawRect(Rect.fromLTWH(cx - 8, cy - 18, 14, 18), Paint()..color = const Color(0xFF3F1B05));
  }

  void _drawLevel3Bungalow(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 60, cy - 36, 120, 36), const Radius.circular(3)),
      Paint()..color = const Color(0xFFE2E8F0),
    );

    final roof = Path()
      ..moveTo(cx - 70, cy - 36)
      ..lineTo(cx, cy - 54)
      ..lineTo(cx + 70, cy - 36)
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFF334155));

    final solarPaint = Paint()..color = const Color(0xFF0284C7).withValues(alpha: 0.7);
    canvas.drawRect(Rect.fromLTWH(cx - 35, cy - 50, 70, 10), solarPaint);

    canvas.drawRect(Rect.fromLTWH(cx - 48, cy - 28, 30, 20), Paint()..color = const Color(0xFF93C5FD).withValues(alpha: 0.8));
    canvas.drawRect(Rect.fromLTWH(cx + 18, cy - 28, 30, 20), Paint()..color = const Color(0xFF93C5FD).withValues(alpha: 0.8));
    canvas.drawRect(Rect.fromLTWH(cx - 8, cy - 28, 16, 28), Paint()..color = const Color(0xFF0F172A));
  }

  void _drawLevel4Duplex(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    canvas.drawRect(Rect.fromLTWH(cx - 65, cy - 58, 70, 58), Paint()..color = const Color(0xFFCBD5E1));
    canvas.drawRect(Rect.fromLTWH(cx + 5, cy - 48, 60, 48), Paint()..color = const Color(0xFFE2E8F0));

    canvas.drawRect(Rect.fromLTWH(cx - 70, cy - 62, 78, 5), Paint()..color = const Color(0xFF475569));
    canvas.drawRect(Rect.fromLTWH(cx + 2, cy - 52, 66, 5), Paint()..color = const Color(0xFF475569));

    canvas.drawRect(Rect.fromLTWH(cx - 55, cy - 52, 22, 16), Paint()..color = const Color(0xFF818CF8));
    canvas.drawRect(Rect.fromLTWH(cx - 24, cy - 52, 22, 16), Paint()..color = const Color(0xFF818CF8));

    final poolRect = Rect.fromLTWH(cx + 15, cy - 6, 45, 12);
    canvas.drawRRect(RRect.fromRectAndRadius(poolRect, const Radius.circular(6)), Paint()..color = const Color(0xFF06B6D4));
    final shimmer = 0.5 + 0.5 * math.sin(progress * 6 * math.pi);
    canvas.drawCircle(Offset(cx + 35, cy), 4 * shimmer, Paint()..color = CupertinoColors.white.withValues(alpha: 0.6));
  }

  void _drawLevel5Penthouse(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    final b1 = Rect.fromLTWH(cx - 70, cy - 70, 40, 70);
    final b2 = Rect.fromLTWH(cx - 25, cy - 90, 50, 90);
    final b3 = Rect.fromLTWH(cx + 30, cy - 60, 40, 60);

    canvas.drawRect(b1, Paint()..color = const Color(0xFF1E1B4B));
    canvas.drawRect(b2, Paint()..color = const Color(0xFF31103F));
    canvas.drawRect(b3, Paint()..color = const Color(0xFF1E1B4B));

    final neonPaint = Paint()
      ..color = const Color(0xFFEC4899)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRect(b2, neonPaint);

    final cyanPaint = Paint()
      ..color = const Color(0xFF06B6D4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(cx - 25, cy - 90), Offset(cx + 25, cy - 90), cyanPaint);

    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 3; col++) {
        final wX = cx - 18 + (col * 14.0);
        final wY = cy - 80 + (row * 14.0);
        final lit = (row + col + (progress * 5).toInt()) % 3 == 0;
        canvas.drawRect(
          Rect.fromLTWH(wX, wY, 8, 8),
          Paint()..color = lit ? const Color(0xFFF472B6) : const Color(0xFF4A154B),
        );
      }
    }
  }

  void _drawLevel6Villa(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    canvas.drawRect(Rect.fromLTWH(cx - 70, cy - 50, 140, 50), Paint()..color = const Color(0xFFFFFBEB));

    final roof = Path()
      ..moveTo(cx - 78, cy - 50)
      ..lineTo(cx, cy - 72)
      ..lineTo(cx + 78, cy - 50)
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFFEA580C));

    for (int i = 0; i < 5; i++) {
      final colX = cx - 55 + (i * 27.5);
      canvas.drawRect(Rect.fromLTWH(colX, cy - 40, 8, 40), Paint()..color = const Color(0xFFFEF3C7));
    }

    final pool = Rect.fromLTWH(cx - 60, cy - 4, 120, 14);
    canvas.drawRRect(RRect.fromRectAndRadius(pool, const Radius.circular(7)), Paint()..color = const Color(0xFF0D9488));
  }

  void _drawLevel7Mansion(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    canvas.drawRect(Rect.fromLTWH(cx - 35, cy - 65, 70, 65), Paint()..color = const Color(0xFFF1F5F9));
    canvas.drawRect(Rect.fromLTWH(cx - 85, cy - 48, 50, 48), Paint()..color = const Color(0xFFE2E8F0));
    canvas.drawRect(Rect.fromLTWH(cx + 35, cy - 48, 50, 48), Paint()..color = const Color(0xFFE2E8F0));

    final pediment = Path()
      ..moveTo(cx - 40, cy - 65)
      ..lineTo(cx, cy - 82)
      ..lineTo(cx + 40, cy - 65)
      ..close();
    canvas.drawPath(pediment, Paint()..color = const Color(0xFF64748B));

    final heliCircle = Offset(cx + 60, cy - 5);
    canvas.drawCircle(heliCircle, 12, Paint()..color = const Color(0xFF334155));
    final ringPulse = 0.5 + 0.5 * math.sin(progress * 4 * math.pi);
    canvas.drawCircle(heliCircle, 12, Paint()..color = const Color(0xFFF59E0B).withValues(alpha: ringPulse)..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _drawLevel8Chateau(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.65;

    canvas.drawRect(Rect.fromLTWH(cx - 65, cy - 60, 130, 60), Paint()..color = const Color(0xFFFEF9C3));

    canvas.drawCircle(Offset(cx, cy - 60), 28, Paint()..color = const Color(0xFFEAB308));
    final spire = Path()
      ..moveTo(cx - 4, cy - 88)
      ..lineTo(cx, cy - 105)
      ..lineTo(cx + 4, cy - 88)
      ..close();
    canvas.drawPath(spire, Paint()..color = const Color(0xFFCA8A04));

    canvas.drawRect(Rect.fromLTWH(cx - 75, cy - 75, 20, 75), Paint()..color = const Color(0xFFFEF08A));
    canvas.drawRect(Rect.fromLTWH(cx + 55, cy - 75, 20, 75), Paint()..color = const Color(0xFFFEF08A));
  }

  void _drawLevel9CyberCitadel(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.62;

    final floatOffset = 6 * math.sin(progress * 2 * math.pi);

    final citadel = Path()
      ..moveTo(cx - 40, cy + floatOffset)
      ..lineTo(cx - 20, cy - 75 + floatOffset)
      ..lineTo(cx + 20, cy - 75 + floatOffset)
      ..lineTo(cx + 40, cy + floatOffset)
      ..lineTo(cx, cy + 20 + floatOffset)
      ..close();
    canvas.drawPath(citadel, Paint()..color = const Color(0xFF1E1035));

    final shieldPaint = Paint()
      ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(Offset(cx, cy - 25 + floatOffset), 58, shieldPaint);

    final m1 = Offset(cx - 65, cy - 20 - floatOffset);
    final m2 = Offset(cx + 65, cy - 20 - floatOffset);
    canvas.drawRect(Rect.fromCenter(center: m1, width: 14, height: 42), Paint()..color = const Color(0xFF7C3AED));
    canvas.drawRect(Rect.fromCenter(center: m2, width: 14, height: 42), Paint()..color = const Color(0xFF7C3AED));
  }

  void _drawLevel10EclipseSanctuary(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.52;

    final ringAngle = progress * 2 * math.pi;
    final ringPaint = Paint()
      ..color = const Color(0xFFF43F5E).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 15), width: 160, height: 45),
      ringPaint,
    );

    final palace = Path()
      ..moveTo(cx - 50, cy + 18)
      ..lineTo(cx - 30, cy - 45)
      ..lineTo(cx, cy - 80)
      ..lineTo(cx + 30, cy - 45)
      ..lineTo(cx + 50, cy + 18)
      ..lineTo(cx, cy + 32)
      ..close();

    final palacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFF1F2),
          const Color(0xFFFB7185),
          const Color(0xFF881337),
        ],
      ).createShader(Rect.fromLTWH(cx - 50, cy - 80, 100, 112));

    canvas.drawPath(palace, palacePaint);

    final orbX = cx + 80 * math.cos(ringAngle);
    final orbY = (cy + 15) + 22 * math.sin(ringAngle);
    canvas.drawCircle(Offset(orbX, orbY), 6, Paint()..color = const Color(0xFFFDE047));
  }

  @override
  bool shouldRepaint(covariant _HousePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.level != level;
  }
}
