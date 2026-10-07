import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../data/contact.dart';
import '../data/game_state.dart';
import '../theme/eclipse_theme.dart';
import 'house_detail_sheet.dart';
import 'location_permission_dialog.dart';

class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  Contact? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GameState.instance,
      builder: (context, child) {
        final state = GameState.instance;

        return CupertinoPageScaffold(
          backgroundColor: EclipseTheme.background,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: const Color(0xFF0D0D0E).withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.white.withValues(alpha: 0.08),
              ),
            ),
            middle: const Text(
              'Neighborhood Realm Map',
              style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.location_solid,
                color: CupertinoColors.white,
              ),
              onPressed: () => LocationPermissionDialog.show(context),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: const _MapGridPainter(),
                  ),
                ),
                Positioned.fill(
                  child: _buildInteractivePins(context, state),
                ),
                Positioned(
                  top: 14,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141416),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: CupertinoColors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.house_alt_fill,
                          color: CupertinoColors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your Estate: ${state.playerRealm} (Lv ${state.playerHouseLevel})',
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => LocationPermissionDialog.show(context),
                          child: const Text(
                            'Relocate',
                            style: TextStyle(
                              color: Color(0xFFA1A1A6),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedContact != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: _buildContactPreviewCard(context, _selectedContact!),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractivePins(BuildContext context, GameState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final contactsList = allContacts.toList();

        return Stack(
          children: [
            Positioned(
              left: w * 0.46,
              top: h * 0.44,
              child: _buildPlayerPin(context, state),
            ),
            for (int i = 0; i < math.min(18, contactsList.length); i++)
              ...[
                _buildContactPositionedPin(
                  context,
                  contactsList[i],
                  w,
                  h,
                  i,
                ),
              ],
          ],
        );
      },
    );
  }

  Widget _buildPlayerPin(BuildContext context, GameState state) {
    return GestureDetector(
      onTap: () {
        HouseDetailSheet.show(context, isPlayer: true);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF27272A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.white.withValues(alpha: 0.15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Text(
              'YOU • Lv ${state.playerHouseLevel}',
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          const Icon(
            CupertinoIcons.location_solid,
            color: CupertinoColors.white,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildContactPositionedPin(
    BuildContext context,
    Contact c,
    double w,
    double h,
    int index,
  ) {
    final angles = [
      0.3, 0.8, 1.4, 2.1, 2.7, 3.4, 4.1, 4.9, 5.6, 6.1,
      0.5, 1.1, 1.9, 2.4, 3.1, 3.8, 4.6, 5.2,
    ];
    final dists = [
      0.22, 0.32, 0.28, 0.38, 0.25, 0.35, 0.29, 0.36, 0.24, 0.33,
      0.18, 0.26, 0.37, 0.20, 0.34, 0.23, 0.39, 0.27,
    ];

    final angle = angles[index % angles.length];
    final dist = dists[index % dists.length];

    final x = (w * 0.48) + (w * dist * math.cos(angle)) - 25;
    final y = (h * 0.46) + (h * dist * math.sin(angle)) - 25;

    return Positioned(
      left: x.clamp(10, w - 80),
      top: y.clamp(70, h - 140),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedContact = c;
          });
          HouseDetailSheet.show(context, contact: c);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CupertinoColors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                '${c.firstName} • Lv ${c.houseLevel}',
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Icon(
              CupertinoIcons.house_fill,
              color: CupertinoColors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPreviewCard(BuildContext context, Contact c) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141416),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CupertinoColors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.avatarColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Center(
              child: Text(
                c.initials,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  c.fullName,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${c.houseTier.title} • ${c.locationName}',
                  style: const TextStyle(
                    color: Color(0xFFA1A1A6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            color: const Color(0xFF27272A),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () {
              HouseDetailSheet.show(context, contact: c);
            },
            child: const Text('View Estate', style: TextStyle(fontSize: 12, color: CupertinoColors.white)),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = CupertinoColors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    const step = 44.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final radarPaint = Paint()
      ..color = CupertinoColors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width * 0.5, size.height * 0.48);
    canvas.drawCircle(center, 90, radarPaint);
    canvas.drawCircle(center, 180, radarPaint);
    canvas.drawCircle(center, 270, radarPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
