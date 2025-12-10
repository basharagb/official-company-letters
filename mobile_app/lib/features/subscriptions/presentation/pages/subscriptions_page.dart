import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';

/// صفحة الاشتراكات
class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('الاشتراكات'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الاشتراك الحالي
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: AppColors.sidebarGradient,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الباقة الحالية',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'نشط',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'الباقة الاحترافية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ينتهي في: 2024/12/31',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildFeatureChip('خطابات غير محدودة'),
                          const SizedBox(width: 8),
                          _buildFeatureChip('دعم فني'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // الباقات المتاحة
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 400),
              child: const Text(
                'الباقات المتاحة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // قائمة الباقات
            ..._buildPlanCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  List<Widget> _buildPlanCards() {
    final plans = [
      {
        'name': 'الباقة المجانية',
        'price': '0',
        'period': 'مجاني',
        'features': ['10 خطابات شهرياً', 'قالب واحد', 'دعم بالبريد'],
        'color': AppColors.info,
      },
      {
        'name': 'الباقة الأساسية',
        'price': '99',
        'period': 'شهرياً',
        'features': ['50 خطاب شهرياً', '5 قوالب', 'دعم فني'],
        'color': AppColors.warning,
      },
      {
        'name': 'الباقة الاحترافية',
        'price': '199',
        'period': 'شهرياً',
        'features': ['خطابات غير محدودة', 'قوالب غير محدودة', 'دعم 24/7'],
        'color': AppColors.success,
        'recommended': true,
      },
    ];

    return plans.asMap().entries.map((entry) {
      final index = entry.key;
      final plan = entry.value;
      final isRecommended = plan['recommended'] == true;

      return FadeInUp(
        delay: Duration(milliseconds: 300 + (index * 100)),
        duration: const Duration(milliseconds: 400),
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isRecommended
                ? const BorderSide(color: AppColors.success, width: 2)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan['name'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    if (isRecommended)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'موصى به',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${plan['price']} ر.س',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: plan['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '/ ${plan['period']}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                ...(plan['features'] as List<String>).map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.tick_circle,
                          size: 18,
                          color: plan['color'] as Color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          feature,
                          style: const TextStyle(fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: isRecommended
                      ? ElevatedButton(
                          onPressed: () {},
                          child: const Text('اشترك الآن'),
                        )
                      : OutlinedButton(
                          onPressed: () {},
                          child: const Text('اختر الباقة'),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
