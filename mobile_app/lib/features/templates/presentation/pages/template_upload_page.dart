import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/barcode_service.dart';

/// صفحة رفع قالب الورق الرسمي مع إعدادات الباركود
class TemplateUploadPage extends StatefulWidget {
  const TemplateUploadPage({super.key});

  @override
  State<TemplateUploadPage> createState() => _TemplateUploadPageState();
}

class _TemplateUploadPageState extends State<TemplateUploadPage> {
  final PageController _pageController = PageController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _currentStep = 0;
  File? _templateFile;
  bool _isLoading = false;

  // إعدادات الباركود
  String _barcodePosition = 'right'; // right أو left
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
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('إضافة قالب ورق رسمي'),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط التقدم
          _buildProgressIndicator(),

          // محتوى الصفحات
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentStep = index);
              },
              children: [
                _buildStep1UploadTemplate(),
                _buildStep2BarcodeSettings(),
                _buildStep3Preview(),
              ],
            ),
          ),

          // أزرار التنقل
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: AppColors.primary,
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel(0, 'رفع القالب'),
              _buildStepLabel(1, 'إعدادات الباركود'),
              _buildStepLabel(2, 'معاينة وحفظ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabel(int step, String label) {
    final isActive = _currentStep >= step;
    return Text(
      label,
      style: TextStyle(
        fontSize: 11.sp,
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        fontFamily: 'Cairo',
      ),
    );
  }

  // الخطوة 1: رفع القالب
  Widget _buildStep1UploadTemplate() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رفع الورق الرسمي',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'قم بمسح أو رفع ملف الورق الرسمي للشركة (PDF أو صورة)',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 24.h),

            // اسم القالب
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'اسم القالب *',
                hintText: 'مثال: الورق الرسمي للشركة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: const Icon(Iconsax.document_text),
              ),
            ),
            SizedBox(height: 16.h),

            // وصف القالب
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'وصف القالب (اختياري)',
                hintText: 'وصف مختصر للقالب',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: const Icon(Iconsax.note_text),
              ),
            ),
            SizedBox(height: 24.h),

            // خيارات الرفع
            Text(
              'اختر طريقة الرفع:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 16.h),

            // أزرار الرفع
            Row(
              children: [
                Expanded(
                  child: _buildUploadOption(
                    icon: Iconsax.scan,
                    title: 'مسح ضوئي',
                    subtitle: 'التقاط صورة',
                    onTap: _scanDocument,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildUploadOption(
                    icon: Iconsax.gallery,
                    title: 'من المعرض',
                    subtitle: 'اختيار صورة',
                    onTap: _pickFromGallery,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildUploadOption(
                    icon: Iconsax.document_upload,
                    title: 'ملف PDF',
                    subtitle: 'اختيار ملف',
                    onTap: _pickPdfFile,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(child: Container()), // للتوازن
              ],
            ),
            SizedBox(height: 24.h),

            // عرض الملف المرفوع
            if (_templateFile != null)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Iconsax.tick_circle,
                          color: Colors.green.shade700,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تم رفع الملف بنجاح',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _templateFile!.path.split('/').last,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.green.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Iconsax.trash, color: Colors.red.shade400),
                        onPressed: () {
                          setState(() => _templateFile = null);
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 4.h),
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
    );
  }

  // الخطوة 2: إعدادات الباركود
  Widget _buildStep2BarcodeSettings() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات الباركود والبيانات',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'حدد موقع الباركود والمعلومات المطلوب إظهارها على الخطاب',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 24.h),

            // موقع الباركود
            _buildSettingCard(
              title: 'موقع الباركود والبيانات',
              icon: Iconsax.location,
              child: Row(
                children: [
                  Expanded(
                    child: _buildPositionOption(
                      label: 'يمين الورقة',
                      value: 'right',
                      icon: Iconsax.arrow_right_3,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildPositionOption(
                      label: 'يسار الورقة',
                      value: 'left',
                      icon: Iconsax.arrow_left_2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // المعلومات المعروضة
            _buildSettingCard(
              title: 'المعلومات المعروضة',
              icon: Iconsax.document_text,
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'عرض الباركود',
                    subtitle: 'باركود يحتوي على الرقم الصادر',
                    value: _showBarcode,
                    onChanged: (v) => setState(() => _showBarcode = v),
                  ),
                  _buildSwitchTile(
                    title: 'عرض الرقم الصادر',
                    subtitle: 'رقم الخطاب الصادر',
                    value: _showReferenceNumber,
                    onChanged: (v) => setState(() => _showReferenceNumber = v),
                  ),
                  _buildSwitchTile(
                    title: 'عرض التاريخ الهجري',
                    subtitle: 'التاريخ بالتقويم الهجري',
                    value: _showHijriDate,
                    onChanged: (v) => setState(() => _showHijriDate = v),
                  ),
                  _buildSwitchTile(
                    title: 'عرض التاريخ الميلادي',
                    subtitle: 'التاريخ بالتقويم الميلادي',
                    value: _showGregorianDate,
                    onChanged: (v) => setState(() => _showGregorianDate = v),
                  ),
                  _buildSwitchTile(
                    title: 'عرض الموضوع',
                    subtitle: 'موضوع الخطاب',
                    value: _showSubject,
                    onChanged: (v) => setState(() => _showSubject = v),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // الهوامش
            _buildSettingCard(
              title: 'الهوامش',
              icon: Iconsax.ruler,
              child: Column(
                children: [
                  _buildSliderTile(
                    title: 'المسافة من الأعلى',
                    value: _topMargin,
                    min: 0,
                    max: 50,
                    unit: 'مم',
                    onChanged: (v) => setState(() => _topMargin = v),
                  ),
                  SizedBox(height: 16.h),
                  _buildSliderTile(
                    title: 'المسافة من الجانب',
                    value: _sideMargin,
                    min: 0,
                    max: 30,
                    unit: 'مم',
                    onChanged: (v) => setState(() => _sideMargin = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildPositionOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _barcodePosition == value;
    return InkWell(
      onTap: () => setState(() => _barcodePosition = value),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10.r),
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
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
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

  Widget _buildSliderTile({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Cairo',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${value.round()} $unit',
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
    );
  }

  // الخطوة 3: المعاينة
  Widget _buildStep3Preview() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معاينة وحفظ',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
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
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
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
                  Text(
                    'معاينة الباركود والبيانات',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 20.h),
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

            // ملخص الإعدادات
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.info_circle,
                          color: AppColors.primary, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'ملخص الإعدادات',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildSummaryItem(
                      'اسم القالب',
                      _nameController.text.isEmpty
                          ? 'غير محدد'
                          : _nameController.text),
                  _buildSummaryItem('الملف',
                      _templateFile != null ? 'تم الرفع ✓' : 'لم يتم الرفع'),
                  _buildSummaryItem('موقع الباركود',
                      _barcodePosition == 'right' ? 'يمين' : 'يسار'),
                  _buildSummaryItem(
                      'المسافة من الأعلى', '${_topMargin.round()} مم'),
                  _buildSummaryItem(
                      'المسافة من الجانب', '${_sideMargin.round()} مم'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade700,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
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
              onPressed: _isLoading
                  ? null
                  : (_currentStep < 2 ? _nextStep : _saveTemplate),
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
                      _currentStep < 2 ? 'التالي' : 'حفظ القالب',
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

  void _nextStep() {
    // التحقق من الخطوة الأولى
    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        _showError('يرجى إدخال اسم القالب');
        return;
      }
      if (_templateFile == null) {
        _showError('يرجى رفع ملف الورق الرسمي');
        return;
      }
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
      // Android 13+
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

  // المسح الضوئي
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
          _templateFile = File(photo.path);
        });
      }
    } catch (e) {
      _showError('حدث خطأ في المسح الضوئي: $e');
    }
  }

  // اختيار من المعرض
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
          _templateFile = File(image.path);
        });
      }
    } catch (e) {
      _showError('حدث خطأ في اختيار الصورة: $e');
    }
  }

  // اختيار ملف PDF
  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _templateFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      _showError('حدث خطأ في اختيار الملف: $e');
    }
  }

  // حفظ القالب
  Future<void> _saveTemplate() async {
    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();

      // إنشاء FormData للرفع
      final formData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'barcode_position': _barcodePosition,
        'show_barcode': _showBarcode,
        'show_reference_number': _showReferenceNumber,
        'show_hijri_date': _showHijriDate,
        'show_gregorian_date': _showGregorianDate,
        'show_subject': _showSubject,
        'top_margin': _topMargin,
        'side_margin': _sideMargin,
        'is_letterhead': true,
        'is_active': true,
      };

      // TODO: إضافة رفع الملف عبر multipart/form-data

      final response = await apiClient.post('/templates', data: formData);

      if (response.data['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم حفظ القالب بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop(true); // العودة مع نتيجة النجاح
        }
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حفظ القالب');
      }
    } catch (e) {
      _showError('خطأ في حفظ القالب: $e');
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
