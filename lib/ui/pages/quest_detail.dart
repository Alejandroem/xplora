import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/models/quest.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../dialogs/base_dialog.dart';
import 'qr_scanner_screen.dart';

// Quest state providers
final questStartedProvider = StateProvider.autoDispose<bool>((ref) => false);
final inRangeProvider = StateProvider.autoDispose<bool>((ref) => false);
final dwellMetProvider = StateProvider.autoDispose<bool>((ref) => false);
final dwellProgressProvider = StateProvider.autoDispose<double>((ref) => 0.0);
final scannedQRsProvider = StateProvider.autoDispose<int>((ref) => 0);
final inputTextProvider = StateProvider.autoDispose<String>((ref) => '');
final inputErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

/// Quest Detail Screen - Displays detailed information about a quest
/// Includes quest steps, description, and actions
class QuestDetail extends ConsumerStatefulWidget {
  final Quest quest;
  const QuestDetail(this.quest, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestDetailState();
}

class _QuestDetailState extends ConsumerState<QuestDetail> {
  Timer? _dwellTimer;
  Timer? _progressTimer;
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _dwellTimer?.cancel();
    _progressTimer?.cancel();
    _inputController.dispose();
    super.dispose();
  }

  String _getValidationTitle(QuestType type) {
    return 'Reach location to validate quest';
  }

  String _getTypeIcon(QuestType type) {
    return 'assets/svg/pin-alt.svg';
  }

  String _getTypeText(QuestType type) {
    return 'Location';
  }

  String _getRequirementIcon(QuestType type) {
    switch (type) {
      case QuestType.location:
      case QuestType.timeLocation:
        return 'assets/svg/grey-clock-2.svg';
      case QuestType.qr:
        return 'assets/svg/scan-grey.svg';
      case QuestType.input:
        return 'assets/svg/edit-grey.svg';
    }
  }

  String _getRequirementText(Quest quest) {
    switch (quest.stepType) {
      case QuestType.location:
      case QuestType.timeLocation:
        final minutes = quest.timeInSeconds != null
            ? (quest.timeInSeconds! / 60).round()
            : 5;
        return '$minutes min';
      case QuestType.qr:
        return 'QR code';
      case QuestType.input:
        return 'Input';
    }
  }

  String _getCompletionRequirement(QuestType type) {
    switch (type) {
      case QuestType.location:
      case QuestType.timeLocation:
        return 'Must remain on site for completion';
      case QuestType.qr:
        return 'QR code must be scanned on site';
      case QuestType.input:
        return 'Enter the correct phrase or code';
    }
  }

  /// Get button text based on quest state
  String _getButtonText() {
    final dwellMet = ref.watch(dwellMetProvider);
    final inRange = ref.watch(inRangeProvider);
    final questStarted = ref.watch(questStartedProvider);

    if (widget.quest.stepType == QuestType.location ||
        widget.quest.stepType == QuestType.timeLocation) {
      if (dwellMet) return 'Completed';
      if (inRange) return 'Hold Position';
      if (questStarted) return 'Navigate';
      return 'Start Adventure';
    } else if (widget.quest.stepType == QuestType.qr) {
      if (dwellMet) return 'Completed';
      if (inRange) return 'Scan QR';
      if (questStarted) return 'Navigate';
      return 'Start Adventure';
    } else if (widget.quest.stepType == QuestType.input) {
      if (dwellMet) return 'Completed';
      if (inRange) return 'Submit';
      if (questStarted) return 'Navigate';
      return 'Start Adventure';
    }

    return 'Start Adventure';
  }

  /// Get button onPressed callback based on quest state and type
  VoidCallback? _getButtonOnPressed() {
    final dwellMet = ref.watch(dwellMetProvider);
    final inRange = ref.watch(inRangeProvider);

    // Disable button when completed
    if (dwellMet) return null;

    if (widget.quest.stepType == QuestType.location ||
        widget.quest.stepType == QuestType.timeLocation) {
      // Location quest: disable during hold position
      if (inRange) return null;
      return _handleButtonPress;
    } else if (widget.quest.stepType == QuestType.qr) {
      // QR quest: keep enabled when in range
      return _handleButtonPress;
    } else if (widget.quest.stepType == QuestType.input) {
      // Input quest: keep enabled when in range for submit
      return _handleButtonPress;
    }

    return _handleButtonPress;
  }

