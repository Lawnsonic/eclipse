import 'package:flutter/cupertino.dart';
import '../data/contact.dart';
import '../data/game_state.dart';
import '../theme/eclipse_theme.dart';
import '../widgets/house_3d_viewer.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class RealmRegion {
  const RealmRegion({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.accentColor,
    required this.icon,
    required this.terrainColor,
  });

  final int id;
  final String name;
  final String subtitle;
  final Color accentColor;
  final IconData icon;
  final Color terrainColor;

  static const List<RealmRegion> all = [
    RealmRegion(
      id: 0,
      name: 'Titanium Coast',
      subtitle: 'Waterfront estates & coastal villas',
      accentColor: Color(0xFFD1D1D6),
      icon: CupertinoIcons.wind,
      terrainColor: Color(0xFF141416),
    ),
    RealmRegion(
      id: 1,
      name: 'Granite Ridge',
      subtitle: 'Highland hills, mansions & chateaus',
      accentColor: Color(0xFFE5E5EA),
      icon: CupertinoIcons.sparkles,
      terrainColor: Color(0xFF18181B),
    ),
    RealmRegion(
      id: 2,
      name: 'Obsidian District',
      subtitle: 'Monochrome skyline, cribs & citadels',
      accentColor: Color(0xFFFFFFFF),
      icon: CupertinoIcons.cube_fill,
      terrainColor: Color(0xFF141416),
    ),
    RealmRegion(
      id: 3,
      name: 'Silver Glade',
      subtitle: 'Lush pines, cabins & starter shelters',
      accentColor: Color(0xFFD4D4D8),
      icon: CupertinoIcons.tree,
      terrainColor: Color(0xFF18181B),
    ),
    RealmRegion(
      id: 4,
      name: 'Celestial Orbit',
      subtitle: 'Zero-gravity floating sky sanctuaries',
      accentColor: Color(0xFFFFFFFF),
      icon: CupertinoIcons.sun_max_fill,
      terrainColor: Color(0xFF101012),
    ),
  ];
}

class MapRegionScreen extends StatefulWidget {
  const MapRegionScreen({super.key});

  @override
  State<MapRegionScreen> createState() => _MapRegionScreenState();
}

class _MapRegionScreenState extends State<MapRegionScreen> {
  int _selectedRegionIndex = 0;

  List<Contact> _getContactsForRegion(int regionId) {
    return allContacts.where((c) => (c.id % RealmRegion.all.length) == regionId).toList();
  }

  void _onPlotTapped(BuildContext context, Contact? contact, bool isPlayerPlot) {
    if (isPlayerPlot) {
      _showPlotDetailModal(context, null, isPlayer: true);
    } else if (contact != null) {
      _showPlotDetailModal(context, contact, isPlayer: false);
    } else {
      _showClaimPlotDialog(context);
    }
  }

