import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/models/quest.dart';
import '../../theme.dart';

/// Quest Detail Screen - Displays detailed information about a quest
/// Includes quest steps, description, and actions
class QuestDetail extends ConsumerStatefulWidget {
  final Quest quest;
  const QuestDetail(this.quest, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestDetailState();
}

class _QuestDetailState extends ConsumerState<QuestDetail> {
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
        - If scanned outside location → error toast (not designed here)
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
        - Error state: red helper text under input
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
          child: PrimaryButton(
            text: 'Start Adventure',
            onPressed: () {
              // TODO: Implement start adventure action
            },
          ),
        ),
      ),
    );
  }
}

/// Quest Progress Section widget - Shows different UI based on quest type
class _QuestProgressSection extends StatelessWidget {
  final QuestType questType;
  final bool isCompleted;

  const _QuestProgressSection({
    required this.questType,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      showBorder: false,
      padding: const EdgeInsets.all(spacing16),
      borderRadius: radiusLarge,
      boxShadow: const [elevation1],
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (questType) {
      case QuestType.location:
      case QuestType.timeLocation:
        return _buildProgressSection(
          context,
          progressValue: 0.0,
          leftContent: _buildIconText(
            context,
            'assets/svg/grey-clock-2.svg',
            '5 min',
          ),
          rightContent: Text(
            'Waiting for arrival...',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        );
      case QuestType.qr:
        return _buildProgressSection(
          context,
          progressValue: 0.33,
          leftContent: _buildIconText(
            context,
            'assets/svg/scan-grey.svg',
            'Scan QR code',
            isUnderlined: true,
          ),
          rightContent: Text(
            '1/3',
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        );
      case QuestType.input:
        return _buildProgressSection(
          context,
          progressValue: 0.0,
          leftContent: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                'assets/svg/edit-grey.svg',
                width: iconSizeMedium,
                height: iconSizeMedium,
                colorFilter: ColorFilter.mode(
                  brandPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: TextField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: brandPrimary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: brandPrimary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: brandPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          rightContent: Text(
            '(error text space)',
            style: bodySmallStyle.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
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
        Text(
          text,
          style: bodySmallStyle.copyWith(
            color: brandPrimary,
            decoration: isUnderlined ? TextDecoration.underline : null,
            decorationColor: isUnderlined ? brandPrimary : null,
          ),
        ),
      ],
    );
  }
}
