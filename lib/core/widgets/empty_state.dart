import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';

/// A premium visual prompt shown when a day has no scheduled events.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.message = 'No events scheduled for this day',
    this.subtitle = 'Tap a different date or create a new event.',
  });

  final String message;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Floating calendar icon design
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.15),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.calendarOff,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: AppTextStyles.subtitle(context).copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.getTextPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTextStyles.caption(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
