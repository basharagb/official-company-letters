import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة تسجيل حساب جديد
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyNameEnController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _acceptTerms = false;

  // نوع التسجيل: new_company أو join_company
  String _registrationType = 'new_company';

  // قائمة الشركات المتاحة
  List<Map<String, dynamic>> _companies = [];
  int? _selectedCompanyId;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyNameController.dispose();
    _companyNameEnController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanies() async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/auth/companies');
      if (response.data['success'] == true) {
        setState(() {
          _companies = List<Map<String, dynamic>>.from(response.data['data']);
        });
      }
    } catch (e) {
      // تجاهل الخطأ - قائمة الشركات اختيارية
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على الشروط والأحكام'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();

      final Map<String, dynamic> data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
        'registration_type': _registrationType,
      };

      if (_registrationType == 'new_company') {
        data['company_name'] = _companyNameController.text.trim();
        data['company_name_en'] = _companyNameEnController.text.trim();
      } else {
        data['company_id'] = _selectedCompanyId;
      }

      final response = await apiClient.post('/auth/register', data: data);

      if (response.data['success'] == true) {
        if (mounted) {
          String message = _registrationType == 'new_company'
              ? 'تم إنشاء الحساب بنجاح! يمكنك الآن تسجيل الدخول'
              : 'تم إرسال طلب الانضمام! سيتم إعلامك عند الموافقة';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(AppRoutes.login);
        }
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إنشاء الحساب');
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // زر الرجوع
                Align(
                  alignment: Alignment.centerRight,
                  child: FadeInRight(
                    duration: const Duration(milliseconds: 400),
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // الشعار والعنوان
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 600),
                  child: const Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    'منصة إصدار الخطابات الرسمية',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                // نموذج التسجيل
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // اختيار نوع التسجيل
                          FadeInRight(
                            delay: const Duration(milliseconds: 450),
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'نوع التسجيل',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text(
                                          'شركة جديدة',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Cairo'),
                                        ),
                                        value: 'new_company',
                                        groupValue: _registrationType,
                                        onChanged: (value) {
                                          setState(
                                              () => _registrationType = value!);
                                        },
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text(
                                          'شركة موجودة',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Cairo'),
                                        ),
                                        value: 'join_company',
                                        groupValue: _registrationType,
                                        onChanged: (value) {
                                          setState(
                                              () => _registrationType = value!);
                                        },
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // حقل الاسم
                          FadeInRight(
                            delay: const Duration(milliseconds: 500),
                            duration: const Duration(milliseconds: 500),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'الاسم الكامل',
                                hintText: 'أدخل اسمك الكامل',
                                prefixIcon: const Icon(Iconsax.user),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الاسم';
                                }
                                if (value.length < 3) {
                                  return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // حقل البريد الإلكتروني
                          FadeInRight(
                            delay: const Duration(milliseconds: 600),
                            duration: const Duration(milliseconds: 500),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: 'البريد الإلكتروني',
                                hintText: 'example@email.com',
                                prefixIcon: const Icon(Iconsax.sms),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال البريد الإلكتروني';
                                }
                                if (!value.contains('@')) {
                                  return 'البريد الإلكتروني غير صالح';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // حقل رقم الهاتف
                          FadeInRight(
                            delay: const Duration(milliseconds: 650),
                            duration: const Duration(milliseconds: 500),
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: 'رقم الهاتف (اختياري)',
                                hintText: '+966XXXXXXXXX',
                                prefixIcon: const Icon(Iconsax.call),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // حقول الشركة الجديدة
                          if (_registrationType == 'new_company') ...[
                            FadeInRight(
                              delay: const Duration(milliseconds: 680),
                              duration: const Duration(milliseconds: 500),
                              child: TextFormField(
                                controller: _companyNameController,
                                decoration: InputDecoration(
                                  labelText: 'اسم الشركة (عربي)',
                                  hintText: 'أدخل اسم شركتك',
                                  prefixIcon: const Icon(Iconsax.building),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (_registrationType == 'new_company' &&
                                      (value == null || value.isEmpty)) {
                                    return 'الرجاء إدخال اسم الشركة';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            FadeInRight(
                              delay: const Duration(milliseconds: 690),
                              duration: const Duration(milliseconds: 500),
                              child: TextFormField(
                                controller: _companyNameEnController,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: 'اسم الشركة (إنجليزي - اختياري)',
                                  hintText: 'Company Name',
                                  prefixIcon: const Icon(Iconsax.building_4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // اختيار شركة موجودة
                          if (_registrationType == 'join_company') ...[
                            FadeInRight(
                              delay: const Duration(milliseconds: 680),
                              duration: const Duration(milliseconds: 500),
                              child: DropdownButtonFormField<int>(
                                value: _selectedCompanyId,
                                decoration: InputDecoration(
                                  labelText: 'اختر الشركة',
                                  prefixIcon: const Icon(Iconsax.building),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: _companies.map((company) {
                                  return DropdownMenuItem<int>(
                                    value: company['id'],
                                    child: Text(company['name']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedCompanyId = value);
                                },
                                validator: (value) {
                                  if (_registrationType == 'join_company' &&
                                      value == null) {
                                    return 'الرجاء اختيار الشركة';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            FadeInRight(
                              delay: const Duration(milliseconds: 690),
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Iconsax.info_circle,
                                        color: Colors.orange, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'طلب الانضمام يحتاج موافقة مالك الشركة',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // حقل كلمة المرور
                          FadeInRight(
                            delay: const Duration(milliseconds: 700),
                            duration: const Duration(milliseconds: 500),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'كلمة المرور',
                                prefixIcon: const Icon(Iconsax.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Iconsax.eye_slash
                                        : Iconsax.eye,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور';
                                }
                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // حقل تأكيد كلمة المرور
                          FadeInRight(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 500),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'تأكيد كلمة المرور',
                                prefixIcon: const Icon(Iconsax.lock_1),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Iconsax.eye_slash
                                        : Iconsax.eye,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تأكيد كلمة المرور';
                                }
                                if (value != _passwordController.text) {
                                  return 'كلمة المرور غير متطابقة';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // الموافقة على الشروط
                          FadeInUp(
                            delay: const Duration(milliseconds: 850),
                            duration: const Duration(milliseconds: 500),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() => _acceptTerms = value!);
                                  },
                                  activeColor: AppColors.primary,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(
                                          () => _acceptTerms = !_acceptTerms);
                                    },
                                    child: const Text(
                                      'أوافق على الشروط والأحكام وسياسة الخصوصية',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // زر التسجيل
                          FadeInUp(
                            delay: const Duration(milliseconds: 900),
                            duration: const Duration(milliseconds: 500),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Iconsax.user_add),
                                        SizedBox(width: 8),
                                        Text(
                                          'إنشاء حساب',
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
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // رابط تسجيل الدخول
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب بالفعل؟',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: const Text(
                          'سجل دخولك',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
