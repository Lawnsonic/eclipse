import 'package:flutter/cupertino.dart';

import '../data/contact.dart';
import '../data/contact_group.dart';
import '../data/game_state.dart';
import '../main.dart';
import 'contacts.dart';
import 'house_detail_sheet.dart';
import 'location_permission_dialog.dart';
import 'my_estate_screen.dart';
import 'world_map_screen.dart';

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
          backgroundColor: CupertinoColors.extraLightBackgroundGray,
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Eclipse Contacts'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => HouseDetailSheet.show(context, isPlayer: true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.sparkles,
                              size: 13,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${state.eclipsePoints} EP',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.phone_fill,
                            size: 13,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${state.callPoints} CP',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: CupertinoListSection.insetGrouped(
                    margin: EdgeInsets.zero,
                    header: const Text('ESTATE & REALM HUBS'),
                    children: [
                      CupertinoListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: state.currentTier.accentColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            CupertinoIcons.house_alt_fill,
                            color: state.currentTier.accentColor,
                            size: 20,
                          ),
                        ),
                        title: const Text('My Estate & Solar Forge'),
                        subtitle: Text(
                          'Lv ${state.playerHouseLevel} ${state.currentTier.title} • Tap to upgrade',
                          style: TextStyle(
                            color: state.currentTier.accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (ctx) => const MyEstateScreen(),
                            ),
                          );
                        },
                      ),
                      CupertinoListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            CupertinoIcons.map_fill,
                            color: Color(0xFF0284C7),
                            size: 20,
                          ),
                        ),
                        title: const Text('Neighborhood Realm Map'),
                        subtitle: Text(
                          state.playerRealm,
                          style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (ctx) => const WorldMapScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ValueListenableBuilder<List<ContactGroup>>(
                  valueListenable: contactGroupsModel.listsNotifier,
                  builder: (context, contactLists, child) {
                    const groupIcon = Icon(
                      CupertinoIcons.group,
                      weight: 900,
                      size: 28,
                    );

                    const pairIcon = Icon(
                      CupertinoIcons.person_2,
                      weight: 900,
                      size: 22,
                    );

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: CupertinoListSection.insetGrouped(
                        margin: EdgeInsets.zero,
                        header: const Text('CONTACT GROUPS'),
                        children: [
                          for (final ContactGroup contactList in contactLists)
                            CupertinoListTile(
                              leading: contactList.id == 0 ? groupIcon : pairIcon,
                              title: Text(contactList.label),
                              trailing: _buildTrailing(contactList.contacts, context),
                              onTap: () => onListSelected(contactList),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrailing(List<Contact> contacts, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${contacts.length}',
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(width: 6),
        const CupertinoListTileChevron(),
      ],
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
