import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/section_header.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  int _filterIndex = 1; // أكتوبر 2024 selected by default per mockup

  @override
  Widget build(BuildContext context) {
    final labels = ['سبتمبر 2024', 'أكتوبر 2024', 'الكل (4)'];
    return Scaffold(
      appBar: const AppTopBar(title: 'مصاريف', subtitle: 'Transfers'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                      const Expanded(child: Text('سجل التحويلات الواردة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
                        child: const Text('تحديث فوري', style: TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('متابعة الحوالات المالية المرسلة من المملكة العربية السعودية للجزائر',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.deepGreen, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('إجمالي الوارد خلال الفترة', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                              child: const Text('معتمد ومودع', style: TextStyle(color: Colors.white, fontSize: 9)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('القيمة بالريال السعودي', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  Text('14,550 ر.س', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('المعادل بالدينار الجزائري', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  Text('520,890 د.ج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('3 حوالات نشطة ومودعة هذا الشهر، عبر BaridiMob ومصرف الراجحي موب',
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: List.generate(labels.length, (i) {
                final selected = i == _filterIndex;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filterIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primaryGreen : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(labels[i],
                          style: TextStyle(color: selected ? Colors.white : AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            const SectionHeader(title: 'تفاصيل التحويلات', trailingText: 'عرض جميع التحويلات'),
            ...MockData.transfers.map((t) => _transferTile(t)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.textMuted, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('معلومات الصرف المرجعي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        Text(
                          'يُحتسب المعادل بالدينار الجزائري وفق سعر الصرف المعتمد للعائلة (${MockData.exchangeRateLabel}) لضمان الشفافية الكاملة.',
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _transferTile(TransferEntry t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.account_balance_wallet_outlined, size: 16, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.senderName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text(t.purpose,
                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('+${t.amountSar.toStringAsFixed(0)} ر.س', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 12)),
                  Text('+${t.amountDzd.toStringAsFixed(0)} د.ج', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(t.status, style: const TextStyle(color: AppColors.success, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              Text(t.date, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
