import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/place_providers.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';

/// Screen showing user's submitted places
class SubmissionsPage extends ConsumerWidget {
  const SubmissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissionsAsync = ref.watch(userSubmissionsProvider);

    return GradientBackground(
      child: Scaffold(
        appBar: const GlassAppBar(
          title: 'Submissions',
          centerTitle: true,
          height: 64,
        ),
        body: submissionsAsync.when(
          loading: () => ShimmerWidgets.submissionTileListShimmer(context: context),
          error: (_, __) => Center(
            child: Padding(
              padding: const EdgeInsets.all(spacing32),
              child: Text(
                'Failed to load submissions. Please try again.',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (submissions) => submissions.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      spacing16, spacing24, spacing16, spacing16),
                  itemCount: submissions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: spacing12),
                      child: _SubmissionTile(place: submissions[index]),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: spacing16),
            Text(
              'No Submissions Yet',
              style: h3Style.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: spacing8),
            Text(
              'Submit your first place to start earning XP!',
              style: bodyTextStyle.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual submission tile widget
class _SubmissionTile extends StatelessWidget {
  final Place place;

  const _SubmissionTile({required this.place});

  String get _statusText {
    switch (place.status) {
      case 'active':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Color get _statusColor {
    switch (place.status) {
      case 'active':
        return successColor;
      case 'rejected':
        return errorColor;
      default:
        return warningColor;
    }
  }

  /// Shows up to 4 digits; truncates longer numbers with ellipsis before "xp".
  /// e.g. 50 → "50xp", 9999 → "9999xp", 10000 → "1000…xp"
  String _formatXp(int xp) {
    final s = xp.toString();
    return s.length > 8 ? '${s.substring(0, 8)}...xp' : '${s}xp';
  }

  String get _timeAgo {
    if (place.createdAt == null) return '';
    final difference =
        DateTime.now().difference(place.createdAt!.toDate());
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        place.imageUrls.isNotEmpty ? place.imageUrls.first : null;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(
          color: context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      padding: const EdgeInsets.all(spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(radiusMedium),
            child: SizedBox(
              width: 75,
              height: 75,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, _) => ShimmerWidgets.imageShimmer(
                        context: context,
                        width: 75,
                        height: 75,
                        borderRadius: BorderRadius.circular(radiusMedium),
                      ),
                      errorWidget: (context, _, __) => Container(
                        color: context.colors.bgTertiary,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            color: context.colors.textSecondary,
                            size: iconSizeLarge,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: context.colors.bgTertiary,
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: context.colors.textSecondary,
                          size: iconSizeLarge,
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(width: spacing12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: title and XP badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: spacing8,),
                    // XP badge — only for approved places with xp > 0
                    if (place.status == 'active' && place.xp > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spacing12,
                          vertical: spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: brandSecondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: brandSecondary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _formatXp(place.xp),
                          style: bodySmallStyle.copyWith(
                            color: brandSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: spacing4),

                // Status row
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      _statusText,
                      style: bodySmallStyle.copyWith(color: _statusColor),
                    ),
                  ],
                ),

                const SizedBox(height: spacing4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rejection reason — only for rejected places
                    if (place.status == 'rejected' &&
                        place.rejectionReason != null)
                      Flexible(
                        child: Text(
                          place.rejectionReason!,
                          style: bodySmallStyle.copyWith(
                            color: errorColor,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      const SizedBox(),

                    // Timestamp
                    Text(
                      _timeAgo,
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary
                            .withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
