import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FamilyMember {
  final String name;
  final String role;
  final String context;
  final double spentDzd;
  final double sharePercent;
  final Color avatarColor;

  const FamilyMember({
    required this.name,
    required this.role,
    required this.context,
    required this.spentDzd,
    required this.sharePercent,
    required this.avatarColor,
  });
}

class ExpenseEntry {
  final String itemName;
  final double amountDzd;
  final String categoryLabel;
  final IconData categoryIcon;
  final Color categoryColor;
  final String buyerName;
  final String date;

  const ExpenseEntry({
    required this.itemName,
    required this.amountDzd,
    required this.categoryLabel,
    required this.categoryIcon,
    required this.categoryColor,
    required this.buyerName,
    required this.date,
  });
}

class TransferEntry {
  final String senderName;
  final String senderLocation;
  final double amountSar;
  final double amountDzd;
  final String purpose;
  final String status;
  final String date;
  final String method;

  const TransferEntry({
    required this.senderName,
    required this.senderLocation,
    required this.amountSar,
    required this.amountDzd,
    required this.purpose,
    required this.status,
    required this.date,
    required this.method,
  });
}

class CategoryShare {
  final String label;
  final double amountDzd;
  final double percent;
  final Color color;

  const CategoryShare({
    required this.label,
    required this.amountDzd,
    required this.percent,
    required this.color,
  });
}

class ProductStat {
  final String name;
  final double totalDzd;
  final String categoryLabel;
  final int purchaseCount;

  const ProductStat({
    required this.name,
    required this.totalDzd,
    required this.categoryLabel,
    required this.purchaseCount,
  });
}

class MockData {
  static const familyName = 'عائلة آل ناصر';
  static const exchangeRateLabel = '1 ر.س ≈ 35.80 د.ج';

  static const List<FamilyMember> members = [
    FamilyMember(
      name: 'فاطمة',
      role: 'الأم',
      context: 'الجزائر العاصمة، 28 مادة مسجلة',
      spentDzd: 76200,
      sharePercent: 53,
      avatarColor: Color(0xFF2F8F5C),
    ),
    FamilyMember(
      name: 'ياسمين',
      role: 'الابنة، طالبة جامعة',
      context: 'جامعة باب الزوار، 14 مادة مسجلة',
      spentDzd: 38400,
      sharePercent: 27,
      avatarColor: Color(0xFFDDA53B),
    ),
    FamilyMember(
      name: 'أحمد',
      role: 'الابن، ثانوية',
      context: 'الثانوية، 9 مواد مسجلة',
      spentDzd: 27900,
      sharePercent: 20,
      avatarColor: Color(0xFF2F8F9D),
    ),
  ];

  static const List<ExpenseEntry> recentExpenses = [
    ExpenseEntry(
      itemName: 'مستلزمات التموين والبيت الأسبوعية',
      amountDzd: 6400,
      categoryLabel: 'التموين والبقالة',
      categoryIcon: Icons.shopping_cart_outlined,
      categoryColor: AppColors.catGroceries,
      buyerName: 'فاطمة (الأم)',
      date: 'اليوم، 10:30 ص',
    ),
    ExpenseEntry(
      itemName: 'دواء الضغط والتحاليل الطبية',
      amountDzd: 3850,
      categoryLabel: 'الصحة والصيدلية',
      categoryIcon: Icons.medical_services_outlined,
      categoryColor: AppColors.catHealth,
      buyerName: 'ياسمين',
      date: 'أمس، 04:15 م',
    ),
    ExpenseEntry(
      itemName: 'اشتراك الإنترنت المنزلي وفا',
      amountDzd: 5200,
      categoryLabel: 'الفواتير والخدمات',
      categoryIcon: Icons.bolt_outlined,
      categoryColor: AppColors.catBills,
      buyerName: 'فاطمة (الأم)',
      date: '28 أكتوبر',
    ),
    ExpenseEntry(
      itemName: 'كتب ومراجع دراسية للقانون',
      amountDzd: 4500,
      categoryLabel: 'مصروفات شخصية',
      categoryIcon: Icons.menu_book_outlined,
      categoryColor: AppColors.catFood,
      buyerName: 'ياسمين',
      date: '26 أكتوبر',
    ),
    ExpenseEntry(
      itemName: 'بطاقة اشتراك المترو والحافلات',
      amountDzd: 1800,
      categoryLabel: 'المواصلات',
      categoryIcon: Icons.directions_bus_outlined,
      categoryColor: AppColors.catTransport,
      buyerName: 'أحمد',
      date: '24 أكتوبر',
    ),
  ];

