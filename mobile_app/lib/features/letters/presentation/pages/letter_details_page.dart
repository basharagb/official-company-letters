import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';

/// صفحة تفاصيل الخطاب مع خيارات المشاركة
class LetterDetailsPage extends StatelessWidget {
  final int letterId;

  const LetterDetailsPage({super.key, required this.letterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Text('خطاب #$letterId'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () {
              // TODO: Edit letter
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Iconsax.document_download, size: 20),
                    SizedBox(width: 12),
                    Text('تحميل PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'email',
                child: Row(
                  children: [
                    Icon(Iconsax.sms, size: 20),
                    SizedBox(width: 12),
                    Text('إرسال بالبريد'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'whatsapp',
                child: Row(
                  children: [
                    Icon(Icons.message, size: 20),
                    SizedBox(width: 12),
                    Text('واتساب'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Iconsax.share, size: 20),
                    SizedBox(width: 12),
                    Text('مشاركة الرابط'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // بطاقة معلومات الخطاب
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'OUT-2024-$letterId',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'صادر',
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      // التواريخ
                      _buildInfoRow(
                        icon: Iconsax.calendar,
                        label: 'التاريخ الميلادي',
                        value: '2024/01/15',
                      ),
                      _buildInfoRow(
                        icon: Iconsax.calendar_1,
                        label: 'التاريخ الهجري',
                        value: '1445/07/04',
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // المستلم
                      _buildInfoRow(
                        icon: Iconsax.user,
                        label: 'المستلم',
                        value: 'محمد أحمد العلي',
                      ),
                      _buildInfoRow(
                        icon: Iconsax.user_tag,
                        label: 'الصفة',
                        value: 'المدير العام',
                      ),
                      _buildInfoRow(
                        icon: Iconsax.building,
                        label: 'الجهة',
                        value: 'شركة التقنية المتقدمة',
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // الموضوع
                      const Text(
                        'الموضوع',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'طلب تعاون في مشروع التحول الرقمي',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // محتوى الخطاب
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.document_text, color: AppColors.primary),
                          const SizedBox(width: 8),
                          const Text(
                            'محتوى الخطاب',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'السلام عليكم ورحمة الله وبركاته،\n\n'
                        'نتقدم إليكم بخالص التحية والتقدير، ونود إعلامكم برغبتنا في التعاون معكم في مشروع التحول الرقمي الذي تعمل عليه شركتكم الموقرة.\n\n'
                        'نأمل منكم التكرم بالموافقة على عقد اجتماع لمناقشة تفاصيل التعاون المقترح.\n\n'
                        'وتفضلوا بقبول فائق الاحترام والتقدير.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.8,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // أزرار الإجراءات
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 400),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleMenuAction(context, 'pdf'),
                      icon: const Icon(Iconsax.document_download),
                      label: const Text('تحميل PDF'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handleMenuAction(context, 'share'),
                      icon: const Icon(Iconsax.share),
                      label: const Text('مشاركة'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'pdf':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('جاري تحميل PDF...')));
        break;
      case 'email':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('جاري فتح البريد الإلكتروني...')),
        );
        break;
      case 'whatsapp':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('جاري فتح واتساب...')));
        break;
      case 'share':
        Share.share(
          'رابط الخطاب: https://letters.app/share/abc123',
          subject: 'مشاركة خطاب',
        );
        break;
    }
  }
}
