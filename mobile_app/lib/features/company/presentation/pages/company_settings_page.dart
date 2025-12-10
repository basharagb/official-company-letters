import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';

/// صفحة إعدادات الشركة
class CompanySettingsPage extends StatelessWidget {
  const CompanySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('إعدادات الشركة'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // شعار الشركة
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.image,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Upload logo
                        },
                        icon: const Icon(Iconsax.gallery_add),
                        label: const Text('تغيير الشعار'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // بيانات الشركة
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
                          Icon(Iconsax.building, color: AppColors.primary),
                          const SizedBox(width: 8),
                          const Text(
                            'بيانات الشركة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'اسم الشركة',
                        hint: 'أدخل اسم الشركة',
                        icon: Iconsax.building_4,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'العنوان',
                        hint: 'أدخل عنوان الشركة',
                        icon: Iconsax.location,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'رقم الهاتف',
                        hint: 'أدخل رقم الهاتف',
                        icon: Iconsax.call,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'أدخل البريد الإلكتروني',
                        icon: Iconsax.sms,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // التوقيع والختم
            FadeInUp(
              delay: const Duration(milliseconds: 400),
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
                          Icon(Iconsax.edit_2, color: AppColors.primary),
                          const SizedBox(width: 8),
                          const Text(
                            'التوقيع والختم',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildUploadBox(
                              title: 'التوقيع',
                              icon: Iconsax.edit,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildUploadBox(
                              title: 'الختم',
                              icon: Iconsax.verify,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // زر الحفظ
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              duration: const Duration(milliseconds: 400),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Save settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم حفظ الإعدادات'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('حفظ الإعدادات'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildUploadBox({required String title, required IconData icon}) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اضغط للرفع',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
