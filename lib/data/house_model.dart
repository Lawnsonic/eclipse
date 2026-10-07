import 'package:flutter/cupertino.dart';

class HouseTier {
  const HouseTier({
    required this.level,
    required this.title,
    required this.category,
    required this.description,
    required this.baseCostEP,
    required this.requiredCP,
    required this.dailyIncomeEP,
    required this.accentColor,
    required this.gradientColors,
    required this.perkDescription,
    required this.features,
  });

  final int level;
  final String title;
  final String category;
  final String description;
  final int baseCostEP;
  final int requiredCP;
  final int dailyIncomeEP;
  final Color accentColor;
  final List<Color> gradientColors;
  final String perkDescription;
  final List<String> features;

  static const List<HouseTier> allTiers = [
    HouseTier(
      level: 1,
      title: "Drifter's Hut",
      category: 'Rustic Shelter',
      description: 'A modest straw and timber hut under the open stars, with a warm crackling campfire.',
      baseCostEP: 0,
      requiredCP: 0,
      dailyIncomeEP: 10,
      accentColor: Color(0xFFD97706),
      gradientColors: [Color(0xFF451A03), Color(0xFF78350F)],
      perkDescription: 'Starter home with cozy campfire warmth',
      features: ['Timber Frame', 'Straw Thatch Roof', 'Stone Campfire', 'Starry Canopy'],
    ),
    HouseTier(
      level: 2,
      title: 'Timber Cabin',
      category: 'Woodland Lodge',
      description: 'Handcrafted pine cabin with a fieldstone hearth, glass lanterns, and a rustic deck.',
      baseCostEP: 150,
      requiredCP: 20,
      dailyIncomeEP: 35,
      accentColor: Color(0xFF10B981),
      gradientColors: [Color(0xFF064E3B), Color(0xFF065F46)],
      perkDescription: '+15% Call Point bonus during conversations',
      features: ['Fieldstone Hearth', 'Glass Lanterns', 'Pine Porch', 'Garden Fence'],
    ),
    HouseTier(
      level: 3,
      title: 'Modern Bungalow',
      category: 'Contemporary Home',
      description: 'Single-story haven with floor-to-ceiling panoramic glass, manicured lawn, and solar slates.',
      baseCostEP: 450,
      requiredCP: 60,
      dailyIncomeEP: 80,
      accentColor: Color(0xFF0EA5E9),
      gradientColors: [Color(0xFF0C4A6E), Color(0xFF0369A1)],
      perkDescription: 'Unlocks Solar Roof (+1 EP every 5 minutes)',
      features: ['Solar Slate Tiles', 'Manicured Lawn', 'Paved Flagstone Walkway', 'Sun Porch'],
    ),
    HouseTier(
      level: 4,
      title: 'Suburban Duplex',
      category: 'Multi-Level Residence',
      description: 'Spacious two-story duplex featuring twin balconies, 2-car garage, and backyard turquoise pool.',
      baseCostEP: 1100,
      requiredCP: 140,
      dailyIncomeEP: 175,
      accentColor: Color(0xFF6366F1),
      gradientColors: [Color(0xFF1E1B4B), Color(0xFF3730A3)],
      perkDescription: 'Host up to 2 simultaneous neighborhood friends',
      features: ['Twin Balconies', 'Turquoise Pool', 'Double Garage', 'Rooftop Skylights'],
    ),
    HouseTier(
      level: 5,
      title: 'Neon Crib & Penthouse',
      category: 'Urban High-Rise',
      description: 'High-tech urban crib crowned with neon trim, rooftop jacuzzi, and sweeping skyline horizons.',
      baseCostEP: 2500,
      requiredCP: 300,
      dailyIncomeEP: 350,
      accentColor: Color(0xFFEC4899),
      gradientColors: [Color(0xFF500724), Color(0xFF831843)],
      perkDescription: 'Neon Aura grants 2x combo multiplier on Solar Forge taps',
      features: ['Rooftop Jacuzzi', 'Neon Underglow', 'Panoramic Skyline Glass', 'DJ Sounddeck'],
    ),
    HouseTier(
      level: 6,
      title: 'Grand Coastal Villa',
      category: 'Mediterranean Luxury',
      description: 'Sun-drenched marble villa with neoclassical archways, infinity pool overflowing into the ocean.',
      baseCostEP: 5200,
      requiredCP: 600,
      dailyIncomeEP: 720,
      accentColor: Color(0xFF14B8A6),
      gradientColors: [Color(0xFF042F2E), Color(0xFF115E59)],
      perkDescription: 'Ocean breeze generates +50 bonus EP daily',
      features: ['Infinity Ocean Pool', 'Marble Columns', 'Private Palm Terrace', 'Courtyard Fountain'],
    ),
    HouseTier(
      level: 7,
      title: 'Hilltop Mansion',
      category: 'Private Estate',
      description: 'Extravagant multi-wing mansion atop a private cliff, with private helipad and illuminated driveway.',
      baseCostEP: 10500,
      requiredCP: 1200,
      dailyIncomeEP: 1400,
      accentColor: Color(0xFFF59E0B),
      gradientColors: [Color(0xFF451A03), Color(0xFF78350F)],
      perkDescription: 'Private Helipad allows instant free travel across all Realms',
      features: ['Helipad', 'Multi-Wing Compound', 'Tennis Court', 'Wine Cellar & Lounge'],
    ),
    HouseTier(
      level: 8,
      title: 'Palatial Chateau',
      category: 'Imperial Palace',
      description: 'Gilded chateau with soaring domes, private swan lake, astronomical observatory, and royal gardens.',
      baseCostEP: 22000,
      requiredCP: 2400,
      dailyIncomeEP: 2800,
      accentColor: Color(0xFFEAB308),
      gradientColors: [Color(0xFF422006), Color(0xFF713F12)],
      perkDescription: 'Astronomical observatory doubles all call point yields',
      features: ['Gilded Spires & Domes', 'Private Swan Lake', 'Stargazing Observatory', 'Topiary Maze'],
    ),
    HouseTier(
      level: 9,
      title: 'Cyber Citadel',
      category: 'Futuristic Fortress',
      description: 'Zero-gravity citadel flanked by levitating monoliths, photon barrier shields, and harmonic reactors.',
      baseCostEP: 45000,
      requiredCP: 4800,
      dailyIncomeEP: 5500,
      accentColor: Color(0xFF8B5CF6),
      gradientColors: [Color(0xFF1E1035), Color(0xFF4C1D95)],
      perkDescription: 'Anti-gravity shield prevents estate erosion and doubles blessing bonus',
      features: ['Levitating Monoliths', 'Photon Forcefield', 'Harmonic Quantum Core', 'Hologram Beacon'],
    ),
    HouseTier(
      level: 10,
      title: 'Eclipse Sky Sanctuary',
      category: 'Celestial Wonder',
      description: 'Cosmic astral palace suspended within the glowing corona of the Eclipse, surrounded by aurora ribbons.',
      baseCostEP: 90000,
      requiredCP: 9500,
      dailyIncomeEP: 12000,
      accentColor: Color(0xFFF43F5E),
      gradientColors: [Color(0xFF270815), Color(0xFF4C0519)],
      perkDescription: 'Supreme Celestial Ruler: Eternal solar energy & divine radiance across the galaxy',
      features: ['Eclipse Solar Corona', 'Aurora Borealis Ribbons', 'Floating Crystal Islands', 'Astral Throne'],
    ),
  ];

  static HouseTier getTier(int level) {
    final clampedLevel = level.clamp(1, 10);
    return allTiers[clampedLevel - 1];
  }
}
