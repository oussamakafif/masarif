import 'package:flutter/material.dart';
import 'analytics_screen.dart';
import 'dashboard_screen.dart';
import 'log_expense_screen.dart';
import 'transfers_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0; // 0 = home/dashboard, 1 = transfers, 2 = analytics

  final _screens = const [
    DashboardScreen(),
    TransfersScreen(),
    AnalyticsScreen(),
  ];

  void _openLogExpense() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LogExpenseScreen(), fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: MasarifBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        onAddPressed: _openLogExpense,
      ),
    );
  }
}
