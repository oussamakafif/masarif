import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/member_progress_tile.dart';
import '../widgets/section_header.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _periodIndex = 2;

  @override
  Widget build(BuildContext context) {
    final labels = ['الكل', 'هذه السنة', 'هذا الشهر'];
    return Scaffold(
      appBar: const AppTopBar(title: 'مصاريف', subtitle: 'Analytics'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('تحليلات المصاريف', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primaryGreen)),
            const Text('رؤية شاملة وتفصيلية لمصاريف وتوازن العائلة', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.groups_2_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text('${MockData.familyName} · الجزائر ↔ الرياض', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ]),
            ),
            const SizedBox(height: 14),
            Container(
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
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('الرصيد المتبقي المتاح للأسرة', style: TextStyle(fontSize: 12, color: AppColors.textMuted))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                        child: const Text('توازن سليم', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const Text('31,100+ د.ج', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('التحويلات الواردة', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text('4,850 ر.س', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المصاريف الشهرية', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text('142,500 د.ج', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'إنفاق أفراد العائلة', badgeText: '3 مسجلين'),
            ...MockData.members.map((m) => MemberProgressTile(member: m)),
            const SizedBox(height: 8),
            const SectionHeader(title: 'توزيع المصاريف حسب الأبواب'),
            _categoryBar(),
            const SizedBox(height: 10),
            ...MockData.categoryBreakdown.map((c) => _categoryLegendRow(c)),
            const SizedBox(height: 16),
            const SectionHeader(title: 'أعلى المواد والمنتجات استهلاكاً'),
            ...MockData.topProducts.map((p) => _productTile(p)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: AppColors.gold),
                  SizedBox(width: 10),
                  Expanded(child: Text('تلميح ذكي: انخفضت مصاريف المواصلات والوقود بنسبة 14% مقارنة بالشهر السابق.', style: TextStyle(fontSize: 11))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('تصدير تقرير التحليلات الشامل (PDF)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _categoryBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 14,
        child: Row(
          children: MockData.categoryBreakdown.map((c) => Expanded(flex: c.percent.round(), child: Container(color: c.color))).toList(),
        ),
      ),
    );
  }

  Widget _categoryLegendRow(CategoryShare c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: c.color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(c.label, style: const TextStyle(fontSize: 12))),
          Text('(${c.percent.toStringAsFixed(0)}%) ${c.amountDzd.toStringAsFixed(0)} د.ج', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _productTile(ProductStat p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                Text('${p.categoryLabel} · ${p.purchaseCount} مرات شراء', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text('${p.totalDzd.toStringAsFixed(0)} د.ج', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }
}
