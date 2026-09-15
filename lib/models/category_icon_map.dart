import 'package:flutter/material.dart';

/// Maps the short text key stored in categories.icon (e.g. 'groceries')
/// to an actual Flutter icon. Keep this in sync with whatever keys you
/// insert into the categories table.
IconData iconForCategoryKey(String? key) {
  switch (key) {
    case 'groceries':
      return Icons.shopping_cart_outlined;
    case 'health':
      return Icons.medical_services_outlined;
    case 'transport':
      return Icons.local_gas_station_outlined;
    case 'bills':
      return Icons.bolt_outlined;
    case 'food':
      return Icons.restaurant_outlined;
    default:
      return Icons.grid_view_rounded;
  }
}

/// Parses a '#RRGGBB' hex string (as stored in categories.color) into a Color.
Color colorFromHex(String? hex, {Color fallback = const Color(0xFF6B7280)}) {
  if (hex == null || hex.isEmpty) return fallback;
  final cleaned = hex.replaceAll('#', '');
  final value = int.tryParse('FF$cleaned', radix: 16);
  return value != null ? Color(value) : fallback;
}
