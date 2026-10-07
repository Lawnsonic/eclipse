import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'contact.dart';
import 'house_model.dart';

class GameActivity {
  GameActivity({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.isPositive,
  });

  final String title;
  final String subtitle;
  final DateTime timestamp;
  final IconData icon;
  final bool isPositive;
}

class ContactEstate {
  ContactEstate({
    required this.contactId,
    required this.houseLevel,
    required this.locationName,
    required this.avatarColor,
    required this.statusQuote,
    required this.phoneNumber,
    required this.email,
    required this.latitude,
    required this.longitude,
    this.hasBeenBlessedToday = false,
  });

  final int contactId;
  int houseLevel;
  final String locationName;
  final Color avatarColor;
  final String statusQuote;
  final String phoneNumber;
  final String email;
  final double latitude;
  final double longitude;
  bool hasBeenBlessedToday;

  HouseTier get houseTier => HouseTier.getTier(houseLevel);
}

class GameState extends ChangeNotifier {
  GameState() {
    _initSampleActivities();
  }

  static final GameState instance = GameState();

  String playerName = 'You';
  int playerHouseLevel = 1;
  int eclipsePoints = 320;
  int callPoints = 85;

  String playerRealm = 'Uncharted Outpost';
  bool hasLocationPermission = false;
  double playerLatitude = 37.33233;
  double playerLongitude = -122.03121;

  int comboMultiplier = 1;
  DateTime? _lastTapTime;
  Timer? _comboResetTimer;

  final List<GameActivity> activities = [];
  final Map<int, ContactEstate> _contactEstates = {};

  HouseTier get currentTier => HouseTier.getTier(playerHouseLevel);
  HouseTier? get nextTier =>
      playerHouseLevel < 10 ? HouseTier.getTier(playerHouseLevel + 1) : null;

  bool get canUpgrade {
    if (nextTier == null) return false;
    return eclipsePoints >= nextTier!.baseCostEP &&
        callPoints >= nextTier!.requiredCP;
  }

  ContactEstate getEstateForContact(Contact contact) {
    return _contactEstates.putIfAbsent(
      contact.id,
      () => _generateDefaultEstate(contact),
    );
  }

  ContactEstate _generateDefaultEstate(Contact contact) {
    final colors = [
      const Color(0xFF242426),
      const Color(0xFF1C1C1E),
      const Color(0xFF2C2C2E),
      const Color(0xFF333336),
    ];

    final locations = [
      'Cupertino Heights',
      'Pine Crest Grove',
      'Sun Valley Greens',
      'Avalon Ridge',
      'Emerald Coast Bay',
      'Cedar Redwood Pass',
      'Imperial Lake Gardens',
      'Whispering Glade',
      'Metro Skylines',
      'Neo-Arcadia Citadel',
      'Crown Summit Promontory',
      'Corona Orbit Sanctuary',
    ];

    // Pre-curated house levels across contacts to ensure rich variety
    final levelMap = {
      0: 5,  // John Appleseed: Crib
      1: 4,  // Kate Bell: Duplex
      2: 3,  // Anna Haro: Bungalow
      3: 7,  // Daniel Higgins: Mansion
      4: 6,  // David Taylor: Villa
      5: 2,  // Hank Zakroff: Cabin
      6: 8,  // Alex Anderson: Chateau
      7: 1,  // Ben Brown: Hut
      14: 9, // Isaac Ingram: Cyber Citadel
      21: 10,// Penelope Parker: Celestial Sky Sanctuary
      27: 9, // Victoria Vance: Cyber Citadel
    };

    final level = levelMap[contact.id] ?? ((contact.id % 9) + 1);
    final color = colors[contact.id % colors.length];
    final location = locations[contact.id % locations.length];

    final quotes = [
      'Relaxing by the campfire under the open skies.',
      'Firewood crackling in the pine cabin hearth.',
      'Just installed solar slates on the bungalow roof!',
      'Duplex backyard pool party this weekend!',
      'Chilling on the penthouse rooftop jacuzzi. Come visit!',
      'Infinity pool overlooking the Mediterranean sunset.',
      'Helipad clearance approved on the hilltop mansion.',
      'Stargazing at the astronomical chateau observatory.',
      'Anti-gravity shield at 100% capacity over the citadel.',
      'Living among celestial auroras in the Eclipse Sky Sanctuary!',
    ];

    final quote = quotes[(level - 1).clamp(0, quotes.length - 1)];

    return ContactEstate(
      contactId: contact.id,
      houseLevel: level,
      locationName: location,
      avatarColor: color,
      statusQuote: quote,
      phoneNumber: '+1 (${408 + (contact.id * 17) % 500}) 555-01${contact.id.toString().padLeft(2, '0')}',
      email: '${contact.firstName.toLowerCase()}.${contact.lastName.toLowerCase()}@eclipse.realm',
      latitude: 37.33 + (contact.id * 0.02) % 0.5,
      longitude: -122.03 - (contact.id * 0.015) % 0.4,
    );
  }

