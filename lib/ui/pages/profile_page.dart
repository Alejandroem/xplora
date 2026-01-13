import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../domain/models/xplora_profile.dart';
import '../../theme.dart';
import '../widgets/achievements_grid.dart';
import '../widgets/segmented_tabs.dart';
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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.colors.iconColor,
              size: iconSizeLarge,
            ),
            onPressed: () => Navigator.of(context).pop(),
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
        body: Padding(
          padding:
              const EdgeInsets.fromLTRB(spacing16, spacing16, spacing16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Tabs section
              SegmentedTabs(
                tabs: const ['Profile', 'Social'],
                selectedIndex: selectedTabIndex,
                onTabSelected: (index) {
                  ref.read(profileTabIndexProvider.notifier).state = index;
                },
              ),
              const SizedBox(height: spacing16),
              // Content section
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: selectedTabIndex == 0
                      ? _buildProfileContent(context, ref)
                      : _buildSocialContent(context, ref),
                ),
              ),
            ],
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
              style: h2Style.copyWith(
                color: context.colors.textPrimary,
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
          ],
        ),
        const SizedBox(height: spacing12),
        // Level progress bar with XP info
        Row(
          children: [
            Expanded(
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colors.border,
                    width: borderWidthDefault,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(radiusMedium),
                    bottomLeft: Radius.circular(radiusMedium),
                  ),
                ),
                child: Stack(
                  children: [
                    // Progress fill
                    FractionallySizedBox(
                      widthFactor: 0.28, // 369/1333 ≈ 0.28 (dummy value)
                      child: Container(
                        decoration: BoxDecoration(
                          color: brandPrimary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(11),
                            bottomLeft: Radius.circular(11),
                          ),
                        ),
                      ),
                    ),
                    // XP text
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: spacing8),
                        child: Text(
                          '369/1333',
                          style: bodySmallStyle.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Level number on the right (no gap)
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(
                horizontal: spacing8,
              ),
              decoration: BoxDecoration(
                color: context.colors.bgSecondary,
                border: Border(
                  top: BorderSide(
                    color: context.colors.border,
                    width: borderWidthDefault,
                  ),
                  right: BorderSide(
                    color: context.colors.border,
                    width: borderWidthDefault,
                  ),
                  bottom: BorderSide(
                    color: context.colors.border,
                    width: borderWidthDefault,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(radiusMedium),
                    bottomRight: Radius.circular(radiusMedium)),
              ),
              child: Center(
                child: Text(
                  '10',
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing24),
        // Stats Section
        Text(
          'Stats',
          style: h2Style.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(height: spacing16),
        _buildStatItem(context, 'Exploration', 0.8),
        const SizedBox(height: spacing12),
        _buildStatItem(context, 'Activity', 0.9),
        const SizedBox(height: spacing12),
        _buildStatItem(context, 'Curiosity', 0.4),
        const SizedBox(height: spacing12),
        _buildStatItem(context, 'Contribution', 0.5),
        const SizedBox(height: spacing24),
        // Achievements Section
        Text(
          'Achievements',
          style: h2Style.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(height: spacing16),
        // Featured achievements grid with navigation
        Container(
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
                  achievementRadius: 40,
                  backgroundColor: context.colors.textPrimary,
                  iconColor: context.colors.bgSecondary,
                  onTap: (index) {
                    Navigator.pushNamed(context, '/achievements');
                  },
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
        const SizedBox(height: spacing24),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, double progress) {
    final rating = (progress * 10).toInt();
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: spacing8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.colors.bgSecondary,
                    borderRadius: BorderRadius.circular(radiusSmall),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: brandPrimary,
                        borderRadius: BorderRadius.circular(radiusSmall),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: spacing12),
              Text(
                '$rating/10',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
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