  static const List<TransferEntry> transfers = [
    TransferEntry(
      senderName: 'الأب (عمر - الرياض)',
      senderLocation: 'الرياض',
      amountSar: 4850,
      amountDzd: 173630,
      purpose: 'حساب العائلة بالجزائر (ميزانية شهر أكتوبر الأساسية)',
      status: 'تم الإيداع',
      date: '15 أكتوبر 2024، 10:30 ص',
      method: 'BaridiMob',
    ),
    TransferEntry(
      senderName: 'الأب (عمر - الرياض)',
      senderLocation: 'الرياض',
      amountSar: 2000,
      amountDzd: 71600,
      purpose: 'حساب ياسمين (مصاريف دراسية وجامعية)',
      status: 'تم الاستلام بنجاح',
      date: '01 أكتوبر 2024',
      method: 'الراجحي موب',
    ),
    TransferEntry(
      senderName: 'الأم (الرياض)',
      senderLocation: 'الرياض',
      amountSar: 3500,
      amountDzd: 125300,
      purpose: 'ميزانية العائلة (ميزانية الصيانة والأجهزة)',
      status: 'تم الإيداع بنجاح',
      date: '22 سبتمبر 2024',
      method: 'BaridiMob',
    ),
    TransferEntry(
      senderName: 'الأب (عمر - الرياض)',
      senderLocation: 'الرياض',
      amountSar: 4200,
      amountDzd: 150360,
      purpose: 'ميزانية سبتمبر العائلية',
      status: 'تم الإيداع بنجاح',
      date: '01 سبتمبر 2024',
      method: 'الراجحي موب',
    ),
  ];

  static const List<CategoryShare> categoryBreakdown = [
    CategoryShare(label: 'التموين والبقالة', amountDzd: 58400, percent: 41, color: AppColors.catGroceries),
    CategoryShare(label: 'الفواتير والخدمات', amountDzd: 32000, percent: 22, color: AppColors.catBills),
    CategoryShare(label: 'المطاعم والضيافة', amountDzd: 24100, percent: 17, color: AppColors.catFood),
    CategoryShare(label: 'الصحة والصيدلية', amountDzd: 16500, percent: 12, color: AppColors.catHealth),
    CategoryShare(label: 'المواصلات والوقود', amountDzd: 11500, percent: 8, color: AppColors.catTransport),
  ];

  static const List<ProductStat> topProducts = [
    ProductStat(name: 'دواء الضغط والتحاليل الدورية', totalDzd: 15400, categoryLabel: 'الصحة', purchaseCount: 4),
    ProductStat(name: 'حليب ومشتقات الألبان الأسبوعية', totalDzd: 12800, categoryLabel: 'التموين', purchaseCount: 8),
    ProductStat(name: 'اشتراك الإنترنت المنزلي فايبر', totalDzd: 10400, categoryLabel: 'الفواتير', purchaseCount: 2),
    ProductStat(name: 'مستلزمات ولحوم التموين الشهري', totalDzd: 9600, categoryLabel: 'التموين', purchaseCount: 3),
    ProductStat(name: 'بنزين وتعبئة وقود السيارة', totalDzd: 7500, categoryLabel: 'المواصلات', purchaseCount: 5),
  ];

  static const List<Map<String, dynamic>> expenseCategories = [
    {'label': 'الصحة والصيدلية', 'icon': Icons.medical_services_outlined},
    {'label': 'المواصلات والوقود', 'icon': Icons.local_gas_station_outlined},
    {'label': 'التموين والبقالة', 'icon': Icons.shopping_cart_outlined},
    {'label': 'أخرى ومصروفات', 'icon': Icons.grid_view_rounded},
    {'label': 'المطاعم والضيافة', 'icon': Icons.restaurant_outlined},
    {'label': 'الفواتير والخدمات', 'icon': Icons.bolt_outlined},
  ];

  static const List<Map<String, String>> payers = [
    {'name': 'ياسمين', 'desc': 'نقداً من الميزانية الفردية'},
    {'name': 'الأم فاطمة', 'desc': 'البطاقة الذهبية / المحفظة'},
    {'name': 'أحمد', 'desc': 'المصروف المخصص (الرياض)'},
    {'name': 'الصندوق المشترك للبيت', 'desc': 'احتياطي الطوارئ والتموين المشترك'},
  ];

  static const List<String> quickSuggestions = ['وقود', 'فاتورة إنترنت', 'دواء وصيدلية', 'مستلزمات البيت'];
}
