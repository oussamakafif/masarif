import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/member_progress_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _periodIndex = 2; // 0 الكل, 1 هذه السنة, 2 هذا الشهر

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'مصاريف', subtitle: 'Dashboard'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _periodTabs(),
            const SizedBox(height: 12),
            _totalCard(),
            const SizedBox(height: 12),
            _transfersCard(),
            const SizedBox(height: 16),
            const SectionHeader(title: 'إنفاق أفراد العائلة', badgeText: '3 أفراد نشطين'),
            ...MockData.members.map((m) => MemberProgressTile(member: m)),
            const SizedBox(height: 8),
            const SectionHeader(title: 'آخر المشتريات المسجلة', trailingText: 'عرض السجل كاملاً'),
            ...MockData.recentExpenses.map((e) => TransactionTile(expense: e)),
            const SizedBox(height: 16),
            _insightBanner(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _periodTabs() {
    final labels = ['الكل', 'هذه السنة', 'هذا الشهر'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == _periodIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _periodIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(labels[i],
                    style: TextStyle(color: selected ? Colors.white : AppColors.textMuted, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _totalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.algeriaAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: const Text('DZD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.algeriaAccent)),
              ),
              const Spacer(),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.pie_chart_outline_rounded, size: 16, color: AppColors.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('إجمالي مصاريف العائلة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const Text('الإنفاق المحلي المشترك للشهر الحالي', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text('142,500', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
              SizedBox(width: 4),
              Padding(padding: EdgeInsets.only(bottom: 4), child: Text('د.ج', style: TextStyle(fontSize: 14, color: AppColors.textMuted))),
            ],
          ),
          const Text('😊 يعادل تقريباً 3,980 ر.س', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.71,
              minHeight: 8,
              backgroundColor: AppColors.chipBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
          const SizedBox(height: 6),
          const Text('71% (مستقر وآمن) — استهلاك الميزانية الشهرية', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('متبقي: 57,500 د.ج', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              Text('سقف الشهر: 200,000 د.ج', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _transfersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.saudiAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: const Text('SAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.saudiAccent)),
              ),
              const Spacer(),
              const Icon(Icons.flight_takeoff_rounded, color: AppColors.saudiAccent, size: 18),
            ],
          ),
          const SizedBox(height: 4),
          const Text('الحوالات المستلمة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const Text('التحويلات المرسلة من السعودية', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text('4,850', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.gold)),
              SizedBox(width: 4),
              Padding(padding: EdgeInsets.only(bottom: 2), child: Text('ر.س', style: TextStyle(fontSize: 13, color: AppColors.textMuted))),
            ],
          ),
          const Text('يعادل 173,600 د.ج', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          const Row(children: [
            Icon(Icons.verified_outlined, size: 14, color: AppColors.success),
            SizedBox(width: 6),
            Expanded(child: Text('محولة لحساب العائلة بالجزائر، الرصيد المتاح كافٍ ومستقر', style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
          ]),
        ],
      ),
    );
  }

  Widget _insightBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.primaryGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.favorite_border_rounded, color: AppColors.primaryGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('تنسيق مالي عائلي متناغم', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                SizedBox(height: 2),
                Text(
                  'وفرت العائلة هذا الشهر 12% مقارنة بالشهر السابق من مصاريف التموين. ميزانيتكم تسير في مسار آمن ومبارك.',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
