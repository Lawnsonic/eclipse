import 'package:flutter/cupertino.dart';
import '../data/contact.dart';
import '../data/contact_group.dart';
import '../data/game_state.dart';
import '../main.dart';
import '../theme/eclipse_theme.dart';
import 'call_screen.dart';
import 'chat_screen.dart';
import 'house_detail_sheet.dart';

class ContactListsPage extends StatelessWidget {
  const ContactListsPage({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return _ContactListView(listId: listId);
  }
}

class _ContactListView extends StatelessWidget {
  const _ContactListView({
    required this.listId,
    this.automaticallyImplyLeading = true,
  });

  final int listId;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GameState.instance,
      builder: (context, child) {
        final state = GameState.instance;

        return CupertinoPageScaffold(
          backgroundColor: EclipseTheme.background,
          child: ValueListenableBuilder<List<ContactGroup>>(
            valueListenable: contactGroupsModel.listsNotifier,
            builder: (context, contactGroups, child) {
              final contactList = contactGroupsModel.findContactList(listId);
              final contacts = contactList.alphabetizedContacts;

              return CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    backgroundColor: const Color(0xFF0D0D0E).withValues(alpha: 0.95),
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    largeTitle: Text(
                      contactList.title,
                      style: const TextStyle(
                        color: EclipseTheme.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    automaticallyImplyLeading: automaticallyImplyLeading,
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF141416),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: CupertinoColors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: CupertinoSearchTextField(
                          placeholder: 'Search contacts & estate houses...',
                          style: const TextStyle(color: EclipseTheme.white),
                          placeholderStyle: const TextStyle(color: EclipseTheme.textMuted),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          suffixIcon: const Icon(CupertinoIcons.mic_fill, color: EclipseTheme.textSecondary),
                          suffixMode: OverlayVisibilityMode.always,
                        ),
                      ),
                    ),
                  ),
                  SliverList.list(
                    children: [
                      const SizedBox(height: 6),
                      ...contacts.keys.map(
                        (initial) => ContactListSection(
                          lastInitial: initial,
                          contacts: contacts[initial]!,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class ContactListSection extends StatelessWidget {
  const ContactListSection({
    super.key,
    required this.lastInitial,
    required this.contacts,
  });

  final String lastInitial;
  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 6),
            child: Text(
              lastInitial,
              style: const TextStyle(
                color: EclipseTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: EclipseTheme.glassCardDecoration(radius: 16),
            child: Column(
              children: [
                for (int i = 0; i < contacts.length; i++) ...[
                  _MonochromeContactTile(contact: contacts[i]),
                  if (i < contacts.length - 1)
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 64),
                      color: CupertinoColors.white.withValues(alpha: 0.06),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonochromeContactTile extends StatelessWidget {
  const _MonochromeContactTile({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final tier = contact.houseTier;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onPressed: () {
        HouseDetailSheet.show(context, contact: contact);
      },
      child: Row(
        children: [
          // Sleek Monochrome Titanium Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF222225),
              shape: BoxShape.circle,
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: const TextStyle(
                  color: EclipseTheme.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Name & Monochrome Tier Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.fullName,
                  style: const TextStyle(
                    color: EclipseTheme.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.house_fill,
                      size: 12,
                      color: EclipseTheme.silver,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Lv ${contact.houseLevel} • ${tier.title}',
                      style: const TextStyle(
                        color: EclipseTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Sleek Monochrome Micro Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(5),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => CallScreen(contact: contact),
                    ),
                  );
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF202022),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CupertinoColors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.phone_fill,
                    color: EclipseTheme.white,
                    size: 15,
                  ),
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(5),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => ChatScreen(contact: contact),
                    ),
                  );
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF202022),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CupertinoColors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.chat_bubble_fill,
                    color: EclipseTheme.white,
                    size: 15,
                  ),
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(5),
                onPressed: () {
                  HouseDetailSheet.show(context, contact: contact);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202022),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: CupertinoColors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.cube_box_fill,
                        color: EclipseTheme.white,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lv ${contact.houseLevel}',
                        style: const TextStyle(
                          color: EclipseTheme.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactListDetail extends StatelessWidget {
  const ContactListDetail({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return _ContactListView(listId: listId, automaticallyImplyLeading: false);
  }
}
