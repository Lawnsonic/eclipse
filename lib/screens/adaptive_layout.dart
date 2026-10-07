import 'package:flutter/cupertino.dart';

import '../theme/eclipse_theme.dart';
import 'contact_groups.dart';
import 'contacts.dart';
import 'map_region_screen.dart';
import 'my_estate_screen.dart';

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
              backgroundColor: const Color(0xFF121212).withValues(alpha: 0.95),
              activeColor: CupertinoColors.white,
              inactiveColor: const Color(0xFF71717A),
              border: Border(
                top: BorderSide(
                  color: CupertinoColors.white.withValues(alpha: 0.08),
                ),
              ),
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_2_fill),
                  label: 'Contacts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.map_fill),
                  label: '3D Realm Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.cube_box_fill),
                  label: 'My 3D Estate',
                ),
              ],
            ),
            tabBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const ContactGroupsPage();
                case 1:
                  return const MapRegionScreen();
                case 2:
                  return const MyEstateScreen();
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
      backgroundColor: EclipseTheme.background,
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 340,
              child: ContactGroupsSidebar(
                selectedListId: selectedListId,
                onListSelected: _onContactListSelected,
              ),
            ),
            Container(
              width: 1,
              color: CupertinoColors.white.withValues(alpha: 0.08),
            ),
            Expanded(child: ContactListDetail(listId: selectedListId)),
          ],
        ),
      ),
    );
  }
}
