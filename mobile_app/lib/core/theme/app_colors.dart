import 'package:flutter/material.dart';

/// ألوان التطبيق - مطابقة لتصميم الويب
class AppColors {
  AppColors._();

  // Primary Colors - من تصميم الويب
  static const Color primary = Color(0xFF1E3A5F); // الأزرق الداكن الرئيسي
  static const Color primaryLight = Color(0xFF4DABF7); // الأزرق الفاتح
  static const Color primaryDark = Color(0xFF0D2137); // الأزرق الأغمق

  // Secondary Colors
  static const Color secondary = Color(0xFF4DABF7);

  // Background Colors
  static const Color background = Color(0xFFF4F6F9);
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1E3A5F);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF9CA3AF);

  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // Letter Status Colors
  static const Color draft = Color(0xFFFFC107); // مسودة - أصفر
  static const Color issued = Color(0xFF17A2B8); // صادر - أزرق فاتح
  static const Color sent = Color(0xFF28A745); // مُرسل - أخضر

  // Other Colors
  static const Color dark = Color(0xFF343A40);
  static const Color light = Color(0xFFF8F9FA);
  static const Color border = Color(0xFFE9ECEF);

  // Gradient - مثل الـ Sidebar في الويب
  static const LinearGradient sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1E3A5F), Color(0xFF0D2137)],
  );

  // Card Shadow
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
}
