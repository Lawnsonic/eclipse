import 'package:flutter/cupertino.dart';

import 'contact_groups.dart';
import 'contacts.dart';
import 'my_estate_screen.dart';
import 'world_map_screen.dart';

const largeScreenMinWidth = 600;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  int selectedListId = 0;
  int _currentTabIndex = 0;

  void _onContactListSelected(int listId) {
    setState(() {
      selectedListId = listId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > largeScreenMinWidth;

        if (isLargeScreen) {
          return _buildLargeScreenLayout();
        } else {
          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              currentIndex: _currentTabIndex,
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              activeColor: const Color(0xFFF59E0B),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_2_fill),
                  label: 'Contacts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house_alt_fill),
                  label: 'My Estate',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.map_fill),
                  label: 'Realm Map',
                ),
              ],
            ),
            tabBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const ContactGroupsPage();
                case 1:
                  return const MyEstateScreen();
                case 2:
                  return const WorldMapScreen();
                default:
                  return const ContactGroupsPage();
              }
            },
          );
        }
      },
    );
  }

  Widget _buildLargeScreenLayout() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 320,
              child: ContactGroupsSidebar(
                selectedListId: selectedListId,
                onListSelected: _onContactListSelected,
              ),
            ),
            Container(width: 1, color: CupertinoColors.separator),
            Expanded(child: ContactListDetail(listId: selectedListId)),
          ],
        ),
      ),
    );
  }
}
