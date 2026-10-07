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
      description: 'A modest timber and thatch shelter under the open stars, with a crackling stone hearth.',
      baseCostEP: 0,
      requiredCP: 0,
      dailyIncomeEP: 10,
      accentColor: Color(0xFFD1D1D6),
      gradientColors: [Color(0xFF1C1C1E), Color(0xFF0F0F10)],
      perkDescription: 'Starter shelter with warm hearth embers',
      features: ['Timber Frame', 'Gabled Thatch Roof', 'Stone Campfire', 'Starry Canopy'],
    ),
    HouseTier(
      level: 2,
      title: 'Timber Cabin',
      category: 'Woodland Lodge',
      description: 'Handcrafted alpine cabin with a fieldstone chimney, glass lanterns, and a rustic veranda.',
      baseCostEP: 150,
      requiredCP: 20,
      dailyIncomeEP: 35,
      accentColor: Color(0xFFE5E5EA),
      gradientColors: [Color(0xFF242426), Color(0xFF141416)],
      perkDescription: '+15% Call Point bonus during conversations',
      features: ['Fieldstone Hearth', 'Glass Lanterns', 'Pine Porch', 'Garden Fence'],
    ),
    HouseTier(
      level: 3,
      title: 'Modern Bungalow',
      category: 'Contemporary Home',
      description: 'Single-story architectural haven with panoramic floor-to-ceiling glass and solar slate tiles.',
      baseCostEP: 450,
      requiredCP: 60,
      dailyIncomeEP: 80,
      accentColor: Color(0xFFFFFFFF),
      gradientColors: [Color(0xFF2C2C2E), Color(0xFF18181A)],
      perkDescription: 'Unlocks Solar Roof (+1 EP every 5 minutes)',
      features: ['Solar Slate Tiles', 'Manicured Lawn', 'Paved Flagstone Walkway', 'Sun Porch'],
    ),
    HouseTier(
      level: 4,
      title: 'Suburban Duplex',
      category: 'Multi-Level Residence',
      description: 'Spacious two-story duplex featuring twin balconies, 2-car garage, and private illuminated pool.',
      baseCostEP: 1100,
      requiredCP: 140,
      dailyIncomeEP: 175,
      accentColor: Color(0xFFFFFFFF),
      gradientColors: [Color(0xFF2A2A2D), Color(0xFF151517)],
      perkDescription: 'Host up to 2 simultaneous neighborhood friends',
      features: ['Twin Balconies', 'Reflective Pool', 'Double Garage', 'Rooftop Skylights'],
    ),
    HouseTier(
      level: 5,
      title: 'Urban Crib & Penthouse',
      category: 'High-Rise Residence',
      description: 'Sleek metropolitan penthouse crowned with minimalist linear lighting and panoramic terrace horizons.',
      baseCostEP: 2500,
      requiredCP: 300,
      dailyIncomeEP: 350,
      accentColor: Color(0xFFFFFFFF),
      gradientColors: [Color(0xFF222224), Color(0xFF0F0F10)],
      perkDescription: 'Aura grants 2x combo multiplier on Solar Forge taps',
      features: ['Rooftop Hot Tub', 'Linear Architectural Lighting', 'Floor-to-Ceiling Glass', 'Acoustic Sounddeck'],
    ),
    HouseTier(
      level: 6,
      title: 'Grand Coastal Villa',
      category: 'Architectural Luxury',
      description: 'Monochrome marble villa with neoclassical archways and private infinity pool spilling into the horizon.',
      baseCostEP: 5200,
      requiredCP: 600,
      dailyIncomeEP: 720,
      accentColor: Color(0xFFE5E5EA),
      gradientColors: [Color(0xFF28282B), Color(0xFF161618)],
      perkDescription: 'Ocean breeze generates +50 bonus EP daily',
      features: ['Infinity Ocean Pool', 'Marble Columns', 'Private Palm Terrace', 'Courtyard Fountain'],
    ),
    HouseTier(
      level: 7,
      title: 'Hilltop Mansion',
      category: 'Private Compound',
      description: 'Extravagant multi-wing granite estate atop a private cliff, with private helipad and gated courtyard.',
      baseCostEP: 10500,
      requiredCP: 1200,
      dailyIncomeEP: 1400,
      accentColor: Color(0xFFFFFFFF),
      gradientColors: [Color(0xFF252528), Color(0xFF111113)],
      perkDescription: 'Private Helipad allows instant free travel across all Realms',
      features: ['Helipad', 'Multi-Wing Compound', 'Tennis Court', 'Wine Cellar & Lounge'],
    ),
    HouseTier(
      level: 8,
      title: 'Palatial Chateau',
      category: 'Imperial Estate',
      description: 'Sterling silver chateau with soaring domes, private lake, astronomical observatory, and formal gardens.',
      baseCostEP: 22000,
      requiredCP: 2400,
      dailyIncomeEP: 2800,
      accentColor: Color(0xFFE5E5EA),
      gradientColors: [Color(0xFF202022), Color(0xFF0D0D0E)],
      perkDescription: 'Astronomical observatory doubles all call point yields',
      features: ['Sterling Silver Domes', 'Private Lake', 'Stargazing Observatory', 'Topiary Maze'],
    ),
    HouseTier(
      level: 9,
      title: 'Cyber Citadel',
      category: 'Futuristic Fortress',
      description: 'Zero-gravity citadel flanked by levitating titanium monoliths, photon shield, and harmonic quantum reactor.',
      baseCostEP: 45000,
      requiredCP: 4800,
      dailyIncomeEP: 5500,
      accentColor: Color(0xFFFFFFFF),
      gradientColors: [Color(0xFF18181A), Color(0xFF080809)],
      perkDescription: 'Titanium shield prevents estate erosion and doubles blessing bonus',
      features: ['Levitating Monoliths', 'Photon Forcefield', 'Harmonic Quantum Core', 'Hologram Beacon'],
    ),
    HouseTier(
      level: 10,
      title: 'Eclipse Sky Sanctuary',
      category: 'Celestial Wonder',
      description: 'Cosmic astral palace suspended within the glowing white corona of the Total Solar Eclipse.',
      baseCostEP: 90000,
      requiredCP: 9500,
      dailyIncomeEP: 12000,
      accentColor: Color(0xFFFFFFFF),
      gradientColors: [Color(0xFF141416), Color(0xFF000000)],
      perkDescription: 'Supreme Celestial Ruler: Eternal solar energy & divine radiance across the galaxy',
      features: ['Total Eclipse Corona', 'Astral Aurora Ribbons', 'Floating Crystal Islands', 'Celestial Throne'],
    ),
  ];

  static HouseTier getTier(int level) {
    final clampedLevel = level.clamp(1, 10);
    return allTiers[clampedLevel - 1];
  }
}