  void _initSampleActivities() {
    activities.insert(
      0,
      GameActivity(
        title: 'Drifter Hut Established',
        subtitle: 'Campfire blazing under the stars. Welcome to Eclipse!',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        icon: CupertinoIcons.home,
        isPositive: true,
      ),
    );
  }

  void grantLocationPermission(String realmName, double lat, double lng) {
    hasLocationPermission = true;
    playerRealm = realmName;
    playerLatitude = lat;
    playerLongitude = lng;
    addEclipsePoints(
      150,
      'Location Pinned: Placed Estate at $realmName (+150 EP)',
    );
    notifyListeners();
  }

  void addEclipsePoints(int amount, String reason) {
    eclipsePoints += amount;
    activities.insert(
      0,
      GameActivity(
        title: '+$amount Eclipse Points',
        subtitle: reason,
        timestamp: DateTime.now(),
        icon: CupertinoIcons.sparkles,
        isPositive: true,
      ),
    );
    notifyListeners();
  }

  void addCallPoints(int amount, String reason) {
    callPoints += amount;
    activities.insert(
      0,
      GameActivity(
        title: '+$amount Call Points',
        subtitle: reason,
        timestamp: DateTime.now(),
        icon: CupertinoIcons.phone_fill,
        isPositive: true,
      ),
    );
    notifyListeners();
  }

  bool upgradeHouse() {
    final next = nextTier;
    if (next == null) return false;
    if (eclipsePoints < next.baseCostEP || callPoints < next.requiredCP) {
      return false;
    }

    eclipsePoints -= next.baseCostEP;
    callPoints -= next.requiredCP;
    playerHouseLevel += 1;

    activities.insert(
      0,
      GameActivity(
        title: 'Estate Upgraded to Lv $playerHouseLevel: ${next.title}!',
        subtitle: 'Unlocked: ${next.perkDescription}',
        timestamp: DateTime.now(),
        icon: CupertinoIcons.arrow_up_circle_fill,
        isPositive: true,
      ),
    );

    notifyListeners();
    return true;
  }

  void tapSolarForge() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 1200) {
      if (comboMultiplier < 5) {
        comboMultiplier++;
      }
    } else {
      comboMultiplier = 1;
    }
    _lastTapTime = now;

    _comboResetTimer?.cancel();
    _comboResetTimer = Timer(const Duration(milliseconds: 1800), () {
      comboMultiplier = 1;
      notifyListeners();
    });

    final earned = 3 * comboMultiplier;
    eclipsePoints += earned;

    notifyListeners();
  }

  bool blessContact(Contact contact) {
    final estate = getEstateForContact(contact);
    if (estate.hasBeenBlessedToday) return false;
    estate.hasBeenBlessedToday = true;
    addEclipsePoints(
      45,
      'Blessed ${contact.firstName}\'s ${estate.houseTier.title} (+45 EP)',
    );
    notifyListeners();
    return true;
  }

  void convertCallPointsToEclipse(int cp) {
    if (cp <= 0 || callPoints < cp) return;
    final epGain = cp * 3;
    callPoints -= cp;
    eclipsePoints += epGain;
    activities.insert(
      0,
      GameActivity(
        title: 'Converted $cp CP → +$epGain EP',
        subtitle: 'Solar exchange conversion complete',
        timestamp: DateTime.now(),
        icon: CupertinoIcons.repeat,
        isPositive: true,
      ),
    );
    notifyListeners();
  }
}
