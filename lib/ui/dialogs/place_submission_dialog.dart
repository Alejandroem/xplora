import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/submit_place_providers.dart';
import '../../theme.dart';
import 'base_dialog.dart';

void showPlaceSubmissionDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    builder: (_) => const _PlaceSubmissionDialog(),
  );
}

class _PlaceSubmissionDialog extends ConsumerWidget {
  const _PlaceSubmissionDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PlaceSubmissionState>(placeSubmissionProvider, (previous, next) {
      if ((previous?.isLoading ?? false) && !next.isLoading) {
        Navigator.of(context).pop();
      }
    });

    final state = ref.watch(placeSubmissionProvider);

    return PopScope(
      canPop: false,
      child: BaseDialog(
        dismissOnBarrierTap: false,
      icon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: brandPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(radiusLarge),
          border: Border.all(
            color: brandPrimary.withValues(alpha: 0.3),
            width: borderWidthDefault,
          ),
        ),
        child: Icon(
          Icons.cloud_upload_outlined,
          color: brandPrimary,
          size: iconSizeMedium,
        ),
      ),
      title: 'Submitting Place',
      description: '',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.statusMessage.isNotEmpty
                ? state.statusMessage
                : 'Preparing...',
            style: bodyTextStyle.copyWith(color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: spacing12),
          ClipRRect(
            borderRadius: BorderRadius.circular(radiusSmall),
            child: LinearProgressIndicator(
              value: state.progress > 0 ? state.progress : null,
              minHeight: 6,
              backgroundColor: context.colors.border.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation(brandPrimary),
            ),
          ),
        ],
      ),
      actions: const [],
    ),
    );
  }
}
