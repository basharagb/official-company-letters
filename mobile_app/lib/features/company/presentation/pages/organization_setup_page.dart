import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة إعداد بيانات المؤسسة عند أول تسجيل دخول
class OrganizationSetupPage extends StatefulWidget {
  const OrganizationSetupPage({super.key});

  @override
  State<OrganizationSetupPage> createState() => _OrganizationSetupPageState();
}

class _OrganizationSetupPageState extends State<OrganizationSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  String _selectedType = 'company';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _organizationTypes = [
    {'value': 'company', 'label': 'شركة', 'icon': Iconsax.building_4},
    {'value': 'government', 'label': 'جهة حكومية', 'icon': Iconsax.courthouse},
    {'value': 'education', 'label': 'مؤسسة تعليمية', 'icon': Iconsax.teacher},
    {'value': 'healthcare', 'label': 'مؤسسة صحية', 'icon': Iconsax.hospital},
    {'value': 'ngo', 'label': 'منظمة غير ربحية', 'icon': Iconsax.people},
    {'value': 'other', 'label': 'أخرى', 'icon': Iconsax.category},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _saveOrganization() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.put('/company', data: {
        'name': _nameController.text.trim(),
        'type': _selectedType,
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'website': _websiteController.text.trim(),
        'setup_completed': true,
      });

      if (response.data['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ بيانات المؤسسة بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(AppRoutes.main);
        }
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حفظ البيانات');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تخطي الإعداد'),
        content: const Text(
          'يمكنك إكمال إعداد بيانات المؤسسة لاحقاً من الإعدادات.\nهل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.main);
            },
            child: const Text('تخطي'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إعداد المؤسسة'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _skipSetup,
            child: const Text('تخطي'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان الرئيسي
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Iconsax.building,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً بك!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              'أكمل بيانات مؤسستك للبدء',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // نوع المؤسسة
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نوع المؤسسة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 1,
                      ),
                      itemCount: _organizationTypes.length,
                      itemBuilder: (context, index) {
                        final type = _organizationTypes[index];
                        final isSelected = _selectedType == type['value'];
                        return InkWell(
                          onTap: () {
                            setState(() => _selectedType = type['value']);
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  type['icon'],
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey,
                                  size: 28.sp,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  type['label'],
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade700,
                                    fontFamily: 'Cairo',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // اسم المؤسسة
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المؤسسة *',
                    hintText: 'أدخل اسم المؤسسة',
                    prefixIcon: const Icon(Iconsax.building),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المؤسسة';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 16.h),

              // العنوان
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 500),
                child: TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    hintText: 'أدخل عنوان المؤسسة',
                    prefixIcon: const Icon(Iconsax.location),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // رقم الهاتف
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 500),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    hintText: '+966 XX XXX XXXX',
                    prefixIcon: const Icon(Iconsax.call),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // البريد الإلكتروني
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 500),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    hintText: 'info@organization.com',
                    prefixIcon: const Icon(Iconsax.sms),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // الموقع الإلكتروني
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 500),
                child: TextFormField(
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: 'الموقع الإلكتروني (اختياري)',
                    hintText: 'www.organization.com',
                    prefixIcon: const Icon(Iconsax.global),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // زر الحفظ
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveOrganization,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.tick_circle),
                              SizedBox(width: 8.w),
                              Text(
                                'حفظ والمتابعة',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // ملاحظة
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle,
                          color: AppColors.info, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'يمكنك تعديل هذه البيانات لاحقاً من إعدادات المؤسسة',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.info,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
