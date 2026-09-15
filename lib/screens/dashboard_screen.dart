import 'package:flutter/material.dart';
import '../services/dashboard_repository.dart';
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
  final _repository = DashboardRepository();
  late Future<DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchThisMonth();
  }

  void _refresh() {
    setState(() => _future = _repository.fetchThisMonth());
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
      appBar: const AppTopBar(title: 'مصاريف', subtitle: 'Dashboard'),
      body: SafeArea(
        top: false,
        child: FutureBuilder<DashboardData>(
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
                      Text('تعذر تحميل البيانات: ${snapshot.error}',
                          textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: _refresh, child: const Text('إعادة المحاولة')),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _totalCard(data),
                  const SizedBox(height: 12),
                  _transfersCard(data),
                  const SizedBox(height: 16),
                  SectionHeader(title: 'إنفاق أفراد العائلة', badgeText: '${data.members.length} أفراد نشطين'),
                  if (data.members.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('لا توجد مصاريف مسجلة هذا الشهر بعد', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    )
                  else
                    ...data.members.map((m) => MemberProgressTile(member: m)),
                  const SizedBox(height: 8),
                  const SectionHeader(title: 'آخر المشتريات المسجلة'),
                  if (data.recentExpenses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('لم يتم تسجيل أي مصروف بعد', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    )
                  else
                    ...data.recentExpenses.map((e) => TransactionTile(expense: e)),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _totalCard(DashboardData data) {
    final hasBudget = data.monthlyBudgetLimit != null && data.monthlyBudgetLimit! > 0;
    final pct = hasBudget ? (data.totalSpentThisMonth / data.monthlyBudgetLimit!).clamp(0.0, 1.0) : 0.0;
    final remaining = hasBudget ? data.monthlyBudgetLimit! - data.totalSpentThisMonth : 0.0;

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
                child: Text(data.baseCurrency, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.algeriaAccent)),
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
            children: [
              Text(_formatAmount(data.totalSpentThisMonth),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
              const SizedBox(width: 4),
              Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(data.baseCurrency == 'DZD' ? 'د.ج' : data.baseCurrency, style: const TextStyle(fontSize: 14, color: AppColors.textMuted))),
            ],
          ),
          if (hasBudget) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 8,
                backgroundColor: AppColors.chipBackground,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              ),
            ),
            const SizedBox(height: 6),
            Text('${(pct * 100).toStringAsFixed(0)}% استهلاك الميزانية الشهرية', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('متبقي: ${_formatAmount(remaining)} ${data.baseCurrency == 'DZD' ? 'د.ج' : data.baseCurrency}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                Text('سقف الشهر: ${_formatAmount(data.monthlyBudgetLimit!)} ${data.baseCurrency == 'DZD' ? 'د.ج' : data.baseCurrency}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ] else ...[
            const SizedBox(height: 6),
            const Text('لم يتم تحديد سقف شهري بعد', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ],
      ),
    );
  }

  Widget _transfersCard(DashboardData data) {
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
            children: [
              Text(_formatAmount(data.transfersSarThisMonth), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.gold)),
              const SizedBox(width: 4),
              const Padding(padding: EdgeInsets.only(bottom: 2), child: Text('ر.س', style: TextStyle(fontSize: 13, color: AppColors.textMuted))),
            ],
          ),
          Text('يعادل ${_formatAmount(data.transfersDzdThisMonth)} د.ج', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