  void _showClaimPlotDialog(BuildContext context) {
    final region = RealmRegion.all[_selectedRegionIndex];
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('Relocate to ${region.name}?'),
        content: Text(
          'Move your Level ${GameState.instance.playerHouseLevel} ${GameState.instance.currentTier.title} to this vacant 3D plot in ${region.name}?',
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Relocate Estate'),
            onPressed: () {
              GameState.instance.grantLocationPermission(
                region.name,
                37.33 + _selectedRegionIndex * 0.1,
                -122.03 - _selectedRegionIndex * 0.1,
              );
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showPlotDetailModal(BuildContext context, Contact? contact, {required bool isPlayer}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        final tier = isPlayer ? GameState.instance.currentTier : contact!.houseTier;
        final title = isPlayer ? 'Your Estate (YOU)' : contact!.fullName;
        final location = isPlayer ? GameState.instance.playerRealm : contact!.locationName;

        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${tier.title} • $location',
                          style: const TextStyle(
                            color: Color(0xFFA1A1A6),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.clear_circled_solid, color: Color(0xFF71717A)),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    House3DViewer(tier: tier, height: 260),
                    const SizedBox(height: 14),
                    Text(
                      tier.description,
                      style: const TextStyle(color: Color(0xFFA1A1A6), fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    if (!isPlayer) ...[
                      CupertinoButton(
                        color: const Color(0xFF27272A),
                        borderRadius: BorderRadius.circular(14),
                        onPressed: contact!.hasBeenBlessedToday
                            ? null
                            : () {
                                GameState.instance.blessContact(contact);
                                Navigator.of(ctx).pop();
                              },
                        child: Text(
                          contact.hasBeenBlessedToday
                              ? 'Blessed Today (+45 EP Claimed)'
                              : 'Send Solar Blessing (+45 EP)',
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                                Navigator.of(ctx).pop();
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (_) => CallScreen(contact: contact),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.phone_fill, size: 16, color: CupertinoColors.white),
                                  SizedBox(width: 6),
                                  Text('Call (CP)', style: TextStyle(color: CupertinoColors.white)),
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
                                Navigator.of(ctx).pop();
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (_) => ChatScreen(contact: contact),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.chat_bubble_fill, size: 16, color: CupertinoColors.white),
                                  SizedBox(width: 6),
                                  Text('Chat', style: TextStyle(color: CupertinoColors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: CupertinoColors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.checkmark_seal_fill, color: CupertinoColors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This is your primary estate base. Daily yield: +${tier.dailyIncomeEP} EP.',
                                style: const TextStyle(color: CupertinoColors.white, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GameState.instance,
      builder: (context, child) {
        final state = GameState.instance;
        final currentRegion = RealmRegion.all[_selectedRegionIndex];
        final regionContacts = _getContactsForRegion(_selectedRegionIndex);

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
              '3D Realm Map',
              style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CupertinoColors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.sparkles,
                        size: 13,
                        color: EclipseTheme.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${state.eclipsePoints} EP',
                        style: const TextStyle(
                          color: EclipseTheme.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Horizontal Sleek Region Selector Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: const Color(0xFF121212),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < RealmRegion.all.length; i++)
                          _buildRegionTab(i, RealmRegion.all[i]),
                      ],
                    ),
                  ),
                ),
                // Region Info Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: currentRegion.terrainColor,
                  child: Row(
                    children: [
                      Icon(currentRegion.icon, color: EclipseTheme.white, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${currentRegion.name} • ${currentRegion.subtitle}',
                          style: const TextStyle(
                            color: EclipseTheme.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${regionContacts.length + 1} Plots',
                        style: const TextStyle(
                          color: Color(0xFFA1A1A6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // 3D Isometric Plots Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: regionContacts.length + 2, // Contacts + Player plot + 1 vacant plot
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Player's Plot
                        return _buildPlayerPlotCard(context, state, currentRegion);
                      } else if (index - 1 < regionContacts.length) {
                        // Contact Plot
                        final contact = regionContacts[index - 1];
                        return _buildContactPlotCard(context, contact);
                      } else {
                        // Vacant Plot
                        return _buildVacantPlotCard(context, currentRegion);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegionTab(int index, RealmRegion r) {
    final isSelected = _selectedRegionIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedRegionIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF27272A)
              : const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? CupertinoColors.white.withValues(alpha: 0.4) : const Color(0x18FFFFFF),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              r.icon,
              size: 13,
              color: isSelected ? CupertinoColors.white : const Color(0xFFA1A1A6),
            ),
            const SizedBox(width: 6),
            Text(
              r.name,
              style: TextStyle(
                color: isSelected ? CupertinoColors.white : const Color(0xFFA1A1A6),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerPlotCard(BuildContext context, GameState state, RealmRegion region) {
    final tier = state.currentTier;
    return GestureDetector(
      onTap: () => _onPlotTapped(context, null, true),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: CupertinoColors.white, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.white.withValues(alpha: 0.1),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                color: Color(0xFF27272A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.star_fill, size: 11, color: CupertinoColors.white),
                  SizedBox(width: 4),
                  Text(
                    'YOUR ESTATE',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                child: House3DViewer(tier: tier, height: 120, interactive: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    'Lv ${state.playerHouseLevel} ${tier.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '+${tier.dailyIncomeEP} EP/day',
                    style: const TextStyle(color: Color(0xFFA1A1A6), fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPlotCard(BuildContext context, Contact contact) {
    final tier = contact.houseTier;
    return GestureDetector(
      onTap: () => _onPlotTapped(context, contact, false),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: CupertinoColors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: contact.avatarColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CupertinoColors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        contact.initials,
                        style: const TextStyle(color: CupertinoColors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      contact.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                child: House3DViewer(tier: tier, height: 110, interactive: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lv ${contact.houseLevel} ${tier.category}',
                    style: const TextStyle(
                      color: Color(0xFFA1A1A6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right, size: 10, color: Color(0xFF71717A)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVacantPlotCard(BuildContext context, RealmRegion region) {
    return GestureDetector(
      onTap: () => _onPlotTapped(context, null, false),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141416).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0x18FFFFFF),
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F22),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x28FFFFFF)),
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: CupertinoColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vacant Plot',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Tap to Relocate Here',
                style: TextStyle(
                  color: Color(0xFF71717A),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
