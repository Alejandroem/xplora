import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Interest model - supports both IconData and SVG path
class Interest {
  final String id;
  final String label;
  final IconData? icon;
  final String? svgPath;

  const Interest({
    required this.id,
    required this.label,
    this.icon,
    this.svgPath,
  }) : assert(icon != null || svgPath != null,
            'Either icon or svgPath must be provided');
}

/// Available interests list for user selection
final List<Interest> availableInterests = [
  const Interest(id: 'history', label: 'History', icon: LucideIcons.landmark),
  const Interest(id: 'nature', label: 'Nature', icon: LucideIcons.leaf),
  const Interest(id: 'art_culture', label: 'Art & Culture', icon: LucideIcons.palette),
  const Interest(id: 'sports', label: 'Sports', svgPath: 'assets/svg/sports.svg'),
  const Interest(id: 'food_cafes', label: 'Food & Cafes', icon: LucideIcons.utensilsCrossed),
  const Interest(id: 'exploring', label: 'Exploring', icon: LucideIcons.personStanding),
  const Interest(id: 'beaches', label: 'Beaches', icon: LucideIcons.waves),
  const Interest(id: 'hidden_spots', label: 'Hidden Spots', svgPath: 'assets/svg/location-on-map.svg'),
  const Interest(id: 'running', label: 'Running', svgPath: 'assets/svg/person-running.svg'),
  const Interest(id: 'live_music', label: 'Live Music', icon: LucideIcons.music4),
  const Interest(id: 'fashion', label: 'Fashion', svgPath: 'assets/svg/shirt.svg'),
  const Interest(id: 'rivers', label: 'Rivers', svgPath: 'assets/svg/waves.svg'),
  const Interest(id: 'social', label: 'Social', svgPath: 'assets/svg/laughing-mask.svg'),
  const Interest(id: 'hiking', label: 'Hiking', svgPath: 'assets/svg/hiking.svg'),
];
