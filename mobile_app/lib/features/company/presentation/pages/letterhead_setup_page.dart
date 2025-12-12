import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/services/barcode_service.dart';
import '../bloc/company_bloc.dart';

class LetterheadSetupPage extends StatefulWidget {
  const LetterheadSetupPage({super.key});

  @override
  State<LetterheadSetupPage> createState() => _LetterheadSetupPageState();
}

class _LetterheadSetupPageState extends State<LetterheadSetupPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // بيانات الإعداد
  File? _letterheadFile;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إعداد الورق الرسمي',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
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
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
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
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 4.h,
              decoration: BoxDecoration(
                color:
                    index <= _currentStep ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الخطوة 1: رفع الورق الرسمي',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'قم برفع ملف PDF أو صورة للورق الرسمي للشركة',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 30.h),

            // منطقة رفع الملف
            InkWell(
              onTap: _pickLetterheadFile,
              child: Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _letterheadFile != null
                        ? Colors.green
                        : Colors.grey.shade400,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.grey.shade50,
                ),
                child: _letterheadFile != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 48.sp),
                          SizedBox(height: 10.h),
                          Text(
                            'تم رفع الملف بنجاح',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            _letterheadFile!.path.split('/').last,
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined,
                              size: 48.sp, color: Colors.grey.shade500),
                          SizedBox(height: 10.h),
                          Text(
                            'اضغط هنا لرفع الورق الرسمي',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'PDF أو صورة (PNG, JPG)',
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(height: 20.h),

            if (_letterheadFile != null)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'سيتم استخدام هذا الملف كخلفية للخطابات الرسمية',
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.blue.shade800),
                        ),
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

  Widget _buildStep2() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الخطوة 2: إعدادات الباركود',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'حدد موقع الباركود والمعلومات المطلوب إظهارها',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // موقع الباركود
                    _buildSettingCard(
                      'موقع الباركود',
                      Row(
                        children: [
                          _buildRadioOption('يمين', 'right'),
                          SizedBox(width: 20.w),
                          _buildRadioOption('يسار', 'left'),
                        ],
                      ),
                    ),

                    // المعلومات المعروضة
                    _buildSettingCard(
                      'المعلومات المعروضة',
                      Column(
                        children: [
                          _buildSwitchTile('عرض الباركود', _showBarcode,
                              (value) {
                            setState(() => _showBarcode = value);
                          }),
                          _buildSwitchTile(
                              'عرض الرقم الصادر', _showReferenceNumber,
                              (value) {
                            setState(() => _showReferenceNumber = value);
                          }),
                          _buildSwitchTile('عرض التاريخ الهجري', _showHijriDate,
                              (value) {
                            setState(() => _showHijriDate = value);
                          }),
                          _buildSwitchTile(
                              'عرض التاريخ الميلادي', _showGregorianDate,
                              (value) {
                            setState(() => _showGregorianDate = value);
                          }),
                          _buildSwitchTile('عرض الموضوع', _showSubject,
                              (value) {
                            setState(() => _showSubject = value);
                          }),
                        ],
                      ),
                    ),

                    // الهوامش
                    _buildSettingCard(
                      'الهوامش',
                      Column(
                        children: [
                          _buildSliderTile(
                              'المسافة من الأعلى (مم)', _topMargin, 0, 50,
                              (value) {
                            setState(() => _topMargin = value);
                          }),
                          _buildSliderTile(
                              'المسافة من الجانب (مم)', _sideMargin, 0, 30,
                              (value) {
                            setState(() => _sideMargin = value);
                          }),
                        ],
                      ),
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

  Widget _buildStep3() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الخطوة 3: معاينة النتيجة',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'معاينة شكل الباركود والمعلومات على الخطاب',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 30.h),

            // معاينة الباركود
            Center(
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'معاينة الباركود',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
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
            ),

            SizedBox(height: 30.h),

            // ملخص الإعدادات
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 20.sp),
                      SizedBox(width: 10.w),
                      Text(
                        'ملخص الإعدادات',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'موقع الباركود: ${_barcodePosition == "right" ? "يمين" : "يسار"}\n'
                    'الورق الرسمي: ${_letterheadFile != null ? "تم الرفع" : "لم يتم الرفع"}\n'
                    'المسافة من الأعلى: ${_topMargin.round()} مم\n'
                    'المسافة من الجانب: ${_sideMargin.round()} مم',
                    style: TextStyle(
                        fontSize: 14.sp, color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(String title, Widget content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 15.h),
          content,
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _barcodePosition,
          onChanged: (String? newValue) {
            setState(() {
              _barcodePosition = newValue!;
            });
          },
        ),
        Text(label, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(String title, double value, double min, double max,
      Function(double) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 14.sp)),
              Text('${value.round()}',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  side: const BorderSide(color: Colors.blue),
                ),
                child: Text(
                  'السابق',
                  style: TextStyle(fontSize: 16.sp, color: Colors.blue),
                ),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 15.w),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _currentStep < 2 ? _nextStep : _completeSetup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: BlocBuilder<CompanyBloc, CompanyState>(
                builder: (context, state) {
                  if (state is CompanyLoading) {
                    return SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }
                  return Text(
                    _currentStep < 2 ? 'التالي' : 'إنهاء الإعداد',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0 && _letterheadFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى رفع الورق الرسمي أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickLetterheadFile() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _letterheadFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ في رفع الملف: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _completeSetup() {
    // إرسال البيانات إلى البلوك
    context.read<CompanyBloc>().add(
          CompleteLetterheadSetupEvent(
            letterheadFile: _letterheadFile,
            barcodePosition: _barcodePosition,
            showBarcode: _showBarcode,
            showReferenceNumber: _showReferenceNumber,
            showHijriDate: _showHijriDate,
            showGregorianDate: _showGregorianDate,
            showSubject: _showSubject,
            topMargin: _topMargin,
            sideMargin: _sideMargin,
          ),
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