  /// Handle button press based on current state and quest type
  void _handleButtonPress() {
    final dwellMet = ref.read(dwellMetProvider);
    final inRange = ref.read(inRangeProvider);
    final questStarted = ref.read(questStartedProvider);

    if (dwellMet) return; // Quest already completed

    if (!questStarted) {
      // Start the quest
      ref.read(questStartedProvider.notifier).state = true;
    } else if (!inRange) {
      // Simulate navigation (in real app, would open maps)
      // Enter range
      ref.read(inRangeProvider.notifier).state = true;

      // For location quest, start dwell timer
      if (widget.quest.stepType == QuestType.location ||
          widget.quest.stepType == QuestType.timeLocation) {
        _startDwellTimer();
      }
    } else if (inRange && widget.quest.stepType == QuestType.qr) {
      // QR quest: open scanner
      _openQRScanner();
    } else if (inRange && widget.quest.stepType == QuestType.input) {
      // Input quest: validate and submit
      _submitInput();
    }
  }

  /// Submit input and validate against expected answer
  void _submitInput() {
    final inputText = _inputController.text.trim();

    // Clear any previous error
    ref.read(inputErrorProvider.notifier).state = null;

    if (inputText.isEmpty) {
      ref.read(inputErrorProvider.notifier).state = 'Please enter an answer';
      return;
    }

    // TODO: Replace with actual expected answers from quest data
    // For now, using a hardcoded list of accepted answers (case-insensitive)
    final acceptedAnswers = ['secret', 'answer', 'xplora'];

    final isCorrect = acceptedAnswers.any(
      (answer) => answer.toLowerCase() == inputText.toLowerCase(),
    );

    if (isCorrect) {
      // Correct answer - complete the quest
      ref.read(dwellMetProvider.notifier).state = true;
      _showQuestCompletedDialog();
    } else {
      // Wrong answer - show error
      ref.read(inputErrorProvider.notifier).state =
          'Incorrect answer, try again';
    }
  }

  /// Open QR scanner and handle result
  Future<void> _openQRScanner() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    // Increment counter regardless of whether user scanned or closed
    final currentCount = ref.read(scannedQRsProvider);
    ref.read(scannedQRsProvider.notifier).state = currentCount + 1;

