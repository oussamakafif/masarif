import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final ExpenseEntry expense;
  const TransactionTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: expense.categoryColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(expense.categoryIcon, color: expense.categoryColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.itemName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
                      child: Text(expense.categoryLabel, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    ),
                    Text('${expense.buyerName} · ${expense.date}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          Text('-${expense.amountDzd.toStringAsFixed(0)} د.ج',
              style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
