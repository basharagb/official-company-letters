import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة إنشاء خطاب جديد
class LetterCreatePage extends StatefulWidget {
  const LetterCreatePage({super.key});

  @override
  State<LetterCreatePage> createState() => _LetterCreatePageState();
}

class _LetterCreatePageState extends State<LetterCreatePage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final _recipientController = TextEditingController();
  final _recipientTitleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();

  // API Data
  List<dynamic> _templates = [];
  List<dynamic> _recipients = [];
  List<dynamic> _organizations = [];
  List<dynamic> _recipientTitles = [];
  List<dynamic> _letterSubjects = [];

  // Selected values
  int? _selectedTemplateId;
  int? _selectedRecipientId;
  int? _selectedOrganizationId;
  int? _selectedRecipientTitleId;
  int? _selectedLetterSubjectId;

  @override
  void initState() {
    super.initState();
    _loadCreateData();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _recipientTitleController.dispose();
    _organizationController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('خطاب جديد'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveDraft,
            icon: const Icon(Iconsax.document_download),
            label: const Text('حفظ مسودة'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _nextStep,
          onStepCancel: _previousStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(
                        _currentStep == 2 ? 'إصدار الخطاب' : 'التالي',
                      ),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('السابق'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            // الخطوة 1: القالب وبيانات المستلم
            Step(
              title: const Text('القالب والمستلم'),
              subtitle: const Text('اختيار القالب وبيانات المستلم'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: FadeInRight(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    // Template selection
                    if (_templates.isNotEmpty) ...[
                      _buildDropdown(
                        label: 'القالب',
                        value: _selectedTemplateId,
                        items: _templates,
                        onChanged: (value) =>
                            setState(() => _selectedTemplateId = value),
                        displayText: (item) => item['name'] ?? 'قالب غير محدد',
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Recipient selection or manual entry
                    Row(
                      children: [
                        Expanded(
                          child: _recipients.isNotEmpty
                              ? _buildDropdown(
                                  label: 'اختر مستلم محفوظ',
                                  value: _selectedRecipientId,
                                  items: _recipients,
                                  onChanged: (value) {
                                    setState(
                                        () => _selectedRecipientId = value);
                                    _fillRecipientData(value);
                                  },
                                  displayText: (item) =>
                                      item['name'] ?? 'مستلم غير محدد',
                                )
                              : Container(),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () =>
                              setState(() => _selectedRecipientId = null),
                          child: const Text('إدخال يدوي'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _recipientController,
                      label: 'اسم المستلم',
                      hint: 'أدخل اسم المستلم',
                      icon: Iconsax.user,
                    ),
                    const SizedBox(height: 16),

                    // Recipient title selection or manual entry
                    if (_recipientTitles.isNotEmpty) ...[
                      _buildDropdown(
                        label: 'صفة المستلم',
                        value: _selectedRecipientTitleId,
                        items: _recipientTitles,
                        onChanged: (value) {
                          setState(() => _selectedRecipientTitleId = value);
                          final selected = _recipientTitles
                              .firstWhere((item) => item['id'] == value);
                          _recipientTitleController.text =
                              selected['title'] ?? '';
                        },
                        displayText: (item) => item['title'] ?? 'صفة غير محددة',
                      ),
                      const SizedBox(height: 8),
                    ],
                    _buildTextField(
                      controller: _recipientTitleController,
                      label: 'صفة المستلم (يدوي)',
                      hint: 'مثال: المدير العام',
                      icon: Iconsax.user_tag,
                    ),
                    const SizedBox(height: 16),

                    // Organization selection or manual entry
                    if (_organizations.isNotEmpty) ...[
                      _buildDropdown(
                        label: 'الجهة',
                        value: _selectedOrganizationId,
                        items: _organizations,
                        onChanged: (value) {
                          setState(() => _selectedOrganizationId = value);
                          final selected = _organizations
                              .firstWhere((item) => item['id'] == value);
                          _organizationController.text = selected['name'] ?? '';
                        },
                        displayText: (item) => item['name'] ?? 'جهة غير محددة',
                      ),
                      const SizedBox(height: 8),
                    ],
                    _buildTextField(
                      controller: _organizationController,
                      label: 'الجهة (يدوي)',
                      hint: 'اسم الشركة أو المؤسسة',
                      icon: Iconsax.building,
                    ),
                  ],
                ),
              ),
            ),

            // الخطوة 2: موضوع الخطاب
            Step(
              title: const Text('موضوع الخطاب'),
              subtitle: const Text('العنوان والمحتوى'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: FadeInRight(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    // Letter subject selection
                    if (_letterSubjects.isNotEmpty) ...[
                      _buildDropdown(
                        label: 'اختر موضوع محفوظ',
                        value: _selectedLetterSubjectId,
                        items: _letterSubjects,
                        onChanged: (value) {
                          setState(() => _selectedLetterSubjectId = value);
                          final selected = _letterSubjects
                              .firstWhere((item) => item['id'] == value);
                          _subjectController.text = selected['subject'] ?? '';
                        },
                        displayText: (item) =>
                            item['subject'] ?? 'موضوع غير محدد',
                      ),
                      const SizedBox(height: 16),
                    ],

                    _buildTextField(
                      controller: _subjectController,
                      label: 'موضوع الخطاب',
                      hint: 'أدخل موضوع الخطاب',
                      icon: Iconsax.document_text,
                    ),
                    const SizedBox(height: 16),

                    // Template content suggestion
                    if (_selectedTemplateId != null) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'محتوى القالب المحدد:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _getSelectedTemplateContent(),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 11.sp,
                                fontFamily: 'Cairo',
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            TextButton(
                              onPressed: _useTemplateContent,
                              child: Text(
                                'استخدام محتوى القالب',
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    _buildTextField(
                      controller: _contentController,
                      label: 'محتوى الخطاب',
                      hint: 'اكتب نص الخطاب هنا...',
                      icon: Iconsax.edit,
                      maxLines: 8,
                    ),
                  ],
                ),
              ),
            ),

            // الخطوة 3: المراجعة
            Step(
              title: const Text('المراجعة'),
              subtitle: const Text('تأكيد البيانات'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: FadeInRight(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReviewItem('المستلم', _recipientController.text),
                      _buildReviewItem('الصفة', _recipientTitleController.text),
                      _buildReviewItem('الجهة', _organizationController.text),
                      _buildReviewItem('الموضوع', _subjectController.text),
                      const Divider(),
                      const Text(
                        'محتوى الخطاب:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _contentController.text.isEmpty
                            ? 'لم يتم إدخال محتوى'
                            : _contentController.text,
                        style: TextStyle(
                          color: _contentController.text.isEmpty
                              ? Colors.grey
                              : Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        alignLabelWithHint: maxLines > 1,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required List<dynamic> items,
    required ValueChanged<int?> onChanged,
    required String Function(dynamic) displayText,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        prefixIcon: const Icon(Iconsax.arrow_down_1),
      ),
      items: items.map<DropdownMenuItem<int>>((item) {
        return DropdownMenuItem<int>(
          value: item['id'],
          child: Text(
            displayText(item),
            style: const TextStyle(fontFamily: 'Cairo'),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _fillRecipientData(int? recipientId) {
    if (recipientId == null) return;

    final recipient =
        _recipients.firstWhere((item) => item['id'] == recipientId);
    _recipientController.text = recipient['name'] ?? '';
    _recipientTitleController.text = recipient['title'] ?? '';
    _organizationController.text = recipient['organization'] ?? '';

    // Update organization selection if it exists in organizations list
    final orgName = recipient['organization'];
    if (orgName != null) {
      final org = _organizations.firstWhere(
        (item) => item['name'] == orgName,
        orElse: () => null,
      );
      if (org != null) {
        setState(() => _selectedOrganizationId = org['id']);
      }
    }
  }

  String _getSelectedTemplateContent() {
    if (_selectedTemplateId == null) return '';

    final template = _templates.firstWhere(
      (item) => item['id'] == _selectedTemplateId,
      orElse: () => null,
    );

    return template?['content'] ?? 'لا يوجد محتوى للقالب';
  }

  void _useTemplateContent() {
    final content = _getSelectedTemplateContent();
    if (content.isNotEmpty) {
      _contentController.text = content;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم استخدام محتوى القالب'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
                fontSize: 12.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'غير محدد' : value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: value.isEmpty ? Colors.grey : Colors.black87,
                fontFamily: 'Cairo',
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _issueLetter();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // Load create data from API
  Future<void> _loadCreateData() async {
    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/letters/create-data');

      if (response.data['success'] == true) {
        setState(() {
          _templates = response.data['data']['templates'] ?? [];
          _recipients = response.data['data']['recipients'] ?? [];
          _organizations = response.data['data']['organizations'] ?? [];
          _recipientTitles = response.data['data']['recipient_titles'] ?? [];
          _letterSubjects = response.data['data']['letter_subjects'] ?? [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحميل البيانات: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Create letter via API
  Future<void> _createLetter({bool isDraft = false}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final data = {
        'subject': _subjectController.text.trim(),
        'content': _contentController.text.trim(),
        'recipient_name': _recipientController.text.trim(),
        'recipient_title': _recipientTitleController.text.trim(),
        'recipient_organization': _organizationController.text.trim(),
        'template_id': _selectedTemplateId,
        'status': isDraft ? 'draft' : 'issued',
      };

      final response = await apiClient.post('/letters', data: data);

      if (response.data['success'] == true) {
        final letterId = response.data['data']?['id'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                isDraft ? 'تم حفظ المسودة بنجاح' : 'تم إصدار الخطاب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );

        if (!isDraft && letterId != null) {
          // الانتقال لصفحة تفاصيل الخطاب مع خيارات المشاركة
          _showShareOptions(letterId);
        } else {
          context.pop();
        }
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حفظ الخطاب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حفظ الخطاب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _saveDraft() {
    _createLetter(isDraft: true);
  }

  void _issueLetter() {
    _createLetter(isDraft: false);
  }

  /// عرض خيارات المشاركة بعد إصدار الخطاب
  void _showShareOptions(int letterId) {
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

            // أيقونة النجاح
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.tick_circle,
                color: AppColors.success,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              'تم إصدار الخطاب بنجاح!',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'اختر طريقة المشاركة',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 24.h),

            // خيارات المشاركة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Iconsax.document_download,
                  label: 'تحميل PDF',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/letters/$letterId');
                  },
                ),
                _buildShareOption(
                  icon: Icons.message,
                  label: 'واتساب',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _shareToWhatsApp(letterId);
                  },
                ),
                _buildShareOption(
                  icon: Iconsax.sms,
                  label: 'إيميل',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _shareToEmail(letterId);
                  },
                ),
                _buildShareOption(
                  icon: Iconsax.share,
                  label: 'مشاركة',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _shareLink(letterId);
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // زر عرض الخطاب
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/letters/$letterId');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: const Text('عرض الخطاب'),
              ),
            ),

            SizedBox(height: 12.h),

            // زر العودة للقائمة
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: const Text('العودة للقائمة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// مشاركة عبر الواتساب
  Future<void> _shareToWhatsApp(int letterId) async {
    final text =
        'خطاب رقم: ${_subjectController.text}\nرابط: https://emsg.elite-center-ld.com/share/$letterId';
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح الواتساب')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  /// مشاركة عبر الإيميل
  Future<void> _shareToEmail(int letterId) async {
    final subject = _subjectController.text;
    final body =
        'مرفق لكم الخطاب\nرابط: https://emsg.elite-center-ld.com/share/$letterId';
    final uri = Uri.parse(
        'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}');

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح البريد الإلكتروني')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  /// مشاركة الرابط
  void _shareLink(int letterId) {
    Share.share(
      'رابط الخطاب: https://emsg.elite-center-ld.com/share/$letterId',
      subject: _subjectController.text,
    );
  }
}
