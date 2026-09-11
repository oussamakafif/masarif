import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingText;
  final String? badgeText;

  const SectionHeader({super.key, required this.title, this.trailingText, this.badgeText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          if (badgeText != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
              child: Text(badgeText!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ),
          ],
          const Spacer(),
          if (trailingText != null)
            Text(trailingText!, style: const TextStyle(color: AppColors.primaryGreen, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
