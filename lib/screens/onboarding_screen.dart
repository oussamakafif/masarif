import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.deepGreen,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8))],
                ),
                child: const Icon(Icons.hub_outlined, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('مَصَارِف', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
              const SizedBox(height: 4),
              const Text('— MASARIF OASIS —',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 1.2)),
              const SizedBox(height: 8),
              const Text(
                'إدارة مصاريف العائلة بوضوح وسهولة بين الجزائر والسعودية',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _countryChip('السعودية', 'ريال سعودي', 'SAR', AppColors.saudiAccent),
                        const Icon(Icons.sync_alt_rounded, color: AppColors.textMuted),
                        _countryChip('الجزائر', 'دينار جزائري', 'DZD', AppColors.algeriaAccent),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('شفافية تامة للعائلة', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        Row(children: [
                          Icon(Icons.circle, size: 6, color: AppColors.primaryGreen),
                          SizedBox(width: 4),
                          Text('مزامنة فورية ومباشرة', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _featureRow(Icons.receipt_long_outlined, 'تتبع فوري لمصاريف المنزل', 'سجل منظم للمشتريات والفواتير اليومية'),
              _featureRow(Icons.currency_exchange_rounded, 'ربط متوازن بين العملتين', 'حساب دقيق لفرق الصرف والتحويلات'),
              _featureRow(Icons.groups_2_outlined, 'تنسيق مالي عائلي مشترك', 'ميزانية واضحة تجمع شمل الأسرة باطمئنان'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('تسجيل الدخول إلى العائلة'),
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                  SizedBox(width: 6),
                  Text('بوابة عائلية خاصة ومحمية بأعلى معايير الأمان', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _countryChip(String country, String currencyName, String code, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
          child: Text(code, style: TextStyle(fontWeight: FontWeight.w800, color: color)),
        ),
        const SizedBox(height: 6),
        Text(country, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        Text(currencyName, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: AppColors.primaryGreen),
            ),
          ],
        ),
      ),
    );
  }
}
