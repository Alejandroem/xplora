import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    const int currentStreak = 6;

    // Generate week days based on current streak
    final weekDays = List.generate(7, (index) => index < currentStreak);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // STREAK heading
        Text(
          'Streak',
          style: h2Style.copyWith(color: context.colors.textPrimary)
        ),
        const SizedBox(height: spacing8),
        GlassContainer(
          padding: const EdgeInsets.all(spacing16),
          child: Column(
            children: [
              /*
              // Streak count with custom arc progress
              SizedBox(
                width: spacing48 + spacing32, // 80
                height: spacing48 + spacing32, // 80
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Custom arc progress
                    CustomPaint(
                      size: const Size(spacing48 + spacing32, spacing48 + spacing32),
                      painter: _StreakArcPainter(
                        progress: currentStreak / 7,
                        backgroundColor: context.colors.border,
                        progressColor: context.colors.textPrimary,
                        strokeWidth: borderWidthDefault * 4,
                      ),
                    ),
                    // Streak number in center
                    Text(
                      '$currentStreak',
                      style: h1Style.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              */
              // Streak number
              GlassContainer(
                bgColor: context.colors.bgTertiary,
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing24,
                  vertical: spacing12,
                ),
                borderRadius: 100,
                child: Text(
                  '$currentStreak',
                  style: h1Style.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: spacing16),

              // Week days indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  final hasStreak = weekDays[index];
                  return _DayIndicator(hasStreak: hasStreak);
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayIndicator extends StatelessWidget {
  final bool hasStreak;

  const _DayIndicator({required this.hasStreak});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasStreak ? context.colors.textPrimary : Colors.transparent,
        border: Border.all(
          color: hasStreak ? Colors.transparent : context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      child: hasStreak
          ? Icon(
              Icons.check,
              size: 14,
              color: context.colors.bgPrimary,
            )
          : null,
    );
  }
}

/*
class _StreakArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _StreakArcPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Move center down to position arc lower
    final center = Offset(size.width / 2, (size.height / 2) + 8);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc (full semicircle from left to right)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start from left (180 degrees)
      pi, // Sweep 180 degrees to right
      false,
      backgroundPaint,
    );

    // Progress arc (fills from left to right based on progress)
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi, // Start from left (180 degrees)
        pi * progress, // Sweep based on progress (0 to 180 degrees)
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StreakArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
*/