    // If all QRs scanned, complete quest
    const totalQRs = 3;
    if (currentCount + 1 >= totalQRs) {
      ref.read(dwellMetProvider.notifier).state = true;
      _showQuestCompletedDialog();
    }
  }

  /// Start the 5-second dwell timer when user enters range
  void _startDwellTimer() {
    const dwellDuration = Duration(seconds: 5);
    const progressUpdateInterval = Duration(milliseconds: 100);

    ref.read(dwellProgressProvider.notifier).state = 0.0;

    // Timer to update progress every 100ms
    int elapsed = 0;
    _progressTimer = Timer.periodic(progressUpdateInterval, (timer) {
      elapsed += progressUpdateInterval.inMilliseconds;
      final progress = elapsed / dwellDuration.inMilliseconds;

      if (progress >= 1.0) {
        ref.read(dwellProgressProvider.notifier).state = 1.0;
        timer.cancel();
      } else {
        ref.read(dwellProgressProvider.notifier).state = progress;
      }
    });

    // Timer to complete quest after 5 seconds
    _dwellTimer = Timer(dwellDuration, () {
      ref.read(dwellMetProvider.notifier).state = true;
      _progressTimer?.cancel();
      _showQuestCompletedDialog();
    });
  }

  /// Show quest completion dialog
  void _showQuestCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Go back to quests
          }
        },
        child: BaseDialog(
          dismissOnBarrierTap: false,
          icon: SvgPicture.asset(
            'assets/svg/xp.svg',
            width: 80,
            height: 80,
          ),
          title: 'Quest Completed!',
          description: 'You gained +${widget.quest.experience.toInt()} XP',
          actions: [
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Back to quests',
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to quests
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build a bullet point row
  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: context.colors.textPrimary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: spacing12),
        Expanded(
          child: Text(
            text,
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          hideBottomDivider: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: context.colors.iconColor,
                size: 32,
              ),
              onPressed: () {
                // TODO: Implement quest options menu (share, report, bookmark, etc.)
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quest Title
                Text(
                  widget.quest.title,
                  style: h1Style.copyWith(
                      color: context.colors.textPrimary, fontSize: 30),
                ),
                const SizedBox(height: spacing12),

                // Location info (TODO: Get from Place model)
                Row(
                  spacing: spacing8,
                  children: [
                    Text(
                      'Domes Beach',
                      style: bodySmallStyle.copyWith(
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '•',
                      style: bodySmallStyle.copyWith(
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.4),
                      ),
                    ),
                    Text(
                      'Rincon, PR',
                      style: bodySmallStyle.copyWith(
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacing12),

                // Action Row: XP Badge + Buttons
                Row(
                  children: [
                    // XP Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacing24,
                        vertical: 9.5,
                      ),
                      decoration: BoxDecoration(
                        color: brandSecondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(radiusLarge),
                        border: Border.all(
                          color: brandSecondary.withValues(alpha: 0.3),
                          width: borderWidthDefault,
                        ),
                      ),
                      child: Text(
                        '${widget.quest.experience.toInt()} XP',
                        style: bodyTextStyle.copyWith(
                          color: brandSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: spacing12),

                    // View place button
                    Expanded(
                      child: SecondaryButton(
                        text: 'View place',
                        onPressed: () {
                          // TODO: Navigate to place detail
                        },
                      ),
                    ),
                    const SizedBox(width: spacing12),

                    // Context pill button
                    Expanded(
                      child: SecondaryButton(
                        text: 'Context pill',
                        onPressed: () {
                          // TODO: Show context information
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacing16),

                // Long Description
                Text(
                  widget.quest.longDescription,
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: spacing24),

                // Quest Validation Info Card
                GlassContainer(
                  showBorder: false,
                  padding: const EdgeInsets.symmetric(
                      horizontal: spacing16, vertical: spacing12),
                  borderRadius: radiusLarge,
                  boxShadow: const [elevation1],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title based on quest type
                      Text(
                        _getValidationTitle(widget.quest.stepType),
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: spacing4),

                      // Quest type indicator (Location/QR/Secret)
                      Row(
                        children: [
                          SvgPicture.asset(
                            _getTypeIcon(widget.quest.stepType),
                            width: iconSizeMedium,
                            height: iconSizeMedium,
                            colorFilter: ColorFilter.mode(
                              context.colors.textPrimary.withValues(alpha: 0.7),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: spacing4),
                          Text(
                            _getTypeText(widget.quest.stepType),
                            style: bodySmallStyle.copyWith(
                              color: context.colors.textPrimary
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: spacing4),

                      // Duration/requirement indicator
                      Row(
                        children: [
                          SvgPicture.asset(
                            _getRequirementIcon(widget.quest.stepType),
                            width: iconSizeMedium,
                            height: iconSizeMedium,
                            colorFilter: ColorFilter.mode(
                              context.colors.textPrimary.withValues(alpha: 0.7),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: spacing4),
                          Text(
                            _getRequirementText(widget.quest),
                            style: bodySmallStyle.copyWith(
                              color: context.colors.textPrimary
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: spacing4),

                      // Additional info/hint
                      Text(
                        'Best visited during daylight hours',
                        style: bodySmallStyle.copyWith(
                          color:
                              context.colors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: spacing16),

                // How Completion Works Section
                GlassContainer(
                  showBorder: false,
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacing16,
                    vertical: spacing12,
                  ),
                  borderRadius: radiusLarge,
                  boxShadow: const [elevation1],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'How completion works',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: spacing4),

                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bullet point 1
                            _buildBulletPoint(
                                context, 'Location verified by GPS'),
                            const SizedBox(height: spacing4),

                            // Bullet point 2 (dynamic based on quest type)
                            _buildBulletPoint(
                              context,
                              _getCompletionRequirement(widget.quest.stepType),
                            ),
                            const SizedBox(height: spacing4),

                            // Bullet point 3
                            _buildBulletPoint(context, 'Hint'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: spacing16),

                // Quest Progress/Action Section (dynamic based on quest type)
                _QuestProgressSection(
                  questType: widget.quest.stepType,
                  isCompleted: widget.quest.userId != null,
                  inputController: _inputController,
                ),
                // Add bottom padding to account for the sticky button
                const SizedBox(height: spacing16),
              ],
            ),
          ),
        ),
        /*
        Location type quest:
        **CTA States:**
        - Before start → Start Adventure
        - After start, not in range → Navigate
        - In range → Hold Position
        - After dwell met → Completed (disabled)

        QR type quest:
        **CTA States:**
        - Before start → Start Adventure
        - Not in range → Navigate
        - In range → Scan QR
        - Opens celebratory pop up or user gets xp notifcation
        
        Notes
        - Inline Action Surface replaces any input field
        - CTA label mirrors the same action (Scan QR)
        - If scanned outside location → error toast
        
        Inline Action Surface
        **Visible only when user is in range**
        **Component:**
        QR Scan Row
        - Icon + label: “Scan QR code”
        - Muted helper text below
        - No camera preview in MVP (button opens scanner)

        Input type quest:
        **CTA States:**
        - Before start → Start Adventure
        - Not in range → Navigate
        - In range → Submit
        - Correct input → Completed
        Notes
        - Input field never appears before arrival
        - CTA performs submission (not the keyboard)
        - Visible only when user is in range
        **Component:**
        Input Field Panel
        - Single text input
        - Placeholder text
        - Space reserved for error message
        **Rules (annotation only):**
        - Case-insensitive
        - Multiple accepted answers possible
        */
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
            left: spacing16,
            right: spacing16,
            top: spacing12,
            bottom: MediaQuery.of(context).padding.bottom + spacing24,
          ),
          child: widget.quest.stepType == QuestType.location ||
                  widget.quest.stepType == QuestType.timeLocation ||
                  widget.quest.stepType == QuestType.qr ||
                  widget.quest.stepType == QuestType.input
              ? PrimaryButton(
                  text: _getButtonText(),
                  onPressed: _getButtonOnPressed(),
                )
              : PrimaryButton(
                  text: 'Start Adventure',
                  onPressed: () {
                    // TODO: Implement start adventure action for other quest types
                  },
                ),
        ),
      ),
    );
  }
}

/// Quest Progress Section widget - Shows different UI based on quest type
class _QuestProgressSection extends ConsumerWidget {
  final QuestType questType;
  final bool isCompleted;
  final TextEditingController? inputController;

  const _QuestProgressSection({
    required this.questType,
    required this.isCompleted,
    this.inputController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      showBorder: false,
      padding: const EdgeInsets.all(spacing16),
      borderRadius: radiusLarge,
      boxShadow: const [elevation1],
      child: _buildContent(context, ref),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    switch (questType) {
      case QuestType.location:
      case QuestType.timeLocation:
        final questStarted = ref.watch(questStartedProvider);
        final inRange = ref.watch(inRangeProvider);
        final dwellMet = ref.watch(dwellMetProvider);
        final dwellProgress = ref.watch(dwellProgressProvider);

        double progressValue = 0.0;
        String rightText = 'Waiting for arrival...';

        if (dwellMet) {
          progressValue = 1.0;
          rightText = 'Quest completed!';
        } else if (inRange) {
          // Show progress from 0.0 to 1.0 during dwell time
          progressValue = dwellProgress;
          rightText = 'Hold position...';
        } else if (questStarted) {
          progressValue = 0.0;
          rightText = 'Navigate to location';
        }

        return _buildProgressSection(
          context,
          progressValue: progressValue,
          leftContent: _buildIconText(
            context,
            'assets/svg/grey-clock-2.svg',
            '5 min',
          ),
          rightContent: Text(
            rightText,
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        );
      case QuestType.qr:
        final questStarted = ref.watch(questStartedProvider);
        final inRange = ref.watch(inRangeProvider);
        final dwellMet = ref.watch(dwellMetProvider);
        final scannedQRs = ref.watch(scannedQRsProvider);

        const totalQRs = 3;
        double progressValue = scannedQRs / totalQRs;

        Widget? leftContent;
        Widget? rightContent;

        if (dwellMet) {
          // Completed: quest completed on left, progress on right
          progressValue = 1.0;
          leftContent = Text(
            'Quest completed!',
            style: bodySmallStyle.copyWith(
              color: brandPrimary,
            ),
          );
          rightContent = Text(
            '$totalQRs/$totalQRs',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          );
        } else if (inRange) {
          // In range: "Scan QR code" on left, progress on right
          leftContent = _buildIconText(
            context,
            'assets/svg/scan-grey.svg',
            'Scan QR code',
            isUnderlined: true,
          );
          rightContent = Text(
            '$scannedQRs/$totalQRs',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          );
        } else if (questStarted) {
          // Not in range: "Find QR code" on left, progress on right
          leftContent = Text(
            'Find QR code',
            style: bodySmallStyle.copyWith(
              color: brandPrimary,
            ),
          );
          rightContent = Text(
            '$scannedQRs/$totalQRs',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          );
        } else {
          // Before start: "Find QR code" on left, nothing on right
          progressValue = 0.0;
          leftContent = Text(
            'Find QR code',
            style: bodySmallStyle.copyWith(
              color: brandPrimary,
            ),
          );
          rightContent = null;
        }

        return _buildProgressSection(
          context,
          progressValue: progressValue,
          leftContent: leftContent,
          rightContent: rightContent ?? const SizedBox.shrink(),
        );
      case QuestType.input:
        final questStarted = ref.watch(questStartedProvider);
        final inRange = ref.watch(inRangeProvider);
        final dwellMet = ref.watch(dwellMetProvider);
        final inputError = ref.watch(inputErrorProvider);

        double progressValue = dwellMet ? 1.0 : 0.0;
        Widget? leftContent;
        Widget? rightContent;

        if (dwellMet) {
          // Completed
          leftContent = _buildIconText(
            context,
            'assets/svg/edit-grey.svg',
            'Answer submitted',
          );
          rightContent = Text(
            'Quest completed!',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          );
        } else if (inRange) {
          // In range: show input field
          leftContent = Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                'assets/svg/edit-grey.svg',
                width: iconSizeMedium,
                height: iconSizeMedium,
                colorFilter: ColorFilter.mode(
                  inputError != null ? errorColor : brandPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: TextField(
                  controller: inputController,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    // Clear error when user types
                    if (ref.read(inputErrorProvider) != null) {
                      ref.read(inputErrorProvider.notifier).state = null;
                    }
                  },
                  // Use TextInputAction.done to just close keyboard
                  // Submission only happens via the CTA button, not keyboard
                  textInputAction: TextInputAction.done,
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter text here',
                    hintStyle: bodySmallStyle.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: inputError != null ? errorColor : brandPrimary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: inputError != null ? errorColor : brandPrimary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: inputError != null ? errorColor : brandPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          );
          rightContent = inputError != null
              ? Text(
                  inputError,
                  style: bodySmallStyle.copyWith(
                    color: errorColor,
                  ),
                )
              : const SizedBox.shrink();
        } else if (questStarted) {
          // Not in range: navigate
          leftContent = _buildIconText(
            context,
            'assets/svg/edit-grey.svg',
            'Enter answer on site',
          );
          rightContent = Text(
            'Navigate to location',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          );
        } else {
          // Before start
          leftContent = _buildIconText(
            context,
            'assets/svg/edit-grey.svg',
            'Enter answer on site',
          );
          rightContent = Text(
            'Waiting to start...',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          );
        }

        return _buildProgressSection(
          context,
          progressValue: progressValue,
          leftContent: leftContent,
          rightContent: rightContent,
        );
    }
  }

  /// Reusable progress section with progress bar and custom left/right content
  Widget _buildProgressSection(
    BuildContext context, {
    required double progressValue,
    required Widget leftContent,
    required Widget rightContent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: context.colors.bgTertiary,
          valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
          minHeight: 6,
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        const SizedBox(height: 20),

        // Content row
        Row(
          children: [
            Expanded(child: leftContent),
            const SizedBox(width: spacing24),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight, child: rightContent)),
          ],
        ),
      ],
    );
  }

  /// Reusable icon + text widget
  Widget _buildIconText(
    BuildContext context,
    String iconPath,
    String text, {
    bool isUnderlined = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          width: iconSizeMedium,
          height: iconSizeMedium,
          colorFilter: ColorFilter.mode(
            brandPrimary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            text,
            softWrap: true,
            style: bodySmallStyle.copyWith(
              color: brandPrimary,
              decoration: isUnderlined ? TextDecoration.underline : null,
              decorationColor: isUnderlined ? brandPrimary : null,
            ),
          ),
        ),
      ],
    );
  }
}
