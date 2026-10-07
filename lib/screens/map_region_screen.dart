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
      name: 'Silicon Coast',
      subtitle: 'Waterfront estates & coastal villas',
      accentColor: Color(0xFF0EA5E9),
      icon: CupertinoIcons.wind,
      terrainColor: Color(0xFF082F49),
    ),
    RealmRegion(
      id: 1,
      name: 'Avalon Ridge',
      subtitle: 'Highland hills, mansions & chateaus',
      accentColor: Color(0xFFF59E0B),
      icon: CupertinoIcons.sparkles,
      terrainColor: Color(0xFF451A03),
    ),
    RealmRegion(
      id: 2,
      name: 'Cyber Apex District',
      subtitle: 'Neon skyline, cribs & citadels',
      accentColor: Color(0xFFEC4899),
      icon: CupertinoIcons.cube_fill,
      terrainColor: Color(0xFF3B0764),
    ),
    RealmRegion(
      id: 3,
      name: 'Redwood Glade',
      subtitle: 'Lush pines, cabins & starter shelters',
      accentColor: Color(0xFF10B981),
      icon: CupertinoIcons.tree,
      terrainColor: Color(0xFF064E3B),
    ),
    RealmRegion(
      id: 4,
      name: 'Celestial Orbit',
      subtitle: 'Zero-gravity floating sky sanctuaries',
      accentColor: Color(0xFFF43F5E),
      icon: CupertinoIcons.sun_max_fill,
      terrainColor: Color(0xFF4C0519),
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
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
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
                          style: TextStyle(
                            color: tier.accentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.clear_circled_solid, color: Color(0xFF64748B)),
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
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    if (!isPlayer) ...[
                      CupertinoButton.filled(
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
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              color: const Color(0xFF10B981),
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
                                  Icon(CupertinoIcons.phone_fill, size: 16),
                                  SizedBox(width: 6),
                                  Text('Call (CP)'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CupertinoButton(
                              color: const Color(0xFF0284C7),
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
                                  Icon(CupertinoIcons.chat_bubble_fill, size: 16),
                                  SizedBox(width: 6),
                                  Text('Chat'),
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
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFFF59E0B)),
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
            backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.9),
            middle: const Text(
              '3D Realm Map',
              style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${state.eclipsePoints} EP',
                    style: const TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
                  color: const Color(0xFF0B1120),
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
                  color: currentRegion.terrainColor.withValues(alpha: 0.35),
                  child: Row(
                    children: [
                      Icon(currentRegion.icon, color: currentRegion.accentColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${currentRegion.name} • ${currentRegion.subtitle}',
                          style: TextStyle(
                            color: currentRegion.accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${regionContacts.length + 1} Plots',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
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
              ? r.accentColor.withValues(alpha: 0.25)
              : const Color(0xFF1E293B).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? r.accentColor : const Color(0x2294A3B8),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              r.icon,
              size: 13,
              color: isSelected ? r.accentColor : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Text(
              r.name,
              style: TextStyle(
                color: isSelected ? CupertinoColors.white : const Color(0xFF94A3B8),
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
          color: const Color(0xFF111E38),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
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
                color: Color(0xFFF59E0B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.star_fill, size: 11, color: Color(0xFF451A03)),
                  SizedBox(width: 4),
                  Text(
                    'YOUR ESTATE',
                    style: TextStyle(
                      color: Color(0xFF451A03),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
                    style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 10),
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
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: tier.accentColor.withValues(alpha: 0.4),
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
                    style: TextStyle(
                      color: tier.accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right, size: 10, color: Color(0xFF64748B)),
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
          color: const Color(0xFF0B132B).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0x3394A3B8),
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
                  color: const Color(0xFF1E293B),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x4494A3B8)),
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vacant Plot',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Tap to Relocate Here',
                style: TextStyle(
                  color: Color(0xFF64748B),
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
