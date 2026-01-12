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

  PlaceSubmission({
    required this.id,
    required this.placeName,
    this.imageUrl,
    required this.status,
    required this.submittedAt,
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
        return const Color(0xffFFC107); // Amber for pending
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
          centerTitle: false,
        ),
        body: submissions.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing16,
                  vertical: spacing16,
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
      ),
      PlaceSubmission(
        id: '3',
        placeName: 'Ocean Park Beach',
        status: SubmissionStatus.rejected,
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
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
      height: 90,
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
          // Image placeholder with padding
          Padding(
            padding: const EdgeInsets.all(spacing8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radiusSmall),
              child: Container(
                width: 64,
                height: 64,
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
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: spacing12,
                vertical: spacing8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    submission.placeName,
                    style: bodyTextStyle.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: spacing4),
                  Row(
                    children: [
                      Text(
                        'Status: ${submission.statusText}',
                        style: captionStyle.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        submission.timeAgo,
                        style: captionStyle.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Status indicator
          Container(
            width: spacing48,
            height: 90,
            decoration: BoxDecoration(
              color: submission.statusColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radiusMedium),
                bottomRight: Radius.circular(radiusMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
