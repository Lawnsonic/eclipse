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
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey4,
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
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.location_solid,
                                size: 12,
                                color: CupertinoColors.systemGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.clear_circled_solid, color: CupertinoColors.systemGrey),
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
                        color: CupertinoColors.secondaryLabel,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: tier.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: tier.accentColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.sparkles,
                                color: tier.accentColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ARCHITECTURAL PERK',
                                style: TextStyle(
                                  color: tier.accentColor,
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
                        color: CupertinoColors.secondaryLabel,
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
                              color: Color(0xFF10B981),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              f,
                              style: const TextStyle(fontSize: 14),
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
        CupertinoButton.filled(
          onPressed: isBlessed
              ? null
              : () {
                  GameState.instance.blessContact(contact!);
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.sparkles),
              const SizedBox(width: 8),
              Text(
                isBlessed
                    ? 'Blessed Today (+45 EP Claimed)'
                    : 'Send Solar Blessing (+45 EP)',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: const Color(0xFF10B981),
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
                    Icon(CupertinoIcons.phone_fill, size: 18),
                    SizedBox(width: 6),
                    Text('Call (Earn CP)'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CupertinoButton(
                color: const Color(0xFF0284C7),
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
                    Icon(CupertinoIcons.chat_bubble_fill, size: 18),
                    SizedBox(width: 6),
                    Text('Chat'),
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
          color: const Color(0xFFF43F5E).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            '🌟 MAX LEVEL ACHIEVED • Eclipse Celestial Sovereign!',
            style: TextStyle(
              color: Color(0xFFF43F5E),
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
        color: CupertinoColors.secondarySystemGroupedBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: next.accentColor.withValues(alpha: 0.3),
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
                style: TextStyle(
                  color: next.accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: next.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Massive Upgrade',
                  style: TextStyle(
                    color: next.accentColor,
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
            style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
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
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RequirementBadge(
                  label: 'Call Points',
                  current: GameState.instance.callPoints,
                  required: next.requiredCP,
                  icon: CupertinoIcons.phone_fill,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
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
                style: TextStyle(fontSize: 13),
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
    required this.color,
  });

  final String label;
  final int current;
  final int required;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isMet = current >= required;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMet ? color : CupertinoColors.systemRed.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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
              color: isMet ? color : CupertinoColors.systemRed,
            ),
          ),
        ],
      ),
    );
  }
}
