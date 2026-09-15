import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_icon_map.dart';
import '../models/mock_data.dart'; // reuse the FamilyMember / ExpenseEntry classes

class DashboardData {
  final String householdName;
  final String baseCurrency;
  final double totalSpentThisMonth;
  final double? monthlyBudgetLimit;
  final double transfersSarThisMonth;
  final double transfersDzdThisMonth;
  final List<FamilyMember> members;
  final List<ExpenseEntry> recentExpenses;

  DashboardData({
    required this.householdName,
    required this.baseCurrency,
    required this.totalSpentThisMonth,
    required this.monthlyBudgetLimit,
    required this.transfersSarThisMonth,
    required this.transfersDzdThisMonth,
    required this.members,
    required this.recentExpenses,
  });
}

class DashboardRepository {
  final _client = Supabase.instance.client;

  static const _memberPalette = [
    Color(0xFF2F8F5C),
    Color(0xFFDDA53B),
    Color(0xFF2F8F9D),
    Color(0xFFE08E45),
  ];

  Future<DashboardData> fetchThisMonth() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('No signed-in user — call this after login.');
    }

    // 1. Which household is this user in?
    final membership = await _client
        .from('household_members')
        .select('household_id')
        .eq('user_id', userId)
        .limit(1)
        .single();
    final householdId = membership['household_id'] as String;

    final household = await _client
        .from('households')
        .select('name, base_currency')
        .eq('id', householdId)
        .single();
    final baseCurrency = household['base_currency'] as String? ?? 'DZD';

    final now = DateTime.now();

    // 2. Per-member spending, from the v_member_spending view — filter to this month client-side
    final memberRows = await _client
        .from('v_member_spending')
        .select('user_id, full_name, period, total_spent, items_count, spending_pct')
        .eq('household_id', householdId);

    final thisMonthRows = memberRows.where((row) {
      final period = DateTime.parse(row['period'] as String);
      return period.year == now.year && period.month == now.month;
    }).toList();

    final members = <FamilyMember>[];
    for (var i = 0; i < thisMonthRows.length; i++) {
      final row = thisMonthRows[i];
      members.add(FamilyMember(
        name: row['full_name'] as String? ?? 'مستخدم',
        role: '',
        context: '${row['items_count']} مادة مسجلة',
        spentDzd: (row['total_spent'] as num).toDouble(),
        sharePercent: (row['spending_pct'] as num?)?.toDouble() ?? 0,
        avatarColor: _memberPalette[i % _memberPalette.length],
      ));
    }
    members.sort((a, b) => b.spentDzd.compareTo(a.spentDzd));

    final totalSpent = members.fold<double>(0, (sum, m) => sum + m.spentDzd);

    // 3. Household-wide monthly budget ceiling (category_id and user_id both null = whole household)
    final budgetRows = await _client
        .from('budgets')
        .select('amount_limit')
        .eq('household_id', householdId)
        .eq('period', 'monthly')
        .isFilter('category_id', null)
        .isFilter('user_id', null)
        .limit(1);
    final budgetLimit =
        budgetRows.isNotEmpty ? (budgetRows.first['amount_limit'] as num).toDouble() : null;

    // 4. Transfers received this month
    final transferRows = await _client
        .from('transfers')
        .select('amount, currency, exchange_rate_to_base, created_at')
        .eq('household_id', householdId);

    double sar = 0;
    double dzd = 0;
    for (final row in transferRows) {
      final created = DateTime.parse(row['created_at'] as String);
      if (created.year != now.year || created.month != now.month) continue;
      final amount = (row['amount'] as num).toDouble();
      final rate = (row['exchange_rate_to_base'] as num?)?.toDouble() ?? 1;
      final currency = row['currency'] as String?;
      if (currency == 'SAR') sar += amount;
      dzd += (currency == baseCurrency) ? amount : amount * rate;
    }

    // 5. Recent expenses (last 5, any month), joined with category + buyer name
    final expenseRows = await _client
        .from('expenses')
        .select(
            'item_name, amount, currency, exchange_rate_to_base, created_at, categories(name, icon, color), profiles(full_name)')
        .eq('household_id', householdId)
        .order('created_at', ascending: false)
        .limit(5);

    final recentExpenses = expenseRows.map<ExpenseEntry>((row) {
      final amount = (row['amount'] as num).toDouble();
      final rate = (row['exchange_rate_to_base'] as num?)?.toDouble() ?? 1;
      final currency = row['currency'] as String?;
      final amountBase = (currency == baseCurrency) ? amount : amount * rate;
      final category = row['categories'] as Map<String, dynamic>?;
      final buyer = row['profiles'] as Map<String, dynamic>?;
      final createdAt = DateTime.parse(row['created_at'] as String);
      return ExpenseEntry(
        itemName: row['item_name'] as String? ?? '',
        amountDzd: amountBase,
        categoryLabel: category?['name'] as String? ?? 'غير مصنف',
        categoryIcon: iconForCategoryKey(category?['icon'] as String?),
        categoryColor: colorFromHex(category?['color'] as String?),
        buyerName: buyer?['full_name'] as String? ?? '',
        date: '${createdAt.day}/${createdAt.month}/${createdAt.year}',
      );
    }).toList();

    return DashboardData(
      householdName: household['name'] as String? ?? '',
      baseCurrency: baseCurrency,
      totalSpentThisMonth: totalSpent,
      monthlyBudgetLimit: budgetLimit,
      transfersSarThisMonth: sar,
      transfersDzdThisMonth: dzd,
      members: members,
      recentExpenses: recentExpenses,
    );
  }
}
