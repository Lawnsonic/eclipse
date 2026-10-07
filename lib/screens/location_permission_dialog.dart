import 'package:flutter/cupertino.dart';
import '../data/game_state.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LocationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.location_solid,
              color: Color(0xFFF59E0B),
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Place Your Estate Realm'),
        ],
      ),
      content: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Allow "Eclipse" to access your location to establish your starting estate coordinates on the realm map and connect with nearby neighbor estates.',
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            GameState.instance.grantLocationPermission(
              'Silicon Coast Heights',
              37.332,
              -122.031,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Allow While Using App'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            _showCustomRealmPicker(context);
          },
          child: const Text('Choose Custom Realm'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            GameState.instance.grantLocationPermission(
              'Uncharted Wilderness',
              37.774,
              -122.419,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Use Default Realm'),
        ),
      ],
    );
  }

  static void _showCustomRealmPicker(BuildContext context) {
    Navigator.of(context).pop();
    final realms = [
      {'name': 'Emerald Coast Bay', 'lat': 37.562, 'lng': -122.325},
      {'name': 'Avalon Summit Peak', 'lat': 37.441, 'lng': -122.143},
      {'name': 'Neo-Arcadia Citadel', 'lat': 37.804, 'lng': -122.251},
      {'name': 'Whispering Forest Glade', 'lat': 37.865, 'lng': -122.258},
      {'name': 'Celestial Orbit Sanctuary', 'lat': 37.783, 'lng': -122.416},
    ];

    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Select Estate Realm'),
        message: const Text('Choose the initial geographic sector for your house:'),
        actions: realms.map((r) {
          return CupertinoActionSheetAction(
            onPressed: () {
              GameState.instance.grantLocationPermission(
                r['name'] as String,
                r['lat'] as double,
                r['lng'] as double,
              );
              Navigator.of(ctx).pop();
            },
            child: Text(r['name'] as String),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
