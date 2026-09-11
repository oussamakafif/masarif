import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  bool _rememberDevice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('مصاريف', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.primaryGreen)),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: AppColors.deepGreen, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.hub_outlined, color: Colors.white, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text('MASARIF', style: TextStyle(fontSize: 11, color: AppColors.textMuted, letterSpacing: 1)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
                child: const Text('البوابة العائلية الموحدة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 20),
              const Text('مرحباً بك مجدداً', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
              const SizedBox(height: 4),
              const Text('سجّل الدخول لمتابعة ميزانية ونفقات العائلة', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('رقم الهاتف أو البريد الإلكتروني', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'مثال: 0555123456 أو name@email.com',
                        prefixText: '+213 / +966   ',
                        prefixStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        suffixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('كلمة المرور', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.lock_outline),
                        prefixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('نسيت كلمة المرور؟', style: TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        const Text('تذكرني على هذا الجهاز', style: TextStyle(fontSize: 12)),
                        Switch(
                          value: _rememberDevice,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (v) => setState(() => _rememberDevice = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
                      },
                      icon: const Icon(Icons.lock_open_rounded),
                      label: const Text('تسجيل الدخول'),
                    ),
                    const SizedBox(height: 10),
                    const Row(children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('أو', style: TextStyle(color: AppColors.textMuted))),
                      Expanded(child: Divider()),
                    ]),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
                      },
                      icon: const Icon(Icons.fingerprint_rounded),
                      label: const Text('الدخول السريع بالبصمة أو الوجه'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.chipBackground),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                  SizedBox(width: 6),
                  Text('بيانات مالية مشفرة ومحمية بأعلى معايير الأمان', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
