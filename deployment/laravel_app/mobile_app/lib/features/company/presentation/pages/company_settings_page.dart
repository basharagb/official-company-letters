import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/company_remote_datasource.dart';

/// صفحة إعدادات الشركة
class CompanySettingsPage extends StatefulWidget {
  const CompanySettingsPage({super.key});

  @override
  State<CompanySettingsPage> createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends State<CompanySettingsPage> {
  bool _isLoading = false;
  Map<String, dynamic>? _companyData;
  Map<String, dynamic>? _letterheadSettings;

  // Controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Letterhead settings
  String _barcodePosition = 'right';
  bool _showBarcode = true;
  bool _showReferenceNumber = true;
  bool _showHijriDate = true;
  bool _showGregorianDate = true;
  bool _showSubjectInHeader = true;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final dataSource = GetIt.instance<CompanyRemoteDataSource>();
      final company = await dataSource.getCompany();
      final letterhead = await dataSource.getLetterheadSettings();

      setState(() {
        _companyData = company;
        _letterheadSettings = letterhead;

        // Fill controllers
        _nameController.text = company['name'] ?? '';
        _addressController.text = company['address'] ?? '';
        _phoneController.text = company['phone'] ?? '';
        _emailController.text = company['email'] ?? '';

        // Letterhead settings
        _barcodePosition = letterhead['barcode_position'] ?? 'right';
        _showBarcode = letterhead['show_barcode'] ?? true;
        _showReferenceNumber = letterhead['show_reference_number'] ?? true;
        _showHijriDate = letterhead['show_hijri_date'] ?? true;
        _showGregorianDate = letterhead['show_gregorian_date'] ?? true;
        _showSubjectInHeader = letterhead['show_subject_in_header'] ?? true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isLoading = true);
    try {
      final dataSource = GetIt.instance<CompanyRemoteDataSource>();
      switch (type) {
        case 'logo':
          await dataSource.uploadLogo(image.path);
          break;
        case 'signature':
          await dataSource.uploadSignature(image.path);
          break;
        case 'stamp':
          await dataSource.uploadStamp(image.path);
          break;
        case 'letterhead':
          await dataSource.uploadLetterhead(image.path);
          break;
      }
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('تم الرفع بنجاح'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
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

      // Save company data
      await dataSource.updateCompany({
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
      });

      // Save letterhead settings
      await dataSource.updateLetterheadSettings({
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
            content: Text('تم حفظ الإعدادات بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('إعدادات الشركة'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_4),
            onPressed: () => context.push('/company/setup'),
            tooltip: 'معالج الإعداد',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              child: _companyData?['logo'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        _companyData!['logo_url'] ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Iconsax.image, size: 40),
                                      ),
                                    )
                                  : const Icon(
                                      Iconsax.image,
                                      size: 40,
                                      color: AppColors.textSecondary,
                                    ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _uploadImage('logo'),
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
                                Icon(Iconsax.building,
                                    color: AppColors.primary),
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
                              controller: _nameController,
                              label: 'اسم الشركة',
                              hint: 'أدخل اسم الشركة',
                              icon: Iconsax.building_4,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _addressController,
                              label: 'العنوان',
                              hint: 'أدخل عنوان الشركة',
                              icon: Iconsax.location,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _phoneController,
                              label: 'رقم الهاتف',
                              hint: 'أدخل رقم الهاتف',
                              icon: Iconsax.call,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
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
                                    onTap: () => _uploadImage('signature'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildUploadBox(
                                    title: 'الختم',
                                    icon: Iconsax.verify,
                                    onTap: () => _uploadImage('stamp'),
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

                  // الورق الرسمي
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
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
                                Icon(Iconsax.document,
                                    color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'الورق الرسمي',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'قم برفع سكان للورق الرسمي لاستخدامه كخلفية للخطابات',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () => _uploadImage('letterhead'),
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _letterheadSettings?[
                                                'letterhead_file'] !=
                                            null
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: _letterheadSettings?['letterhead_url'] !=
                                        null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          _letterheadSettings![
                                              'letterhead_url'],
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              _buildUploadPlaceholder(),
                                        ),
                                      )
                                    : _buildUploadPlaceholder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // إعدادات الباركود
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
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
                                Icon(Iconsax.barcode, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'إعدادات الباركود',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'الباركود ← الرقم الصادر ← التاريخ ← الموضوع',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            const Text('موقع الباركود',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('يمين',
                                        style: TextStyle(fontSize: 14)),
                                    value: 'right',
                                    groupValue: _barcodePosition,
                                    onChanged: (v) =>
                                        setState(() => _barcodePosition = v!),
                                    dense: true,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('يسار',
                                        style: TextStyle(fontSize: 14)),
                                    value: 'left',
                                    groupValue: _barcodePosition,
                                    onChanged: (v) =>
                                        setState(() => _barcodePosition = v!),
                                    dense: true,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            SwitchListTile(
                              title: const Text('الباركود',
                                  style: TextStyle(fontSize: 14)),
                              value: _showBarcode,
                              onChanged: (v) =>
                                  setState(() => _showBarcode = v),
                              dense: true,
                            ),
                            SwitchListTile(
                              title: const Text('الرقم الصادر',
                                  style: TextStyle(fontSize: 14)),
                              value: _showReferenceNumber,
                              onChanged: (v) =>
                                  setState(() => _showReferenceNumber = v),
                              dense: true,
                            ),
                            SwitchListTile(
                              title: const Text('التاريخ الهجري',
                                  style: TextStyle(fontSize: 14)),
                              value: _showHijriDate,
                              onChanged: (v) =>
                                  setState(() => _showHijriDate = v),
                              dense: true,
                            ),
                            SwitchListTile(
                              title: const Text('التاريخ الميلادي',
                                  style: TextStyle(fontSize: 14)),
                              value: _showGregorianDate,
                              onChanged: (v) =>
                                  setState(() => _showGregorianDate = v),
                              dense: true,
                            ),
                            SwitchListTile(
                              title: const Text('الموضوع',
                                  style: TextStyle(fontSize: 14)),
                              value: _showSubjectInHeader,
                              onChanged: (v) =>
                                  setState(() => _showSubjectInHeader = v),
                              dense: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // زر الحفظ
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    duration: const Duration(milliseconds: 400),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('حفظ الإعدادات'),
                      ),
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
        Icon(Iconsax.cloud_add, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        const Text('اضغط لرفع الورق الرسمي'),
        const Text('PDF أو صورة',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildUploadBox({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
