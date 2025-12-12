import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/company_remote_datasource.dart';

/// صفحة الإعداد الأولي للشركة
class CompanySetupPage extends StatefulWidget {
  const CompanySetupPage({super.key});

  @override
  State<CompanySetupPage> createState() => _CompanySetupPageState();
}

class _CompanySetupPageState extends State<CompanySetupPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers للخطوة 1
  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _letterPrefixController = TextEditingController(text: 'OUT');

  // ملفات الخطوة 1
  File? _logoFile;
  File? _signatureFile;
  File? _stampFile;

  // ملف الورق الرسمي (الخطوة 2)
  File? _letterheadFile;

  // إعدادات الباركود (الخطوة 3)
  String _barcodePosition = 'right';
  bool _showBarcode = true;
  bool _showReferenceNumber = true;
  bool _showHijriDate = true;
  bool _showGregorianDate = true;
  bool _showSubjectInHeader = true;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _letterPrefixController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        switch (type) {
          case 'logo':
            _logoFile = File(image.path);
            break;
          case 'signature':
            _signatureFile = File(image.path);
            break;
          case 'stamp':
            _stampFile = File(image.path);
            break;
          case 'letterhead':
            _letterheadFile = File(image.path);
            break;
        }
      });
    }
  }

  Future<void> _completeSetup() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم الشركة')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dataSource = GetIt.instance<CompanyRemoteDataSource>();

      // رفع الملفات إذا وجدت
      if (_logoFile != null) {
        await dataSource.uploadLogo(_logoFile!.path);
      }
      if (_signatureFile != null) {
        await dataSource.uploadSignature(_signatureFile!.path);
      }
      if (_stampFile != null) {
        await dataSource.uploadStamp(_stampFile!.path);
      }
      if (_letterheadFile != null) {
        await dataSource.uploadLetterhead(_letterheadFile!.path);
      }

      // إكمال الإعداد
      await dataSource.completeSetup({
        'name': _nameController.text,
        'name_en': _nameEnController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'letter_prefix': _letterPrefixController.text,
        'barcode_position': _barcodePosition,
        'show_barcode': _showBarcode,
        'show_reference_number': _showReferenceNumber,
        'show_hijri_date': _showHijriDate,
        'show_gregorian_date': _showGregorianDate,
        'show_subject_in_header': _showSubjectInHeader,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إعداد الشركة بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعداد الشركة'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // شريط التقدم
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStepIndicator(0, 'البيانات الأساسية'),
                      _buildStepIndicator(1, 'الورق الرسمي'),
                      _buildStepIndicator(2, 'إعدادات الباركود'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / 3,
                    backgroundColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),

          // المحتوى
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStep(),
            ),
          ),

          // أزرار التنقل
          FadeInUp(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _currentStep--),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('السابق'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_currentStep < 2) {
                                setState(() => _currentStep++);
                              } else {
                                _completeSetup();
                              }
                            },
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(_currentStep < 2
                              ? Icons.arrow_back
                              : Icons.check_circle),
                      label:
                          Text(_currentStep < 2 ? 'التالي' : 'إنهاء الإعداد'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String title) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor:
              isActive ? Theme.of(context).primaryColor : Colors.grey[300],
          child: Text(
            '${step + 1}',
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return FadeInRight(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'مرحباً! لنبدأ بإعداد شركتك',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الشركة (عربي) *',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameEnController,
                      decoration: const InputDecoration(
                        labelText: 'اسم الشركة (إنجليزي)',
                        prefixIcon: Icon(Icons.business_center),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'العنوان',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'رقم الهاتف',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _letterPrefixController,
                      decoration: const InputDecoration(
                        labelText: 'بادئة رقم الصادر',
                        prefixIcon: Icon(Icons.tag),
                        hintText: 'مثال: OUT, صادر',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الشعار والتوقيع والختم',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildImagePicker(
                            'الشعار',
                            _logoFile,
                            () => _pickImage('logo'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildImagePicker(
                            'التوقيع',
                            _signatureFile,
                            () => _pickImage('signature'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildImagePicker(
                            'الختم',
                            _stampFile,
                            () => _pickImage('stamp'),
                          ),
                        ),
                      ],
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
    return FadeInRight(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.description,
                    size: 60,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'رفع الورق الرسمي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'قم بعمل سكان للورق الرسمي الخاص بشركتك وارفعه هنا. سيتم استخدامه كخلفية لجميع الخطابات.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  if (_letterheadFile != null)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _letterheadFile!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('لم يتم رفع ملف بعد'),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage('letterhead'),
                        icon: const Icon(Icons.upload_file),
                        label: const Text('اختيار ملف'),
                      ),
                      if (_letterheadFile != null) ...[
                        const SizedBox(width: 12),
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _letterheadFile = null),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('حذف',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'PDF أو صورة (PNG, JPG) - حد أقصى 5MB',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _currentStep++),
            child: const Text('تخطي هذه الخطوة'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return FadeInRight(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات الباركود والمعلومات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يظهر الباركود والرقم الصادر والتاريخ والموضوع على الورقة',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'موقع الباركود والمعلومات',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Row(
                            children: [
                              Icon(Icons.align_horizontal_right, size: 20),
                              SizedBox(width: 8),
                              Text('يمين الورقة'),
                            ],
                          ),
                          value: 'right',
                          groupValue: _barcodePosition,
                          onChanged: (v) =>
                              setState(() => _barcodePosition = v!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Row(
                            children: [
                              Icon(Icons.align_horizontal_left, size: 20),
                              SizedBox(width: 8),
                              Text('يسار الورقة'),
                            ],
                          ),
                          value: 'left',
                          groupValue: _barcodePosition,
                          onChanged: (v) =>
                              setState(() => _barcodePosition = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'العناصر المعروضة (بالترتيب من الأعلى للأسفل)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('الباركود'),
                    subtitle: const Text('يحتوي على الرقم الصادر'),
                    value: _showBarcode,
                    onChanged: (v) => setState(() => _showBarcode = v),
                  ),
                  SwitchListTile(
                    title: const Text('الرقم الصادر'),
                    subtitle: const Text('مثال: OUT-2024-00001'),
                    value: _showReferenceNumber,
                    onChanged: (v) => setState(() => _showReferenceNumber = v),
                  ),
                  SwitchListTile(
                    title: const Text('التاريخ الهجري'),
                    value: _showHijriDate,
                    onChanged: (v) => setState(() => _showHijriDate = v),
                  ),
                  SwitchListTile(
                    title: const Text('التاريخ الميلادي'),
                    value: _showGregorianDate,
                    onChanged: (v) => setState(() => _showGregorianDate = v),
                  ),
                  SwitchListTile(
                    title: const Text('الموضوع'),
                    value: _showSubjectInHeader,
                    onChanged: (v) => setState(() => _showSubjectInHeader = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // معاينة
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'معاينة الورقة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[50],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 20,
                          right: _barcodePosition == 'right' ? 20 : null,
                          left: _barcodePosition == 'left' ? 20 : null,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                if (_showBarcode)
                                  Container(
                                    width: 80,
                                    height: 30,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.only(bottom: 4),
                                  ),
                                if (_showReferenceNumber)
                                  const Text(
                                    'OUT-2024-00001',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (_showHijriDate)
                                  const Text(
                                    '1446/06/10',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                if (_showGregorianDate)
                                  const Text(
                                    '2024/12/12',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                if (_showSubjectInHeader)
                                  const Text(
                                    'الموضوع',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.blue,
                                    ),
                                  ),
                              ],
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
        ],
      ),
    );
  }

  Widget _buildImagePicker(String label, File? file, VoidCallback onPick) {
    return InkWell(
      onTap: onPick,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: file != null ? Colors.green : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: file != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(file, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
      ),
    );
  }
}
