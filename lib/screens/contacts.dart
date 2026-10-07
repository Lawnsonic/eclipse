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
                    backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.9),
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    largeTitle: Text(
                      contactList.title,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
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
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
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
                                    color: Color(0xFFF59E0B),
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
                            color: const Color(0xFF10B981).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.5),
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
                                  color: Color(0xFF10B981),
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
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: EclipseTheme.cardBorder),
                        ),
                        child: CupertinoSearchTextField(
                          placeholder: 'Search contacts & estate houses...',
                          style: const TextStyle(color: CupertinoColors.white),
                          placeholderStyle: const TextStyle(color: Color(0xFF64748B)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          suffixIcon: const Icon(CupertinoIcons.mic_fill, color: Color(0xFF94A3B8)),
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
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: EclipseTheme.glassCardDecoration(radius: 18),
            child: Column(
              children: [
                for (int i = 0; i < contacts.length; i++) ...[
                  _SleekContactTile(contact: contacts[i]),
                  if (i < contacts.length - 1)
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 64),
                      color: CupertinoColors.white.withValues(alpha: 0.05),
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

class _SleekContactTile extends StatelessWidget {
  const _SleekContactTile({required this.contact});

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
          // Gradient-ring avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  contact.avatarColor,
                  contact.avatarColor.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: contact.avatarColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name and 3D tier badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.fullName,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(CupertinoIcons.house_fill, size: 12, color: tier.accentColor),
                    const SizedBox(width: 4),
                    Text(
                      'Lv ${contact.houseLevel} ${tier.title}',
                      style: TextStyle(
                        color: tier.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Micro Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(6),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => CallScreen(contact: contact),
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.phone_fill,
                    color: Color(0xFF10B981),
                    size: 15,
                  ),
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(6),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (ctx) => ChatScreen(contact: contact),
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.chat_bubble_fill,
                    color: Color(0xFF0284C7),
                    size: 15,
                  ),
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(6),
                onPressed: () {
                  HouseDetailSheet.show(context, contact: contact);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: tier.accentColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: tier.accentColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.cube_box_fill,
                        color: tier.accentColor,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lv ${contact.houseLevel}',
                        style: TextStyle(
                          color: tier.accentColor,
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
