import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/barcode_service.dart';
import '../../../../core/router/app_router.dart';

/// صفحة الإعداد الأولي للقالب - تظهر عند أول استخدام للتطبيق
class TemplateInitialSetupPage extends StatefulWidget {
  const TemplateInitialSetupPage({super.key});

  @override
  State<TemplateInitialSetupPage> createState() =>
      _TemplateInitialSetupPageState();
}

class _TemplateInitialSetupPageState extends State<TemplateInitialSetupPage> {
  final PageController _pageController = PageController();

  int _currentStep = 0;
  File? _letterheadFile;
  bool _isLoading = false;

  // إعدادات الباركود
  String _barcodePosition = 'right';
  bool _showBarcode = true;
  bool _showReferenceNumber = true;
  bool _showHijriDate = true;
  bool _showGregorianDate = true;
  bool _showSubject = true;
  double _topMargin = 20.0;
  double _sideMargin = 15.0;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // شريط التقدم
            _buildProgressHeader(),

            // محتوى الصفحات
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  _buildWelcomePage(),
                  _buildUploadPage(),
                  _buildSettingsPage(),
                  _buildPreviewPage(),
                ],
              ),
            ),

            // أزرار التنقل
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // شريط التقدم
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 8.h),
          // رقم الخطوة
          Text(
            'الخطوة ${_currentStep + 1} من 4',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // صفحة الترحيب
  Widget _buildWelcomePage() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.document_text,
                size: 64.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 32.h),

            // العنوان
            Text(
              'مرحباً بك في نظام الخطابات',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),

            // الوصف
            Text(
              'لنبدأ بإعداد الورق الرسمي للشركة.\n'
              'سيتم استخدامه كخلفية لجميع الخطابات الصادرة.',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            // الميزات
            _buildFeatureItem(
              icon: Iconsax.scan,
              title: 'مسح ضوئي للورق الرسمي',
              subtitle: 'قم بمسح الورق الرسمي للشركة',
            ),
            SizedBox(height: 12.h),
            _buildFeatureItem(
              icon: Iconsax.barcode,
              title: 'باركود تلقائي',
              subtitle: 'يحتوي على الرقم الصادر والتاريخ',
            ),
            SizedBox(height: 12.h),
            _buildFeatureItem(
              icon: Iconsax.calendar,
              title: 'تاريخ هجري وميلادي',
              subtitle: 'يظهر تلقائياً على كل خطاب',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // صفحة رفع الورق الرسمي
  Widget _buildUploadPage() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رفع الورق الرسمي',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'قم بمسح أو رفع صورة الورق الرسمي للشركة',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 32.h),

            // منطقة الرفع
            InkWell(
              onTap: _showUploadOptions,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  color: _letterheadFile != null
                      ? Colors.green.shade50
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: _letterheadFile != null
                        ? Colors.green.shade300
                        : Colors.grey.shade300,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _letterheadFile != null
                    ? _buildUploadedFilePreview()
                    : _buildUploadPlaceholder(),
              ),
            ),
            SizedBox(height: 24.h),

            // أزرار الرفع
            Row(
              children: [
                Expanded(
                  child: _buildUploadButton(
                    icon: Iconsax.scan,
                    label: 'مسح ضوئي',
                    onTap: _scanDocument,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildUploadButton(
                    icon: Iconsax.gallery,
                    label: 'من المعرض',
                    onTap: _pickFromGallery,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // ملاحظة
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle,
                      color: Colors.blue.shade700, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'يمكنك تخطي هذه الخطوة وإضافة الورق الرسمي لاحقاً من الإعدادات',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue.shade800,
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
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Iconsax.document_upload,
          size: 48.sp,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 16.h),
        Text(
          'اضغط هنا لرفع الورق الرسمي',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'صورة PNG, JPG أو PDF',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadedFilePreview() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.tick_circle,
                size: 48.sp,
                color: Colors.green.shade600,
              ),
              SizedBox(height: 16.h),
              Text(
                'تم رفع الملف بنجاح',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  _letterheadFile!.path.split('/').last,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.green.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: IconButton(
            icon: Icon(Iconsax.trash, color: Colors.red.shade400, size: 20.sp),
            onPressed: () => setState(() => _letterheadFile = null),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // صفحة الإعدادات
  Widget _buildSettingsPage() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات الباركود',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'حدد موقع الباركود والمعلومات المعروضة',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 24.h),

            // موقع الباركود
            Text(
              'موقع الباركود على الورقة',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildPositionCard(
                    label: 'يمين الورقة',
                    value: 'right',
                    icon: Iconsax.arrow_right_3,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildPositionCard(
                    label: 'يسار الورقة',
                    value: 'left',
                    icon: Iconsax.arrow_left_2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // المعلومات المعروضة
            Text(
              'المعلومات المعروضة',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 12.h),
            _buildSettingSwitch(
              title: 'الباركود',
              subtitle: 'باركود يحتوي على الرقم الصادر',
              value: _showBarcode,
              onChanged: (v) => setState(() => _showBarcode = v),
            ),
            _buildSettingSwitch(
              title: 'الرقم الصادر',
              subtitle: 'رقم الخطاب تحت الباركود',
              value: _showReferenceNumber,
              onChanged: (v) => setState(() => _showReferenceNumber = v),
            ),
            _buildSettingSwitch(
              title: 'التاريخ الهجري',
              subtitle: 'التاريخ بالتقويم الهجري',
              value: _showHijriDate,
              onChanged: (v) => setState(() => _showHijriDate = v),
            ),
            _buildSettingSwitch(
              title: 'التاريخ الميلادي',
              subtitle: 'التاريخ بالتقويم الميلادي',
              value: _showGregorianDate,
              onChanged: (v) => setState(() => _showGregorianDate = v),
            ),
            _buildSettingSwitch(
              title: 'الموضوع',
              subtitle: 'موضوع الخطاب',
              value: _showSubject,
              onChanged: (v) => setState(() => _showSubject = v),
            ),
            SizedBox(height: 24.h),

            // الهوامش
            Text(
              'الهوامش',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 12.h),
            _buildSlider(
              label: 'المسافة من الأعلى',
              value: _topMargin,
              min: 0,
              max: 50,
              onChanged: (v) => setState(() => _topMargin = v),
            ),
            _buildSlider(
              label: 'المسافة من الجانب',
              value: _sideMargin,
              min: 0,
              max: 30,
              onChanged: (v) => setState(() => _sideMargin = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _barcodePosition == value;
    return InkWell(
      onTap: () => setState(() => _barcodePosition = value),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 28.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
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

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '${value.round()} مم',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // صفحة المعاينة
  Widget _buildPreviewPage() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معاينة النتيجة',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'راجع الإعدادات قبل الحفظ',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 24.h),

            // معاينة الباركود
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.eye, color: AppColors.primary, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'معاينة الباركود والبيانات',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  BarcodeService.buildBarcodeWidget(
                    referenceNumber: 'OUT-2025-00001',
                    date: DateTime.now(),
                    subject: 'خطاب تجريبي للمعاينة',
                    position: _barcodePosition,
                    showBarcode: _showBarcode,
                    showReferenceNumber: _showReferenceNumber,
                    showHijriDate: _showHijriDate,
                    showGregorianDate: _showGregorianDate,
                    showSubject: _showSubject,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // ملخص
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.tick_circle,
                          color: Colors.green.shade700, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'جاهز للحفظ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildSummaryRow('الورق الرسمي',
                      _letterheadFile != null ? 'تم الرفع ✓' : 'لم يتم الرفع'),
                  _buildSummaryRow('موقع الباركود',
                      _barcodePosition == 'right' ? 'يمين' : 'يسار'),
                  _buildSummaryRow(
                      'المسافة من الأعلى', '${_topMargin.round()} مم'),
                  _buildSummaryRow(
                      'المسافة من الجانب', '${_sideMargin.round()} مم'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.green.shade700,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade800,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // أزرار التنقل
  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'السابق',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleNextOrComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep < 3
                          ? (_currentStep == 1 && _letterheadFile == null
                              ? 'تخطي'
                              : 'التالي')
                          : 'إنهاء الإعداد',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleNextOrComplete() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'اختر طريقة الرفع',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.scan, color: AppColors.primary),
              ),
              title: const Text('مسح ضوئي'),
              subtitle: const Text('التقاط صورة بالكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _scanDocument();
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.gallery, color: AppColors.primary),
              ),
              title: const Text('من المعرض'),
              subtitle: const Text('اختيار صورة موجودة'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // طلب صلاحيات الكاميرا
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    final result = await Permission.camera.request();
    if (result.isPermanentlyDenied) {
      _showPermissionDeniedDialog('الكاميرا');
      return false;
    }
    return result.isGranted;
  }

  // طلب صلاحيات المعرض
  Future<bool> _requestPhotosPermission() async {
    PermissionStatus status;
    if (Platform.isIOS) {
      status = await Permission.photos.status;
      if (status.isGranted || status.isLimited) return true;
      final result = await Permission.photos.request();
      if (result.isPermanentlyDenied) {
        _showPermissionDeniedDialog('الصور');
        return false;
      }
      return result.isGranted || result.isLimited;
    } else {
      if (await Permission.photos.status.isGranted) return true;
      status = await Permission.storage.status;
      if (status.isGranted) return true;

      final result = await Permission.photos.request();
      if (result.isGranted) return true;

      final storageResult = await Permission.storage.request();
      if (storageResult.isPermanentlyDenied) {
        _showPermissionDeniedDialog('التخزين');
        return false;
      }
      return storageResult.isGranted;
    }
  }

  // عرض رسالة رفض الصلاحيات
  void _showPermissionDeniedDialog(String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'صلاحية $permission مطلوبة',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        content: Text(
          'يرجى السماح بالوصول إلى $permission من إعدادات التطبيق',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  Future<void> _scanDocument() async {
    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) return;

      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (photo != null) {
        setState(() {
          _letterheadFile = File(photo.path);
        });
      }
    } catch (e) {
      _showError('حدث خطأ في المسح الضوئي: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final hasPermission = await _requestPhotosPermission();
      if (!hasPermission) return;

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _letterheadFile = File(image.path);
        });
      }
    } catch (e) {
      _showError('حدث خطأ في اختيار الصورة: $e');
    }
  }

  Future<void> _completeSetup() async {
    setState(() => _isLoading = true);

    try {
      // حفظ الإعدادات محلياً
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('initial_setup_completed', true);
      await prefs.setString('barcode_position', _barcodePosition);
      await prefs.setBool('show_barcode', _showBarcode);
      await prefs.setBool('show_reference_number', _showReferenceNumber);
      await prefs.setBool('show_hijri_date', _showHijriDate);
      await prefs.setBool('show_gregorian_date', _showGregorianDate);
      await prefs.setBool('show_subject', _showSubject);
      await prefs.setDouble('top_margin', _topMargin);
      await prefs.setDouble('side_margin', _sideMargin);

      // إرسال الإعدادات للسيرفر
      try {
        final apiClient = di.sl<ApiClient>();
        await apiClient.put('/company/letterhead', data: {
          'barcode_position': _barcodePosition,
          'show_barcode': _showBarcode,
          'show_reference_number': _showReferenceNumber,
          'show_hijri_date': _showHijriDate,
          'show_gregorian_date': _showGregorianDate,
          'show_subject': _showSubject,
          'top_margin': _topMargin,
          'side_margin': _sideMargin,
        });
      } catch (e) {
        // تجاهل أخطاء السيرفر - الإعدادات محفوظة محلياً
        debugPrint('Server error (ignored): $e');
      }

      if (mounted) {
        context.go(AppRoutes.main);
      }
    } catch (e) {
      _showError('حدث خطأ في حفظ الإعدادات: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
