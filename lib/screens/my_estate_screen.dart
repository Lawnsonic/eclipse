import 'package:flutter/cupertino.dart';
import '../data/game_state.dart';
import '../theme/eclipse_theme.dart';
import '../widgets/house_3d_viewer.dart';
import 'location_permission_dialog.dart';

class MyEstateScreen extends StatefulWidget {
  const MyEstateScreen({super.key});

  @override
  State<MyEstateScreen> createState() => _MyEstateScreenState();
}

class _MyEstateScreenState extends State<MyEstateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final List<_FloatingParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onForgeTap(TapDownDetails details) {
    GameState.instance.tapSolarForge();
    setState(() {
      _particles.add(
        _FloatingParticle(
          offset: details.localPosition,
          text: '+${3 * GameState.instance.comboMultiplier} EP',
          color: GameState.instance.comboMultiplier > 2
              ? const Color(0xFFF43F5E)
              : const Color(0xFFF59E0B),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          if (_particles.isNotEmpty) _particles.removeAt(0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GameState.instance,
      builder: (context, child) {
        final state = GameState.instance;
        final current = state.currentTier;
        final next = state.nextTier;

        return CupertinoPageScaffold(
          backgroundColor: EclipseTheme.background,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.9),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.white.withValues(alpha: 0.08),
              ),
            ),
            middle: const Text(
              'My 3D Estate & Solar Forge',
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.location_circle_fill,
                color: Color(0xFFF59E0B),
              ),
              onPressed: () => LocationPermissionDialog.show(context),
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                _buildHeaderStats(state),
                const SizedBox(height: 16),
                House3DViewer(tier: current, height: 280),
                const SizedBox(height: 16),
                _buildSolarForgeSection(state),
                const SizedBox(height: 16),
                _buildUpgradeCard(context, state, next),
                const SizedBox(height: 16),
                _buildActivityLog(state),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderStats(GameState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: EclipseTheme.glassCardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.sparkles,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eclipse Points',
                      style: TextStyle(
                        fontSize: 11,
                        color: EclipseTheme.textMuted,
                      ),
                    ),
                    Text(
                      '${state.eclipsePoints} EP',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 34,
            color: CupertinoColors.white.withValues(alpha: 0.1),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.phone_fill,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Call Points',
                      style: TextStyle(
                        fontSize: 11,
                        color: EclipseTheme.textMuted,
                      ),
                    ),
                    Text(
                      '${state.callPoints} CP',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolarForgeSection(GameState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1035), Color(0xFF451A03)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    CupertinoIcons.flame_fill,
                    color: Color(0xFFF59E0B),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'SOLAR FORGE 3D TAP',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: state.comboMultiplier > 1
                      ? const Color(0xFFF43F5E)
                      : CupertinoColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${state.comboMultiplier}x COMBO',
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Rapidly tap the glowing Eclipse Corona below to forge extra Eclipse Points!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CupertinoColors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTapDown: _onForgeTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = 1.0 + (0.08 * _pulseController.value);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (state.comboMultiplier > 2
                                      ? const Color(0xFFF43F5E)
                                      : const Color(0xFFF59E0B))
                                  .withValues(alpha: 0.6),
                              blurRadius: 36,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFEF3C7),
                        Color(0xFFF59E0B),
                        Color(0xFFD97706),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.sun_max_fill,
                      color: Color(0xFF451A03),
                      size: 46,
                    ),
                  ),
                ),
                for (final p in _particles)
                  Positioned(
                    left: p.offset.dx - 20,
                    top: p.offset.dy - 30,
                    child: Text(
                      p.text,
                      style: TextStyle(
                        color: p.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context, GameState state, dynamic next) {
    if (next == null) {
      return const SizedBox.shrink();
    }

    final hasEP = state.eclipsePoints >= next.baseCostEP;
    final hasCP = state.callPoints >= next.requiredCP;
    final canUpgrade = hasEP && hasCP;

    final epProgress = (state.eclipsePoints / next.baseCostEP).clamp(0.0, 1.0);
    final cpProgress = (state.callPoints / next.requiredCP).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: EclipseTheme.glassCardDecoration(borderColor: next.accentColor.withValues(alpha: 0.35)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NEXT UPGRADE: LV ${next.level} ${next.title.toUpperCase()}',
                style: TextStyle(
                  color: next.accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: next.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${next.dailyIncomeEP} EP/day',
                  style: TextStyle(
                    color: next.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            next.description,
            style: TextStyle(
              fontSize: 13,
              color: EclipseTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressBar('Eclipse Points', '${state.eclipsePoints} / ${next.baseCostEP} EP', epProgress, const Color(0xFFF59E0B)),
          const SizedBox(height: 12),
          _buildProgressBar('Call Points', '${state.callPoints} / ${next.requiredCP} CP', cpProgress, const Color(0xFF10B981)),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: canUpgrade
                  ? () {
                      final success = state.upgradeHouse();
                      if (success) {
                        showCupertinoDialog<void>(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            title: const Text('🎉 3D Estate Upgraded!'),
                            content: Text(
                              'Congratulations! Your estate is now Level ${next.level} ${next.title}!\nUnlocked: ${next.perkDescription}',
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('Awesome!'),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  : null,
              child: Text(
                canUpgrade
                    ? 'Upgrade 3D Estate Now'
                    : 'Need More Points (Call or Forge)',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String title, String ratio, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CupertinoColors.white)),
            Text(ratio, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 7,
            color: color.withValues(alpha: 0.15),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(color: color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLog(GameState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: EclipseTheme.glassCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT ACTIVITIES & REWARDS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: EclipseTheme.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          for (final a in state.activities.take(5))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a.icon, size: 14, color: const Color(0xFF38BDF8)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                          ),
                        ),
                        Text(
                          a.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: EclipseTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FloatingParticle {
  _FloatingParticle({
    required this.offset,
    required this.text,
    required this.color,
  });

  final Offset offset;
  final String text;
  final Color color;
}
