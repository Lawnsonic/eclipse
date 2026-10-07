import 'package:flutter/cupertino.dart';

import '../data/contact_group.dart';
import '../data/game_state.dart';
import '../main.dart';
import '../theme/eclipse_theme.dart';
import 'contacts.dart';
import 'house_detail_sheet.dart';
import 'location_permission_dialog.dart';
import 'map_region_screen.dart';
import 'my_estate_screen.dart';

class ContactGroupsPage extends StatefulWidget {
  const ContactGroupsPage({super.key});

  @override
  State<ContactGroupsPage> createState() => _ContactGroupsPageState();
}

class _ContactGroupsPageState extends State<ContactGroupsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!GameState.instance.hasLocationPermission) {
        LocationPermissionDialog.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      onListSelected: (list) => Navigator.of(context).push(
        CupertinoPageRoute<void>(
          title: list.title,
          builder: (context) => ContactListsPage(listId: list.id),
        ),
      ),
    );
  }
}

class _ContactGroupsView extends StatelessWidget {
  const _ContactGroupsView({required this.onListSelected, this.selectedListId});

  final int? selectedListId;
  final void Function(ContactGroup) onListSelected;

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
              'Eclipse Realm',
              style: TextStyle(
                color: EclipseTheme.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => HouseDetailSheet.show(context, isPlayer: true),
                  child: Container(
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: EclipseTheme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
                        CupertinoIcons.phone_fill,
                        size: 13,
                        color: EclipseTheme.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${state.callPoints} CP',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: EclipseTheme.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              // Sleek Realm Hub Header
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 8),
                child: Text(
                  '3D REALM HUBS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: EclipseTheme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              // My 3D Estate Card
              _buildMonochromeHubCard(
                context: context,
                icon: CupertinoIcons.cube_box_fill,
                title: 'My 3D Estate & Forge',
                subtitle: 'Lv ${state.playerHouseLevel} ${state.currentTier.title} • Tap to view 3D',
                badgeText: '3D LIVE',
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => const MyEstateScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              // 3D Map Region Card
              _buildMonochromeHubCard(
                context: context,
                icon: CupertinoIcons.map_fill,
                title: '3D Realm Map & Plots',
                subtitle: '${state.playerRealm} • Explore player houses',
                badgeText: '5 BIOMES',
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => const MapRegionScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Contact Groups Header
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 8),
                child: Text(
                  'CONTACT DIRECTORIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: EclipseTheme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              ValueListenableBuilder<List<ContactGroup>>(
                valueListenable: contactGroupsModel.listsNotifier,
                builder: (context, contactLists, child) {
                  return Container(
                    decoration: EclipseTheme.glassCardDecoration(),
                    child: Column(
                      children: [
                        for (int i = 0; i < contactLists.length; i++) ...[
                          _buildGroupTile(
                            contactList: contactLists[i],
                            context: context,
                            onTap: () => onListSelected(contactLists[i]),
                          ),
                          if (i < contactLists.length - 1)
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(left: 52),
                              color: CupertinoColors.white.withValues(alpha: 0.06),
                            ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonochromeHubCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: CupertinoColors.white.withValues(alpha: 0.12),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF222225),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CupertinoColors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Icon(icon, color: EclipseTheme.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: EclipseTheme.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: EclipseTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF242426),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CupertinoColors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: EclipseTheme.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: EclipseTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTile({
    required ContactGroup contactList,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    final icon = contactList.id == 0
        ? CupertinoIcons.person_3_fill
        : CupertinoIcons.person_2_fill;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: EclipseTheme.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              contactList.label,
              style: const TextStyle(
                color: EclipseTheme.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${contactList.contacts.length}',
              style: TextStyle(
                color: EclipseTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            CupertinoIcons.chevron_right,
            size: 14,
            color: EclipseTheme.textMuted,
          ),
        ],
      ),
    );
  }
}

class ContactGroupsSidebar extends StatelessWidget {
  const ContactGroupsSidebar({
    super.key,
    required this.selectedListId,
    required this.onListSelected,
  });

  final int selectedListId;
  final void Function(int) onListSelected;

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: selectedListId,
      onListSelected: (list) => onListSelected(list.id),
    );
  }
}
