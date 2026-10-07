import 'package:flutter/cupertino.dart';
import '../data/contact.dart';
import '../data/contact_group.dart';
import '../data/game_state.dart';
import '../main.dart';
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
          child: ValueListenableBuilder<List<ContactGroup>>(
            valueListenable: contactGroupsModel.listsNotifier,
            builder: (context, contactGroups, child) {
              final contactList = contactGroupsModel.findContactList(listId);
              final contacts = contactList.alphabetizedContacts;

              return CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: Text(contactList.title),
                    automaticallyImplyLeading: automaticallyImplyLeading,
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
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: CupertinoSearchTextField(
                        placeholder: 'Search contacts & estate houses...',
                        suffixIcon: Icon(CupertinoIcons.mic_fill),
                        suffixMode: OverlayVisibilityMode.always,
                      ),
                    ),
                  ),
                  SliverList.list(
                    children: [
                      const SizedBox(height: 10),
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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              lastInitial,
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CupertinoListSection.insetGrouped(
            margin: EdgeInsets.zero,
            backgroundColor: CupertinoColors.transparent,
            children: [
              for (final Contact contact in contacts)
                _ContactRowTile(contact: contact),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactRowTile extends StatelessWidget {
  const _ContactRowTile({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final tier = contact.houseTier;

    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leadingSize: 42,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: contact.avatarColor,
          shape: BoxShape.circle,
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
      title: Text(
        contact.fullName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Row(
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
      trailing: Row(
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.phone_fill,
                color: Color(0xFF10B981),
                size: 16,
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.chat_bubble_fill,
                color: Color(0xFF0284C7),
                size: 16,
              ),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(6),
            onPressed: () {
              HouseDetailSheet.show(context, contact: contact);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: tier.accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: tier.accentColor.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.house_alt_fill,
                    color: tier.accentColor,
                    size: 14,
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
      onTap: () {
        HouseDetailSheet.show(context, contact: contact);
      },
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
