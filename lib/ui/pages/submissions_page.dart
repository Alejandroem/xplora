import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

/// Enum for submission status
enum SubmissionStatus {
  pending,
  approved,
  rejected,
}

/// Model for place submission
class PlaceSubmission {
  final String id;
  final String placeName;
  final String? imageUrl;
  final SubmissionStatus status;
  final DateTime submittedAt;
  final int? xpEarned;
  final String? rejectionReason;

  PlaceSubmission({
    required this.id,
    required this.placeName,
    this.imageUrl,
    required this.status,
    required this.submittedAt,
    this.xpEarned,
    this.rejectionReason,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(submittedAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get statusText {
    switch (status) {
      case SubmissionStatus.pending:
        return 'Pending';
      case SubmissionStatus.approved:
        return 'Approved';
      case SubmissionStatus.rejected:
        return 'Rejected';
    }
  }

  Color get statusColor {
    switch (status) {
      case SubmissionStatus.pending:
        return warningColor;
      case SubmissionStatus.approved:
        return successColor;
      case SubmissionStatus.rejected:
        return errorColor;
    }
  }
}

/// Screen showing user's place submissions
class SubmissionsPage extends ConsumerWidget {
  const SubmissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual data from provider/API
    final submissions = _getMockSubmissions();

    return GradientBackground(
      child: Scaffold(
        appBar: const GlassAppBar(
          title: 'Submissions',
          centerTitle: true,
          height: 64,
        ),
        body: submissions.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  spacing16,
                  spacing24,
                  spacing16,
                  spacing16
                ),
                itemCount: submissions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: spacing12),
                    child: _SubmissionTile(submission: submissions[index]),
                  );
                },
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

  // TODO: Replace with actual data fetching
  List<PlaceSubmission> _getMockSubmissions() {
    return [
      PlaceSubmission(
        id: '1',
        placeName: 'Ocean Park Beach',
        status: SubmissionStatus.pending,
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PlaceSubmission(
        id: '2',
        placeName: 'Ocean Park Beach',
        status: SubmissionStatus.approved,
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        xpEarned: 50,
      ),
      PlaceSubmission(
        id: '3',
        placeName: 'Ocean Park Beach',
        status: SubmissionStatus.rejected,
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        rejectionReason: 'Needs Improvement',
      ),
    ];
  }
}

/// Individual submission tile widget
class _SubmissionTile extends StatelessWidget {
  final PlaceSubmission submission;

  const _SubmissionTile({
    required this.submission,
  });

  @override
  Widget build(BuildContext context) {
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
          // Image placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(radiusMedium),
            child: Container(
              width: 75,
              height: 75,
              color: context.colors.bgTertiary,
              child: submission.imageUrl != null
                  ? Image.network(
                      submission.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image,
                          color: context.colors.textSecondary,
                          size: iconSizeLarge,
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.image,
                        color: context.colors.textSecondary,
                        size: iconSizeLarge,
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
                Text(
                  submission.placeName,
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: spacing4),
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      submission.statusText,
                      style: bodySmallStyle.copyWith(
                        color: submission.statusColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: spacing4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Extra info for approved/rejected
                    if (submission.status == SubmissionStatus.approved &&
                        submission.xpEarned != null) ...[
                      Text(
                        '+${submission.xpEarned} XP earned',
                        style: bodySmallStyle.copyWith(
                          color: successColor,
                          fontSize: 12
                        ),
                      ),
                    ],

                    if (submission.status == SubmissionStatus.rejected &&
                        submission.rejectionReason != null) ...[
                      Text(
                        submission.rejectionReason!,
                        style: bodyTextStyle.copyWith(
                          color: errorColor,
                            fontSize: 12
                        ),
                      ),
                    ],

                    // Spacer when no extra info is shown
                    if (!((submission.status == SubmissionStatus.approved &&
                            submission.xpEarned != null) ||
                        (submission.status == SubmissionStatus.rejected &&
                            submission.rejectionReason != null)))
                      const SizedBox(),

                    Text(
                      submission.timeAgo,
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textSecondary.withValues(alpha: 0.5),
                        fontSize: 12
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
