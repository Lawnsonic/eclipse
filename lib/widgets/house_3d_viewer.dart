import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../data/house_model.dart';
import '../theme/eclipse_theme.dart';

class House3DViewer extends StatefulWidget {
  const House3DViewer({
    super.key,
    required this.tier,
    this.height = 260,
    this.interactive = true,
  });

  final HouseTier tier;
  final double height;
  final bool interactive;

  @override
  State<House3DViewer> createState() => _House3DViewerState();
}

class _House3DViewerState extends State<House3DViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ambientController;

  double _yaw = 0.6; // Horizontal rotation
  double _pitch = 0.45; // Vertical elevation angle
  bool _autoRotate = true;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(() {
        if (_autoRotate && mounted) {
          setState(() {
            _yaw += 0.008;
            if (_yaw > 2 * math.pi) _yaw -= 2 * math.pi;
          });
        }
      });
    _ambientController.repeat();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.interactive) return;
    setState(() {
      _autoRotate = false;
      _yaw += details.delta.dx * 0.012;
      _pitch = (_pitch - details.delta.dy * 0.008).clamp(0.15, 0.85);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF070C18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: widget.tier.accentColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.tier.accentColor.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (_) => setState(() => _autoRotate = false),
                onPanUpdate: _onPanUpdate,
                child: CustomPaint(
                  painter: _House3DPainter(
                    tier: widget.tier,
                    yaw: _yaw,
                    pitch: _pitch,
                    animProgress: _ambientController.value,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B132B).withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.tier.accentColor.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.cube_box_fill,
                      size: 13,
                      color: widget.tier.accentColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '3D LV. ${widget.tier.level} • ${widget.tier.title.toUpperCase()}',
                      style: TextStyle(
                        color: widget.tier.accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: GestureDetector(
                onTap: () => setState(() => _autoRotate = !_autoRotate),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: _autoRotate
                        ? widget.tier.accentColor.withValues(alpha: 0.25)
                        : const Color(0xFF1E293B).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _autoRotate
                          ? widget.tier.accentColor
                          : EclipseTheme.cardBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.arrow_2_circlepath,
                        size: 12,
                        color: _autoRotate
                            ? widget.tier.accentColor
                            : EclipseTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _autoRotate ? '360° SPIN' : 'PAUSED',
                        style: TextStyle(
                          color: _autoRotate
                              ? widget.tier.accentColor
                              : EclipseTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: CupertinoColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.hand_draw_fill,
                      color: Color(0xFF94A3B8),
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Drag to rotate 3D view in real time',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.tier.accentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+${widget.tier.dailyIncomeEP} EP/day',
                        style: TextStyle(
                          color: widget.tier.accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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
}

class _House3DPainter extends CustomPainter {
  _House3DPainter({
    required this.tier,
    required this.yaw,
    required this.pitch,
    required this.animProgress,
  });

  final HouseTier tier;
  final double yaw;
  final double pitch;
  final double animProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.54;

    _drawBackgroundGlow(canvas, size, Offset(cx, cy));
    _draw3DPlinth(canvas, cx, cy);

    switch (tier.level) {
      case 1:
        _draw3DHut(canvas, cx, cy);
        break;
      case 2:
        _draw3DCabin(canvas, cx, cy);
        break;
      case 3:
        _draw3DBungalow(canvas, cx, cy);
        break;
      case 4:
        _draw3DDuplex(canvas, cx, cy);
        break;
      case 5:
        _draw3DCribPenthouse(canvas, cx, cy);
        break;
      case 6:
        _draw3DCoastalVilla(canvas, cx, cy);
        break;
      case 7:
        _draw3DHilltopMansion(canvas, cx, cy);
        break;
      case 8:
        _draw3DPalatialChateau(canvas, cx, cy);
        break;
      case 9:
        _draw3DCyberCitadel(canvas, cx, cy);
        break;
      case 10:
        _draw3DEclipseSanctuary(canvas, cx, cy);
        break;
      default:
        _draw3DHut(canvas, cx, cy);
    }
  }

  void _drawBackgroundGlow(Canvas canvas, Size size, Offset center) {
    final radial = RadialGradient(
      colors: [
        tier.accentColor.withValues(alpha: 0.35),
        tier.accentColor.withValues(alpha: 0.08),
        CupertinoColors.transparent,
      ],
      radius: 0.6,
    );
    final paint = Paint()
      ..shader = radial.createShader(Rect.fromCircle(center: center, radius: 150));
    canvas.drawCircle(center, 150, paint);
  }

  // 3D Isometric Projection helper
  Offset _project(double x, double y, double z, double cx, double cy) {
    // 3D rotation around Y axis (yaw)
    final cosY = math.cos(yaw);
    final sinY = math.sin(yaw);
    final rotX = x * cosY - y * sinY;
    final rotY = x * sinY + y * cosY;

    // Projection with pitch tilt
    final cosP = math.cos(pitch);
    final sinP = math.sin(pitch);
    final screenX = cx + rotX;
    final screenY = cy + (rotY * sinP) - (z * cosP);
    return Offset(screenX, screenY);
  }

  void _draw3DPlinth(Canvas canvas, double cx, double cy) {
    const r = 74.0;
    const h = 14.0;
    const segments = 8;

    final topPoints = <Offset>[];
    for (int i = 0; i < segments; i++) {
      final angle = (i * 2 * math.pi) / segments;
      final px = r * math.cos(angle);
      final py = r * math.sin(angle);
      topPoints.add(_project(px, py, 0, cx, cy));
    }

    // Draw sides
    for (int i = 0; i < segments; i++) {
      final next = (i + 1) % segments;
      final angle = (i * 2 * math.pi) / segments;
      final px1 = r * math.cos(angle);
      final py1 = r * math.sin(angle);
      final px2 = r * math.cos((next * 2 * math.pi) / segments);
      final py2 = r * math.sin((next * 2 * math.pi) / segments);

      final p1 = _project(px1, py1, 0, cx, cy);
      final p2 = _project(px2, py2, 0, cx, cy);
      final b1 = _project(px1, py1, -h, cx, cy);
      final b2 = _project(px2, py2, -h, cx, cy);

      final sidePath = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(b2.dx, b2.dy)
        ..lineTo(b1.dx, b1.dy)
        ..close();

      final shade = (0.2 + 0.3 * math.sin(angle + yaw)).clamp(0.1, 0.6);
      canvas.drawPath(
        sidePath,
        Paint()..color = const Color(0xFF1E293B).withValues(alpha: shade),
      );
    }

    // Draw top polygon
    final topPath = Path()..moveTo(topPoints[0].dx, topPoints[0].dy);
    for (int i = 1; i < segments; i++) {
      topPath.lineTo(topPoints[i].dx, topPoints[i].dy);
    }
    topPath.close();

    final plinthPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1E293B),
          const Color(0xFF0F172A),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 80));
    canvas.drawPath(topPath, plinthPaint);

    final edgePaint = Paint()
      ..color = tier.accentColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(topPath, edgePaint);
  }

  void _draw3DCube(
    Canvas canvas, {
    required double cx,
    required double cy,
    required double x,
    required double y,
    required double z,
    required double w,
    required double d,
    required double h,
    required Color color,
    Color? topColor,
    bool glow = false,
  }) {
    final p0 = _project(x - w / 2, y - d / 2, z, cx, cy);
    final p1 = _project(x + w / 2, y - d / 2, z, cx, cy);
    final p2 = _project(x + w / 2, y + d / 2, z, cx, cy);
    final p3 = _project(x - w / 2, y + d / 2, z, cx, cy);

    final p4 = _project(x - w / 2, y - d / 2, z + h, cx, cy);
    final p5 = _project(x + w / 2, y - d / 2, z + h, cx, cy);
    final p6 = _project(x + w / 2, y + d / 2, z + h, cx, cy);
    final p7 = _project(x - w / 2, y + d / 2, z + h, cx, cy);

    // Front/sides
    _drawQuad(canvas, p0, p1, p5, p4, color.withValues(alpha: 0.85));
    _drawQuad(canvas, p1, p2, p6, p5, color.withValues(alpha: 0.7));
    _drawQuad(canvas, p2, p3, p7, p6, color.withValues(alpha: 0.6));
    _drawQuad(canvas, p3, p0, p4, p7, color.withValues(alpha: 0.75));

    // Top
    _drawQuad(canvas, p4, p5, p6, p7, topColor ?? color.withValues(alpha: 0.95));

    if (glow) {
      final border = Path()
        ..moveTo(p4.dx, p4.dy)
        ..lineTo(p5.dx, p5.dy)
        ..lineTo(p6.dx, p6.dy)
        ..lineTo(p7.dx, p7.dy)
        ..close();
      canvas.drawPath(
        border,
        Paint()
          ..color = tier.accentColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
    }
  }

  void _drawQuad(
    Canvas canvas,
    Offset a,
    Offset b,
    Offset c,
    Offset d,
    Color color,
  ) {
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(c.dx, c.dy)
      ..lineTo(d.dx, d.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _draw3DHut(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 0,
      w: 42,
      d: 42,
      h: 24,
      color: const Color(0xFF78350F),
      topColor: const Color(0xFF92400E),
    );

    // 3D Roof Apex
    final apex = _project(0, 0, 48, cx, cy);
    final r1 = _project(-25, -25, 24, cx, cy);
    final r2 = _project(25, -25, 24, cx, cy);
    final r3 = _project(25, 25, 24, cx, cy);
    final r4 = _project(-25, 25, 24, cx, cy);

    _drawTriangle(canvas, r1, r2, apex, const Color(0xFFB45309));
    _drawTriangle(canvas, r2, r3, apex, const Color(0xFF92400E));
    _drawTriangle(canvas, r3, r4, apex, const Color(0xFF78350F));
    _drawTriangle(canvas, r4, r1, apex, const Color(0xFFA16207));

    // Campfire beside hut
    final fireBase = _project(38, 12, 0, cx, cy);
    canvas.drawCircle(fireBase, 7, Paint()..color = const Color(0xFF44403C));
    final flameRadius = 6 + 3 * math.sin(animProgress * 8 * math.pi);
    canvas.drawCircle(
      Offset(fireBase.dx, fireBase.dy - 6),
      flameRadius,
      Paint()..color = const Color(0xFFF59E0B),
    );
  }

  void _draw3DCabin(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 0,
      w: 52,
      d: 42,
      h: 30,
      color: const Color(0xFF854D0E),
      topColor: const Color(0xFFA16207),
    );

    // 3D Gabled Roof
    final ridge1 = _project(-26, 0, 50, cx, cy);
    final ridge2 = _project(26, 0, 50, cx, cy);
    final e1 = _project(-28, -23, 30, cx, cy);
    final e2 = _project(28, -23, 30, cx, cy);
    final e3 = _project(28, 23, 30, cx, cy);
    final e4 = _project(-28, 23, 30, cx, cy);

    _drawQuad(canvas, e1, e2, ridge2, ridge1, const Color(0xFF451A03));
    _drawQuad(canvas, e3, e4, ridge1, ridge2, const Color(0xFF78350F));
    _drawTriangle(canvas, e2, e3, ridge2, const Color(0xFF92400E));
    _drawTriangle(canvas, e4, e1, ridge1, const Color(0xFF713F12));

    // 3D Chimney with smoke
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 16,
      y: 10,
      z: 28,
      w: 10,
      d: 10,
      h: 28,
      color: const Color(0xFF57534E),
    );
    final smokePoint = _project(16, 10, 60, cx, cy);
    canvas.drawCircle(
      smokePoint,
      5,
      Paint()..color = CupertinoColors.white.withValues(alpha: 0.35),
    );
  }

  void _draw3DBungalow(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 0,
      w: 64,
      d: 50,
      h: 26,
      color: const Color(0xFFE2E8F0),
      topColor: const Color(0xFF0284C7),
      glow: true,
    );
    // Solar roof cap
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 26,
      w: 66,
      d: 52,
      h: 6,
      color: const Color(0xFF0369A1),
      topColor: const Color(0xFF38BDF8),
    );
  }

  void _draw3DDuplex(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: -12,
      y: 0,
      z: 0,
      w: 44,
      d: 46,
      h: 46,
      color: const Color(0xFF64748B),
      topColor: const Color(0xFF94A3B8),
      glow: true,
    );
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 18,
      y: 4,
      z: 0,
      w: 36,
      d: 40,
      h: 34,
      color: const Color(0xFF475569),
      topColor: const Color(0xFFCBD5E1),
    );

    // 3D Pool
    final poolCenter = _project(22, -26, 0, cx, cy);
    canvas.drawCircle(poolCenter, 14, Paint()..color = const Color(0xFF06B6D4));
    final ripple = 1.0 + 0.3 * math.sin(animProgress * 6 * math.pi);
    canvas.drawCircle(
      poolCenter,
      12 * ripple,
      Paint()
        ..color = CupertinoColors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _draw3DCribPenthouse(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 0,
      w: 42,
      d: 42,
      h: 75,
      color: const Color(0xFF1E1B4B),
      topColor: const Color(0xFF4338CA),
      glow: true,
    );

    // Neon penthouse cap
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 75,
      w: 34,
      d: 34,
      h: 16,
      color: const Color(0xFF831843),
      topColor: const Color(0xFFEC4899),
      glow: true,
    );

    // Rooftop jacuzzi
    final jacuzzi = _project(6, 6, 91, cx, cy);
    canvas.drawCircle(jacuzzi, 6, Paint()..color = const Color(0xFF06B6D4));
  }

  void _draw3DCoastalVilla(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 0,
      w: 66,
      d: 48,
      h: 36,
      color: const Color(0xFFFFFBEB),
      topColor: const Color(0xFFEA580C),
    );

    // Terracotta roof
    final apex = _project(0, 0, 56, cx, cy);
    final r1 = _project(-35, -26, 36, cx, cy);
    final r2 = _project(35, -26, 36, cx, cy);
    final r3 = _project(35, 26, 36, cx, cy);
    final r4 = _project(-35, 26, 36, cx, cy);

    _drawTriangle(canvas, r1, r2, apex, const Color(0xFFC2410C));
    _drawTriangle(canvas, r2, r3, apex, const Color(0xFFEA580C));
    _drawTriangle(canvas, r3, r4, apex, const Color(0xFFF97316));
    _drawTriangle(canvas, r4, r1, apex, const Color(0xFF9A3412));

    // Infinity pool
    final pCenter = _project(0, 34, 0, cx, cy);
    canvas.drawCircle(pCenter, 18, Paint()..color = const Color(0xFF0D9488));
  }

  void _draw3DHilltopMansion(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 0,
      w: 56,
      d: 44,
      h: 46,
      color: const Color(0xFFF1F5F9),
      topColor: const Color(0xFF64748B),
    );
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: -36,
      y: 0,
      z: 0,
      w: 30,
      d: 38,
      h: 34,
      color: const Color(0xFFE2E8F0),
    );
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 36,
      y: 0,
      z: 0,
      w: 30,
      d: 38,
      h: 34,
      color: const Color(0xFFE2E8F0),
    );

    // 3D Helipad
    final heliCenter = _project(42, -26, 0, cx, cy);
    canvas.drawCircle(heliCenter, 13, Paint()..color = const Color(0xFF334155));
    final ringPulse = 0.5 + 0.5 * math.sin(animProgress * 4 * math.pi);
    canvas.drawCircle(
      heliCenter,
      13,
      Paint()
        ..color = const Color(0xFFF59E0B).withValues(alpha: ringPulse)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _draw3DPalatialChateau(Canvas canvas, double cx, double cy) {
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: 0,
      w: 62,
      d: 48,
      h: 48,
      color: const Color(0xFFFEF9C3),
      topColor: const Color(0xFFCA8A04),
    );

    // 3D Golden Domes
    final domePoint = _project(0, 0, 52, cx, cy);
    canvas.drawCircle(domePoint, 18, Paint()..color = const Color(0xFFEAB308));
    final spirePoint = _project(0, 0, 80, cx, cy);
    canvas.drawLine(
      domePoint,
      spirePoint,
      Paint()
        ..color = const Color(0xFFCA8A04)
        ..strokeWidth = 3,
    );
  }

  void _draw3DCyberCitadel(Canvas canvas, double cx, double cy) {
    final floatZ = 12 + 6 * math.sin(animProgress * 2 * math.pi);

    // Floating central core
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: floatZ,
      w: 42,
      d: 42,
      h: 60,
      color: const Color(0xFF1E1035),
      topColor: const Color(0xFF7C3AED),
      glow: true,
    );

    // 4 Orbiting 3D monoliths
    for (int i = 0; i < 4; i++) {
      final angle = yaw + (i * math.pi / 2) + (animProgress * 2 * math.pi);
      final mX = 52 * math.cos(angle);
      final mY = 52 * math.sin(angle);
      _draw3DCube(
        canvas,
        cx: cx,
        cy: cy,
        x: mX,
        y: mY,
        z: floatZ + 8,
        w: 12,
        d: 12,
        h: 34,
        color: const Color(0xFF8B5CF6),
        topColor: const Color(0xFFA78BFA),
        glow: true,
      );
    }
  }

  void _draw3DEclipseSanctuary(Canvas canvas, double cx, double cy) {
    final floatZ = 20 + 8 * math.sin(animProgress * 2 * math.pi);

    // Central astral palace
    _draw3DCube(
      canvas,
      cx: cx,
      cy: cy,
      x: 0,
      y: 0,
      z: floatZ,
      w: 48,
      d: 48,
      h: 64,
      color: const Color(0xFF4C0519),
      topColor: const Color(0xFFF43F5E),
      glow: true,
    );

    // 3D Concentric Solar Eclipse Rings
    final ringCenter = _project(0, 0, floatZ + 32, cx, cy);
    final ringRadius = 70.0;
    final ringPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(
      Rect.fromCenter(
        center: ringCenter,
        width: ringRadius * 2,
        height: ringRadius * 0.9 * math.sin(pitch),
      ),
      ringPaint,
    );
  }

  void _drawTriangle(Canvas canvas, Offset a, Offset b, Offset c, Color color) {
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(c.dx, c.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _House3DPainter oldDelegate) {
    return oldDelegate.yaw != yaw ||
        oldDelegate.pitch != pitch ||
        oldDelegate.animProgress != animProgress ||
        oldDelegate.tier.level != tier.level;
  }
}
