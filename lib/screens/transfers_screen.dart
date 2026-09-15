import 'package:flutter/material.dart';
import '../services/transfers_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/section_header.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  final _repository = TransfersRepository();
  late Future<TransfersData> _future;
  bool _thisMonthOnly = true;

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchAll();
  }

  void _refresh() {
    setState(() => _future = _repository.fetchAll());
  }

  String _formatAmount(double value) {
    final rounded = value.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < rounded.length; i++) {
      if (i > 0 && (rounded.length - i) % 3 == 0) buffer.write(',');
      buffer.write(rounded[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'مصاريف', subtitle: 'Transfers'),
      body: SafeArea(
        top: false,
        child: FutureBuilder<TransfersData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 32),
                      const SizedBox(height: 8),
                      Text('تعذر تحميل التحويلات: ${snapshot.error}',
                          textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: _refresh, child: const Text('إعادة المحاولة')),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data!;
            final now = DateTime.now();
            final visibleItems = _thisMonthOnly
                ? data.items.where((t) => t.createdAt.year == now.year && t.createdAt.month == now.month).toList()
                : data.items;

            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _summaryCard(data),
                  const SizedBox(height: 14),
                  _filterTabs(),
                  const SizedBox(height: 8),
                  const SectionHeader(title: 'تفاصيل التحويلات'),
                  if (visibleItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('لا توجد تحويلات مسجلة', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    )
                  else
                    ...visibleItems.map((t) => _transferTile(t)),
                  const SizedBox(height: 8),
                  _infoBox(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard(TransfersData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('سجل التحويلات الواردة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
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
                const Text('إجمالي الوارد هذا الشهر', style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('بالريال السعودي', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text('${_formatAmount(data.totalSarThisMonth)} ر.س',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('المعادل بـ${data.baseCurrency}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                          Text('${_formatAmount(data.totalBaseThisMonth)} ${data.baseCurrency == 'DZD' ? 'د.ج' : data.baseCurrency}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${data.countThisMonth} حوالة هذا الشهر', style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterTabs() {
    return Row(
      children: [
        _filterChip('هذا الشهر', _thisMonthOnly, () => setState(() => _thisMonthOnly = true)),
        const SizedBox(width: 8),
        _filterChip('الكل', !_thisMonthOnly, () => setState(() => _thisMonthOnly = false)),
      ],
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _transferTile(TransferItem t) {
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
                    if (t.note != null && t.note!.isNotEmpty)
                      Text(t.note!, style: const TextStyle(fontSize: 10, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('+${_formatAmount(t.amount)} ${t.currency}',
                      style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 12)),
                  Text('+${_formatAmount(t.amountBase)} د.ج', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.textMuted, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'يُحتسب المعادل بالعملة المحلية وفق سعر الصرف المسجّل وقت كل حوالة على حدة.',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
