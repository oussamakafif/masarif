import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MasarifBottomNav extends StatelessWidget {
  final int currentIndex; // 0 = home, 1 = transfers, 2 = analytics
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  const MasarifBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(icon: Icons.bar_chart_rounded, label: 'التحليلات', index: 2),
            _navItem(icon: Icons.swap_horiz_rounded, label: 'التحويلات', index: 1),
            GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
            _navItem(icon: Icons.grid_view_rounded, label: 'الرئيسية', index: 0),
          ],
        ),
      ),
    );
  }

  Widget _navItem({required IconData icon, required String label, required int index}) {
    final bool selected = currentIndex == index;
    final color = selected ? AppColors.primaryGreen : AppColors.textMuted;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }
}
