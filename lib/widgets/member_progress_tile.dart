import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';

class MemberProgressTile extends StatelessWidget {
  final FamilyMember member;

  const MemberProgressTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: member.avatarColor.withOpacity(0.15),
                child: Text(
                  member.name.substring(0, 1),
                  style: TextStyle(color: member.avatarColor, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(member.role, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              Text('${member.spentDzd.toStringAsFixed(0)} د.ج', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Text('${member.sharePercent.toStringAsFixed(0)}% من الإجمالي — ${member.context}',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: member.sharePercent / 100,
              minHeight: 6,
              backgroundColor: AppColors.chipBackground,
              valueColor: AlwaysStoppedAnimation<Color>(member.avatarColor),
            ),
          ),
        ],
      ),
    );
  }
}
