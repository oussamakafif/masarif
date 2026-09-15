import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';

class LogExpenseScreen extends StatefulWidget {
  const LogExpenseScreen({super.key});

  @override
  State<LogExpenseScreen> createState() => _LogExpenseScreenState();
}

class _LogExpenseScreenState extends State<LogExpenseScreen> {
  bool _isDzd = true;
  final _amountController = TextEditingController(text: '0');
  final _itemController = TextEditingController();
  int _categoryIndex = 2; // التموين والبقالة selected by default, matching mockup
  int _payerIndex = 0;

  @override
  void dispose() {
    _amountController.dispose();
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        title: const Text('تسجيل مصروف جديد', style: TextStyle(fontSize: 15)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('يُضاف فوراً إلى ميزانية العائلة المشتركة',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _currencyToggle('ر.س (السعودية)', !_isDzd, () => setState(() => _isDzd = false))),
                const SizedBox(width: 8),
                Expanded(child: _currencyToggle('د.ج (الجزائر)', _isDzd, () => setState(() => _isDzd = true))),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text('المبلغ المدفوع', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primaryGreen),
                    decoration: const InputDecoration(border: InputBorder.none, suffixText: 'د.ج'),
                  ),
                  const SizedBox(height: 6),
                  const Text('يعادل تقريباً: 107.50 ر.س (1 ر.س ≈ 35.8 د.ج)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('اسم المنتج أو المادة المستهلكة *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                hintText: 'مستلزمات البيت الأسبوعية',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: MockData.quickSuggestions
                  .map((s) => ActionChip(
                        label: Text(s, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.chipBackground,
                        onPressed: () => setState(() => _itemController.text = s),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text('اختر تصنيف المصروف', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
              children: List.generate(MockData.expenseCategories.length, (i) {
                final cat = MockData.expenseCategories[i];
                final selected = i == _categoryIndex;
                return GestureDetector(
                  onTap: () => setState(() => _categoryIndex = i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryGreen.withOpacity(0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? AppColors.primaryGreen : Colors.transparent, width: 1.4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat['icon'] as IconData, color: selected ? AppColors.primaryGreen : AppColors.textMuted),
                        const SizedBox(height: 6),
                        Text(cat['label'] as String,
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('من قام بالدفع؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 8),
            ...List.generate(MockData.payers.length, (i) {
              final payer = MockData.payers[i];
              final selected = i == _payerIndex;
              return GestureDetector(
                onTap: () => setState(() => _payerIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryGreen.withOpacity(0.12) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? AppColors.primaryGreen : Colors.transparent, width: 1.4),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.chipBackground,
                        child: Text(payer['name']!.substring(0, 1),
                            style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(payer['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            Text(payer['desc']!, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      if (selected) const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 18),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('إرفاق صورة الوصل (اختياري)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.chipBackground),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('حفظ المصروف وتحديث لوحة التحكم'),
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتم خصم المبلغ فوراً وإتاحته في سجل العائلة بالجزائر والرياض',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currencyToggle(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }
}
