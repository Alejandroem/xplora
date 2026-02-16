import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import '../../application/providers/app_startup_providers.dart'; // TODO: Enable if MainActivity destruction becomes an issue
import '../../application/providers/auth_providers.dart';
import '../../application/providers/image_picker_providers.dart';
import '../../application/providers/profile_providers.dart';
import '../../application/providers/storage_providers.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/services/image_picker_service.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/achievements_grid.dart';
import '../widgets/app_bar_tabs.dart';
import 'settings_page.dart';

/// Provider for managing profile tab selection
final profileTabIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

/// Provider for managing social sub-tab selection
final socialTabIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  /// Pick image from gallery, upload to Firebase Storage, and update profile
  Future<void> _pickProfileImage(BuildContext context, WidgetRef ref) async {
    try {
      final imagePickerService = ref.read(imagePickerServiceProvider);

      // Pick image from gallery with automatic compression
      final result = await imagePickerService.pickImageFromGallery(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (result != null) {
        // Get current user ID
        final userIdAsync = ref.read(currentAuthUserIdStreamProvider);
        final userId = userIdAsync.value;

        if (userId == null) {
          if (context.mounted) {
            showXploraSnackBar(
              context,
              'Unable to upload: User not authenticated',
              isError: true,
              duration: const Duration(seconds: 3),
            );
          }
          return;
        }

        // Show uploading snackbar
        if (context.mounted) {
          showXploraSnackBar(
            context,
            'Updating profile picture...',
            isInfo: true,
            duration: const Duration(seconds: 30), // Long duration for upload
          );
        }

        // Upload to Firebase Storage
        final storageService = ref.read(storageServiceProvider);
        final downloadUrl = await storageService.uploadImage(
          result.path,
          userId, // Use userId as filename to overwrite previous avatar
        );

        // Update profile with new avatar URL
        final profileService = ref.read(profileServiceProvider);
        final updateSuccess = await profileService.updateFields(
          userId,
          {'avatarUrl': downloadUrl},
        );

        if (!updateSuccess) {
          throw Exception('Failed to update profile with new avatar URL');
        }

        // Dismiss uploading snackbar and show success
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showXploraSnackBar(
            context,
            'Profile picture updated successfully',
            duration: const Duration(seconds: 2),
          );
        }

        // UI will automatically update since it's watching createOrReadCurrentUserProfile stream
      }
      // If result is null, user cancelled - no action needed
    } on ImagePickerException catch (e) {
      // Handle our custom exception with user-friendly message
      if (context.mounted) {
        showXploraSnackBar(
          context,
          e.message,
          isError: true,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      // Handle any other unexpected errors (upload/update failures)
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showXploraSnackBar(
          context,
          'Failed to update profile picture: ${e.toString()}',
          isError: true,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* ========================================================================
     * ANDROID MAINACTIVITY DESTRUCTION RECOVERY - DISABLED FOR NOW
     * ========================================================================
     * Uncomment this code if you experience issues with lost images on Android
     * when the app is killed due to low memory while the image picker is open.
     *
     * To enable:
     * 1. Uncomment the import: app_startup_providers.dart
     * 2. Uncomment the code below
     *
    ref.listen(checkLostImageDataProvider, (previous, next) {
      next.whenData((result) {
        if (result != null && context.mounted) {
          showXploraSnackBar(
            context,
            'Image recovered: ${result.sizeInMB.toStringAsFixed(2)}MB',
            isInfo: true,
            duration: const Duration(seconds: 3),
          );
          // TODO: Handle the recovered image (upload to storage, etc.)
        }
      });
    });
    * ======================================================================== */

    return ref.watch(createOrReadCurrentUserProfile).when(
      data: (profile) {
        if (profile == null) {
          return _buildErrorState(context);
        }
        return _buildProfileScreen(context, ref, profile);
      },
      loading: () => _buildLoadingState(context),
      error: (e, st) => _buildErrorState(context),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(hideBottomDivider: true),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(hideBottomDivider: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.colors.iconColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: spacing16),
              Text(
                'Unable to load profile',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileScreen(
      BuildContext context, WidgetRef ref, XploraProfile profile) {
    final selectedTabIndex = ref.watch(profileTabIndexProvider);

    return GradientBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlassAppBar(
          hideBottomDivider: true,
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
        body: Padding(
          padding: const EdgeInsets.only(top: spacing4),
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(spacing16, spacing12, spacing16, 0),
            child: selectedTabIndex == 0
                ? _buildProfileContent(context, ref, profile)
                : _buildSocialContent(context, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref, XploraProfile profile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: spacing16),
        // Avatar with camera button section
        Center(
          child: SizedBox(
            width: 128,
            height: 128,
            child: Stack(
              children: [
                // Avatar
                CircleAvatar(
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
                                placeholder: (context, url) =>
                                    ShimmerWidgets.imageShimmer(
                                  context: context,
                                  width: 128,
                                  height: 128,
                                  borderRadius: BorderRadius.circular(64),
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
                // Edit button positioned on the right
                // Positioned(
                //   top: -10,
                //   right: 20,
                //   child: SecondaryButton(
                //     text: 'Edit',
                //     onPressed: () {
                //       // TODO: Navigate to edit profile page
                //     },
                //   ),
                // ),
                // Camera button positioned at bottom right
                Positioned(
                  bottom: 4,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.bgPrimary,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2.0),
                    child: Material(
                      color: context.colors.bgSecondary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => _pickProfileImage(context, ref),
                        customBorder: const CircleBorder(),
                        splashColor: context.colors.iconColor.withValues(alpha: 0.2),
                        highlightColor: context.colors.iconColor.withValues(alpha: 0.1),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svg/camera.svg',
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                context.colors.iconColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: spacing32),
        // First name with Level as superscript
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                _getDisplayName(ref),
                style: bodyTextStyle.copyWith(
                  fontSize: 24,
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: spacing4),
            Transform.translate(
              offset: const Offset(4, -2),
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
                height: 8,
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
                    color: context.colors.textPrimary.withOpacity(0.6),
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
        Container(
          padding: const EdgeInsets.all(spacing24),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          child: Column(
            children: [
              AchievementsGrid(
                itemCount: 6, // Always show 6 slots
                earnedCount: 4, // TODO: Replace with actual earned achievements count from profile data
                achievementSize: 87,
                backgroundColor: context.colors.bgTertiary,
                iconColor: context.colors.iconColor.withValues(alpha: 0.7),
                borderRadius: radiusMedium,
              ),
              const SizedBox(height: spacing16),
              SecondaryButton(
                text: 'See more',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and rating row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: bodySmallStyle.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$rating/10',
              style: bodySmallStyle.copyWith(
                color: context.colors.textSecondary.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacing8),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(radiusSmall),
          child: SizedBox(
            height: 6,
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

  Widget _buildSocialTab({
    required BuildContext context,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: spacing12),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: brandPrimary,
                    width: 2.0,
                  ),
                )
              : null,
        ),
        child: Icon(
          icon,
          size: iconSizeLarge,
          color: isSelected ? brandPrimary : context.colors.iconColor,
        ),
      ),
    );
  }

  String _getDisplayName(WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user != null && user.displayName.isNotEmpty) {
          return user.displayName;
        }
        return 'Set name';
      },
      loading: () => '...',
      error: (_, __) => 'Set name',
    );
  }

  Widget _buildSocialContent(BuildContext context, WidgetRef ref) {
    // final selectedSocialTabIndex = ref.watch(socialTabIndexProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: spacing48),
        // Coming soon content
        Icon(
          Icons.hourglass_empty,
          size: 64,
          color: context.colors.iconColor.withValues(alpha: 0.3),
        ),
        const SizedBox(height: spacing24),
        Text(
          'Coming Soon',
          style: h2Style.copyWith(
            color: context.colors.textPrimary,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: spacing12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacing32),
          child: Text(
            'Social features are under development',
            style: bodyTextStyle.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: spacing48),
      ],
    );

    /* ============================================================
     * REDESIGNED SOCIAL TAB LAYOUT - PRESERVED FOR FUTURE USE
     * ============================================================
     * Uncomment this section when social features are ready
     *
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: spacing16),
        // Avatar, name/username, and Edit button in same row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with camera overlay
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: context.colors.bgSecondary,
                    child: profile.avatarUrl != null &&
                            profile.avatarUrl!.isNotEmpty
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
                  // Camera button positioned at bottom right
                  Positioned(
                    bottom: 0,
                    right: -2,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Handle avatar change
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.bgPrimary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: context.colors.bgSecondary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svg/camera.svg',
                              width: 14,
                              height: 14,
                              colorFilter: ColorFilter.mode(
                                context.colors.iconColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: spacing12),
            // Name and username column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First name
                  Text(
                    _getDisplayName(ref),
                    style: bodyTextStyle.copyWith(
                      color: context.colors.textPrimary,
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(height: spacing4),
                  // Username with verification badge (teal circle)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '@\${profile.username ?? 'username'}',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: brandSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Edit button
            SecondaryButton(
              text: 'Edit',
              onPressed: () {
                // TODO: Navigate to edit profile page
              },
            ),
          ],
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
        // Tab-based navigation with icons
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.colors.border,
                width: borderWidthDefault,
              ),
            ),
          ),
          child: Row(
            children: [
              // Places/Location tab
              Expanded(
                child: _buildSocialTab(
                  context: context,
                  icon: Icons.location_on_outlined,
                  isSelected: selectedSocialTabIndex == 0,
                  onTap: () {
                    ref.read(socialTabIndexProvider.notifier).state = 0;
                  },
                ),
              ),
              // Friends/Social tab
              Expanded(
                child: _buildSocialTab(
                  context: context,
                  icon: Icons.people_outline,
                  isSelected: selectedSocialTabIndex == 1,
                  onTap: () {
                    ref.read(socialTabIndexProvider.notifier).state = 1;
                  },
                ),
              ),
              // Menu/More tab
              Expanded(
                child: _buildSocialTab(
                  context: context,
                  icon: Icons.menu,
                  isSelected: selectedSocialTabIndex == 2,
                  onTap: () {
                    ref.read(socialTabIndexProvider.notifier).state = 2;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: spacing24),
        // Tab content would go here
        Center(
          child: Text(
            'Content for selected tab',
            style: bodyTextStyle.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: spacing24),
      ],
    );
    * ============================================================ */
  }
}
