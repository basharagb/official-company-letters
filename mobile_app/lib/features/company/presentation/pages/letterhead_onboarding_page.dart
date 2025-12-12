import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/company_remote_datasource.dart';

/// صفحة الإعداد الأولي للورق الرسمي والباركود
/// تظهر عند أول تشغيل للتطبيق لإعداد الورق الرسمي وإعدادات الباركود
class LetterheadOnboardingPage extends StatefulWidget {
  const LetterheadOnboardingPage({super.key});

  @override
  State<LetterheadOnboardingPage> createState() =>
      _LetterheadOnboardingPageState();
}

class _LetterheadOnboardingPageState extends State<LetterheadOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // إعدادات الباركود
  String _barcodePosition = 'right';
  bool _showBarcode = true;
  bool _showReferenceNumber = true;
  bool _showHijriDate = true;
  bool _showGregorianDate = true;
  bool _showSubjectInHeader = true;

  // حالة رفع الورق الرسمي
  bool _letterheadUploaded = false;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _uploadLetterhead() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (image == null) return;

    setState(() => _isLoading = true);
    try {
      final dataSource = GetIt.instance<CompanyRemoteDataSource>();
      await dataSource.uploadLetterhead(image.path);
      setState(() {
        _letterheadUploaded = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم رفع الورق الرسمي بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في رفع الورق الرسمي: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      final dataSource = GetIt.instance<CompanyRemoteDataSource>();

      // حفظ إعدادات الورق الرسمي
      await dataSource.updateLetterheadSettings({
        'barcode_position': _barcodePosition,
        'show_barcode': _showBarcode,
        'show_reference_number': _showReferenceNumber,
        'show_hijri_date': _showHijriDate,
        'show_gregorian_date': _showGregorianDate,
        'show_subject_in_header': _showSubjectInHeader,
      });

      // حفظ أن الإعداد تم
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('letterhead_setup_completed', true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ الإعدادات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        // الانتقال إلى الصفحة الرئيسية
        context.go('/main');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _saveSettings();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('letterhead_setup_completed', true);
    if (mounted) {
      context.go('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إعداد الورق الرسمي'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _skip,
            child: const Text('تخطي'),
          ),
        ],
      ),
      body: Column(
        children: [
          // مؤشر الصفحات
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // محتوى الصفحات
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildWelcomePage(),
                _buildLetterheadUploadPage(),
                _buildBarcodeSettingsPage(),
              ],
            ),
          ),

          // أزرار التنقل
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('السابق'),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_currentPage == 2 ? 'إنهاء الإعداد' : 'التالي'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.document_text,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: const Text(
              'مرحباً بك في نظام الخطابات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 500),
            child: Text(
              'قبل البدء، سنقوم بإعداد الورق الرسمي للشركة وإعدادات الباركود للخطابات',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            duration: const Duration(milliseconds: 500),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      icon: Iconsax.document,
                      title: 'الورق الرسمي',
                      description: 'رفع سكان للورق الرسمي للشركة',
                    ),
                    const Divider(height: 24),
                    _buildFeatureItem(
                      icon: Iconsax.barcode,
                      title: 'الباركود',
                      description: 'باركود للرقم الصادر مع التواريخ',
                    ),
                    const Divider(height: 24),
                    _buildFeatureItem(
                      icon: Iconsax.setting_4,
                      title: 'التخصيص',
                      description: 'تحديد موقع الباركود والمعلومات',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLetterheadUploadPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: const Icon(
              Iconsax.document_upload,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: const Text(
              'رفع الورق الرسمي',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 500),
            child: Text(
              'قم برفع سكان للورق الرسمي للشركة (PDF أو صورة)\nسيتم استخدامه كخلفية للخطابات عند تصدير PDF',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 500),
            child: InkWell(
              onTap: _isLoading ? null : _uploadLetterhead,
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _letterheadUploaded
                      ? Colors.green.withOpacity(0.05)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _letterheadUploaded
                        ? Colors.green
                        : Colors.grey.shade300,
                    width: _letterheadUploaded ? 2 : 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _letterheadUploaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.tick_circle,
                            size: 60,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'تم رفع الورق الرسمي بنجاح',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _uploadLetterhead,
                            icon: const Icon(Iconsax.refresh),
                            label: const Text('تغيير الملف'),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.cloud_add,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'اضغط لرفع الورق الرسمي',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'يفضل رفع سكان بدقة عالية (A4)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 500),
            child: Text(
              '* يمكنك تخطي هذه الخطوة والإعداد لاحقاً من الإعدادات',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeSettingsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: const Icon(
              Iconsax.barcode,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: const Text(
              'إعدادات الباركود',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 500),
            child: Text(
              'الترتيب: باركود ← الرقم الصادر ← التاريخ الهجري ← التاريخ الميلادي ← الموضوع',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 500),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'موقع الباركود على الورقة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPositionOption(
                            title: 'يمين',
                            icon: Iconsax.align_right,
                            isSelected: _barcodePosition == 'right',
                            onTap: () =>
                                setState(() => _barcodePosition = 'right'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPositionOption(
                            title: 'يسار',
                            icon: Iconsax.align_left,
                            isSelected: _barcodePosition == 'left',
                            onTap: () =>
                                setState(() => _barcodePosition = 'left'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 500),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title: 'عرض الباركود',
                      subtitle: 'باركود للرقم الصادر',
                      value: _showBarcode,
                      onChanged: (v) => setState(() => _showBarcode = v),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      title: 'عرض الرقم الصادر',
                      subtitle: 'تحت الباركود مباشرة',
                      value: _showReferenceNumber,
                      onChanged: (v) =>
                          setState(() => _showReferenceNumber = v),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      title: 'عرض التاريخ الهجري',
                      subtitle: 'مثال: 12 جمادى الآخرة 1446هـ',
                      value: _showHijriDate,
                      onChanged: (v) => setState(() => _showHijriDate = v),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      title: 'عرض التاريخ الميلادي',
                      subtitle: 'مثال: 2024/12/12',
                      value: _showGregorianDate,
                      onChanged: (v) => setState(() => _showGregorianDate = v),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      title: 'عرض الموضوع',
                      subtitle: 'موضوع الخطاب مختصر',
                      value: _showSubjectInHeader,
                      onChanged: (v) =>
                          setState(() => _showSubjectInHeader = v),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey.shade600,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.grey.shade700,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Cairo',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontFamily: 'Cairo',
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }
}
