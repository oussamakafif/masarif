import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'currency_badge.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool showProfileIcon;

  const AppTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.showProfileIcon = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (showProfileIcon)
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.chipBackground,
                child: const Icon(Icons.person_outline, color: AppColors.textDark, size: 18),
              )
            else
              const SizedBox(width: 36),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
            const Spacer(),
            const CurrencyBadges(),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.account_balance_outlined, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
