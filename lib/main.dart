import 'package:flutter/cupertino.dart';

import 'data/contact_group.dart';
import 'screens/adaptive_layout.dart';
import 'theme/eclipse_theme.dart';

final contactGroupsModel = ContactGroupsModel();

void main() {
  runApp(const RolodexApp());
}

class RolodexApp extends StatelessWidget {
  const RolodexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Eclipse 3D Contacts',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: EclipseTheme.background,
        barBackgroundColor: Color(0xFF0F172A),
        primaryColor: Color(0xFFF59E0B),
      ),
      home: AdaptiveLayout(),
    );
  }
}
