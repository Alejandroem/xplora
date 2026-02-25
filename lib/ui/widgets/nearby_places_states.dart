import 'package:flutter/material.dart';
import '../../theme.dart';

/// Shown when no nearby places are found within the user's radius.
class NearbyEmptyState extends StatelessWidget {
  const NearbyEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.near_me_disabled_outlined,
            size: iconSizeLarge * 2,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: spacing16),
          Text(
            'No places nearby',
            style: h3Style.copyWith(color: context.colors.textPrimary),
          ),
          const SizedBox(height: spacing8),
          Text(
            'Try exploring a different area',
            style: bodyTextStyle.copyWith(color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Shown when location permission/tracking is disabled.
class LocationRequiredState extends StatelessWidget {
  const LocationRequiredState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: iconSizeLarge * 2,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: spacing16),
          Text(
            'Location Required',
            style: h3Style.copyWith(color: context.colors.textPrimary),
          ),
          const SizedBox(height: spacing8),
          Text(
            'Enable location to see nearby places',
            style: bodyTextStyle.copyWith(color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
