import 'package:flutter/cupertino.dart';
import '../data/contact.dart';
import '../data/game_state.dart';
import '../widgets/house_3d_viewer.dart';
import 'call_screen.dart';
import 'chat_screen.dart';
import 'location_permission_dialog.dart';

class HouseDetailSheet extends StatelessWidget {
  const HouseDetailSheet({
    super.key,
    this.contact,
    this.isPlayerEstate = false,
  });

  final Contact? contact;
  final bool isPlayerEstate;

  static void show(BuildContext context, {Contact? contact, bool isPlayer = false}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => HouseDetailSheet(
        contact: contact,
        isPlayerEstate: isPlayer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GameState.instance,
      builder: (context, child) {
        final tier = isPlayerEstate
            ? GameState.instance.currentTier
            : contact!.houseTier;
        final title = isPlayerEstate
            ? 'My Estate Sanctuary'
            : '${contact!.fullName}\'s Estate';
        final location = isPlayerEstate
            ? GameState.instance.playerRealm
            : contact!.locationName;

        return Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Color(0xFF141416),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF27272A),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.location_solid,
                                size: 12,
                                color: Color(0xFFA1A1A6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFA1A1A6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.clear_circled_solid, color: Color(0xFF71717A)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    House3DViewer(
                      tier: tier,
                      height: 270,
                      interactive: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tier.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFA1A1A6),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: CupertinoColors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                CupertinoIcons.sparkles,
                                color: CupertinoColors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'ARCHITECTURAL PERK',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tier.perkDescription,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ESTATE FEATURES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA1A1A6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...tier.features.map(
                      (f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.checkmark_alt_circle_fill,
                              color: CupertinoColors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              f,
                              style: const TextStyle(fontSize: 14, color: CupertinoColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isPlayerEstate) ...[
                      _buildPlayerUpgradeSection(context),
                    ] else ...[
                      _buildContactInteractionButtons(context),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactInteractionButtons(BuildContext context) {
    final isBlessed = contact!.hasBeenBlessedToday;
    return Column(
      children: [
        CupertinoButton(
          color: const Color(0xFF27272A),
          borderRadius: BorderRadius.circular(14),
          onPressed: isBlessed
              ? null
              : () {
                  GameState.instance.blessContact(contact!);
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.sparkles, color: CupertinoColors.white),
              const SizedBox(width: 8),
              Text(
                isBlessed
                    ? 'Blessed Today (+45 EP Claimed)'
                    : 'Send Solar Blessing (+45 EP)',
                style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: const Color(0xFF1F1F22),
                borderRadius: BorderRadius.circular(14),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => CallScreen(contact: contact!),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.phone_fill, size: 18, color: CupertinoColors.white),
                    SizedBox(width: 6),
                    Text('Call (Earn CP)', style: TextStyle(color: CupertinoColors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CupertinoButton(
                color: const Color(0xFF1F1F22),
                borderRadius: BorderRadius.circular(14),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => ChatScreen(contact: contact!),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.chat_bubble_fill, size: 18, color: CupertinoColors.white),
                    SizedBox(width: 6),
                    Text('Chat', style: TextStyle(color: CupertinoColors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerUpgradeSection(BuildContext context) {
    final next = GameState.instance.nextTier;
    if (next == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CupertinoColors.white.withValues(alpha: 0.2)),
        ),
        child: const Center(
          child: Text(
            '🌟 MAX LEVEL ACHIEVED • Eclipse Celestial Sovereign!',
            style: TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final hasEnoughEP = GameState.instance.eclipsePoints >= next.baseCostEP;
    final hasEnoughCP = GameState.instance.callPoints >= next.requiredCP;
    final canUpgrade = hasEnoughEP && hasEnoughCP;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'UPGRADE TO LV ${next.level}: ${next.title.toUpperCase()}',
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF27272A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Massive Upgrade',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            next.description,
            style: const TextStyle(fontSize: 13, color: Color(0xFFA1A1A6)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _RequirementBadge(
                  label: 'Eclipse Points',
                  current: GameState.instance.eclipsePoints,
                  required: next.baseCostEP,
                  icon: CupertinoIcons.sparkles,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RequirementBadge(
                  label: 'Call Points',
                  current: GameState.instance.callPoints,
                  required: next.requiredCP,
                  icon: CupertinoIcons.phone_fill,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: canUpgrade ? CupertinoColors.white : const Color(0xFF27272A),
              borderRadius: BorderRadius.circular(14),
              onPressed: canUpgrade
                  ? () {
                      final success = GameState.instance.upgradeHouse();
                      if (success) {
                        showCupertinoDialog<void>(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            title: const Text('🎉 Estate Upgraded!'),
                            content: Text(
                              'Congratulations! Your estate is now a Level ${next.level} ${next.title}!\nUnlocked: ${next.perkDescription}',
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
                    ? 'Upgrade Estate (${next.baseCostEP} EP + ${next.requiredCP} CP)'
                    : 'Insufficient Points to Upgrade',
                style: TextStyle(
                  color: canUpgrade ? CupertinoColors.black : const Color(0xFF71717A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                LocationPermissionDialog.show(context);
              },
              child: const Text(
                '📍 Relocate Realm Placement',
                style: TextStyle(fontSize: 13, color: Color(0xFFA1A1A6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementBadge extends StatelessWidget {
  const _RequirementBadge({
    required this.label,
    required this.current,
    required this.required,
    required this.icon,
  });

  final String label;
  final int current;
  final int required;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isMet = current >= required;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF242426),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMet ? CupertinoColors.white.withValues(alpha: 0.25) : const Color(0x33FFFFFF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: CupertinoColors.white),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFA1A1A6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$current / $required',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isMet ? CupertinoColors.white : const Color(0xFF71717A),
            ),
          ),
        ],
      ),
    );
  }
}
