import 'package:supabase_flutter/supabase_flutter.dart';

class TransferItem {
  final String senderName;
  final double amount;
  final String currency;
  final double amountBase;
  final String? note;
  final DateTime createdAt;

  TransferItem({
    required this.senderName,
    required this.amount,
    required this.currency,
    required this.amountBase,
    required this.note,
    required this.createdAt,
  });
}

class TransfersData {
  final String baseCurrency;
  final double totalSarThisMonth;
  final double totalBaseThisMonth;
  final int countThisMonth;
  final List<TransferItem> items; // all transfers, most recent first

  TransfersData({
    required this.baseCurrency,
    required this.totalSarThisMonth,
    required this.totalBaseThisMonth,
    required this.countThisMonth,
    required this.items,
  });
}

class TransfersRepository {
  final _client = Supabase.instance.client;

  Future<TransfersData> fetchAll() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('No signed-in user — call this after login.');
    }

    final membership = await _client
        .from('household_members')
        .select('household_id')
        .eq('user_id', userId)
        .limit(1)
        .single();
    final householdId = membership['household_id'] as String;

    final household = await _client
        .from('households')
        .select('base_currency')
        .eq('id', householdId)
        .single();
    final baseCurrency = household['base_currency'] as String? ?? 'DZD';

    final rows = await _client
        .from('transfers')
        .select('from_user_id, amount, currency, exchange_rate_to_base, note, created_at')
        .eq('household_id', householdId)
        .order('created_at', ascending: false);

    // Fetch sender names separately (transfers has two FKs to profiles,
    // from_user_id and to_user_id, so automatic relationship embedding
    // would be ambiguous — this avoids that entirely).
    final senderIds = rows.map((r) => r['from_user_id'] as String?).whereType<String>().toSet().toList();
    final Map<String, String> nameById = {};
    if (senderIds.isNotEmpty) {
      final profileRows = await _client.from('profiles').select('id, full_name').inFilter('id', senderIds);
      for (final p in profileRows) {
        nameById[p['id'] as String] = p['full_name'] as String? ?? '';
      }
    }

    final now = DateTime.now();
    double totalSar = 0;
    double totalBaseThisMonth = 0;
    int countThisMonth = 0;
    final items = <TransferItem>[];

    for (final row in rows) {
      final amount = (row['amount'] as num).toDouble();
      final currency = row['currency'] as String? ?? baseCurrency;
      final rate = (row['exchange_rate_to_base'] as num?)?.toDouble() ?? 1;
      final amountBase = currency == baseCurrency ? amount : amount * rate;
      final createdAt = DateTime.parse(row['created_at'] as String);
      final senderId = row['from_user_id'] as String?;

      items.add(TransferItem(
        senderName: nameById[senderId] ?? 'محوّل غير معروف',
        amount: amount,
        currency: currency,
        amountBase: amountBase,
        note: row['note'] as String?,
        createdAt: createdAt,
      ));

      if (createdAt.year == now.year && createdAt.month == now.month) {
        countThisMonth++;
        totalBaseThisMonth += amountBase;
        if (currency == 'SAR') totalSar += amount;
      }
    }

    return TransfersData(
      baseCurrency: baseCurrency,
      totalSarThisMonth: totalSar,
      totalBaseThisMonth: totalBaseThisMonth,
      countThisMonth: countThisMonth,
      items: items,
    );
  }
}
