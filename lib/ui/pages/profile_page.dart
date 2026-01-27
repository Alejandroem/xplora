import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../domain/models/xplora_profile.dart';
import '../../theme.dart';
import '../widgets/achievements_grid.dart';
import '../widgets/app_bar_tabs.dart';
import 'settings_page.dart';

/// Provider for managing profile tab selection
final profileTabIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class ProfilePage extends ConsumerWidget {
  final XploraProfile profile;
  const ProfilePage(this.profile, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(profileTabIndexProvider);

    return GradientBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(
          bottom: AppBarTabs(
            tabs: const ['Profile', 'Social'],
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              ref.read(profileTabIndexProvider.notifier).state = index;
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: context.colors.iconColor,
                size: iconSizeLarge,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(spacing16, spacing16, spacing16, 0),
            child: selectedTabIndex == 0
                ? _buildProfileContent(context, ref)
                : _buildSocialContent(context, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: spacing16),
        // Avatar and Edit button section
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Centered avatar
            Center(
              child: CircleAvatar(
                radius: 64,
                backgroundColor: context.colors.bgSecondary,
                child:
                    profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profile.avatarUrl!,
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Icon(
                                Icons.person,
                                size: 64,
                                color: context.colors.iconColor,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 64,
                                color: context.colors.iconColor,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 64,
                            color: context.colors.iconColor,
                          ),
              ),
            ),
            // Edit button positioned on the right
            Positioned(
              top: -10,
              right: 20,
              child: SecondaryButton(
                text: 'Edit',
                onPressed: () {
                  // TODO: Navigate to edit profile page
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing32),
        // First name with Level as superscript
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getDisplayFirstName(ref),
              style: bodyTextStyle.copyWith(
                fontSize: 24,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: spacing4),
            Transform.translate(
              offset: const Offset(4, -4),
              child: Text(
                'Lvl 9',
                style: bodySmallStyle.copyWith(
                  color: brandSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing16),
        // Level progress bar with XP info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(radiusSmall),
              child: SizedBox(
                height: 12,
                child: LinearProgressIndicator(
                  value: 369 / 1333, // Progress value (0.0 to 1.0)
                  backgroundColor: context.colors.bgSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
                  borderRadius: BorderRadius.circular(radiusSmall),
                ),
              ),
            ),
            const SizedBox(height: spacing8),
            // XP and Level info row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '369/1333 XP',
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textSecondary.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacing12,
                    vertical: spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: brandSecondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(radiusSmall),
                  ),
                  child: Text(
                    '10',
                    style: bodySmallStyle.copyWith(
                      color: brandSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: spacing24),
        // Stats Section
        Text(
          'Stats',
          style:
              h2Style.copyWith(color: context.colors.textPrimary, fontSize: 24),
        ),
        const SizedBox(height: spacing16),
        _buildStatItem(context, 'Exploration', 0.8),
        const SizedBox(height: spacing16),
        _buildStatItem(context, 'Activity', 0.9),
        const SizedBox(height: spacing16),
        _buildStatItem(context, 'Curiosity', 0.4),
        const SizedBox(height: spacing16),
        _buildStatItem(context, 'Contribution', 0.5),
        const SizedBox(height: spacing24),
        // Achievements Section
        Text(
          'Achievements',
          style: h2Style.copyWith(
            color: context.colors.textPrimary,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: spacing16),
        // Featured achievements grid with navigation
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/achievements');
          },
          child: Container(
            padding: const EdgeInsets.all(spacing16),
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AchievementsGrid(
                      itemCount: 6,
                      achievementSize: 87,
                      backgroundColor: context.colors.bgTertiary,
                      iconColor: context.colors.iconColor,
                      borderRadius: radiusMedium,
                    ),
                ),
                const SizedBox(width: spacing16),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.iconColor,
                    size: iconSizeMedium,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/achievements');
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: spacing24),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, double progress) {
    final rating = (progress * 10).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and rating row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            Text(
              '$rating/10',
              style: bodySmallStyle.copyWith(
                color: context.colors.textSecondary.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing8),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(radiusSmall),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.colors.bgSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
              borderRadius: BorderRadius.circular(radiusSmall),
            ),
          ),
        ),
      ],
    );
  }

  String _getDisplayFirstName(WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user != null && user.displayName.isNotEmpty) {
          return user.displayName.split(' ').first;
        }
        return 'Set first name';
      },
      loading: () => '...',
      error: (_, __) => 'Set first name',
    );
  }

  Widget _buildSocialContent(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: spacing16),
        // Avatar with level badge and Edit button
        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: context.colors.bgSecondary,
                  child:
                      profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: profile.avatarUrl!,
                                width: 96,
                                height: 96,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Icon(
                                  Icons.person,
                                  size: 48,
                                  color: context.colors.iconColor,
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 48,
                                  color: context.colors.iconColor,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 48,
                              color: context.colors.iconColor,
                            ),
                ),
                const SizedBox(width: spacing4),
                Transform.translate(
                  offset: const Offset(0, -4),
                  child: Text(
                    'Lvl 9',
                    style: bodySmallStyle.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            // Edit button positioned on the top right
            Positioned(
              top: -10,
              right: 20,
              child: SecondaryButton(
                text: 'Edit',
                onPressed: () {
                  // TODO: Navigate to edit profile page
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing16),
        // First name with verification badge
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getDisplayFirstName(ref),
              style: h2Style.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(width: spacing4),
            Transform.translate(
              offset: const Offset(0, -2),
              child: Icon(
                Icons.verified,
                size: iconSizeSmall,
                color: brandPrimary,
              ),
            ),
          ],
        ),
        // const SizedBox(height: spacing4),
        // Username
        Text(
          '@${profile.username ?? 'username'}',
          style: bodyTextStyle.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: spacing12),
        // Bio (only show if user has set it)
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          const SizedBox(height: spacing12),
          Text(
            profile.bio!,
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ] else
          Text(
            'lore elohim the light of the infinite, ie  he lo im.',
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        const SizedBox(height: spacing24),
        // Stats row: Badge, Friends, TBD
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: spacing16,
            horizontal: spacing12,
          ),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(radiusMedium),
            border: Border.all(
              color: context.colors.border,
              width: borderWidthDefault,
            ),
          ),
          child: Row(
            children: [
              // Special Badge
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield,
                      size: iconSizeLarge,
                      color: context.colors.iconColor,
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      'Badge',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                width: borderWidthDefault,
                height: 40,
                color: context.colors.border,
              ),
              // Friends count
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '0',
                      style: h2Style.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      'Friends',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                width: borderWidthDefault,
                height: 40,
                color: context.colors.border,
              ),
              // Placeholder (empty for now)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '-',
                      style: h2Style.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      'TBD',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: spacing24),
      ],
    );
  }
}
