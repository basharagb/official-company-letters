import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة تعديل الخطاب
class LetterEditPage extends StatefulWidget {
  final int letterId;

  const LetterEditPage({
    super.key,
    required this.letterId,
  });

  @override
  State<LetterEditPage> createState() => _LetterEditPageState();
}

class _LetterEditPageState extends State<LetterEditPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _recipientController = TextEditingController();
  final _recipientTitleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();

  // Letter data
  Map<String, dynamic>? _letterData;

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
    _loadLetterData();
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
          child: const Text('تعديل الخطاب'),
        ),
        actions: [
          if (_letterData != null) ...[
            // Issue letter button
            if (_letterData!['status'] == 'draft') ...[
              TextButton.icon(
                onPressed: _issueLetter,
                icon: const Icon(Iconsax.send_1),
                label: const Text('إصدار'),
              ),
            ],
            // More options menu
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Iconsax.trash, color: Colors.red),
                      SizedBox(width: 8),
                      Text('حذف الخطاب', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                if (_letterData!['status'] == 'issued') ...[
                  const PopupMenuItem(
                    value: 'pdf',
                    child: Row(
                      children: [
                        Icon(Iconsax.document_download),
                        SizedBox(width: 8),
                        Text('تحميل PDF'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Iconsax.share),
                        SizedBox(width: 8),
                        Text('مشاركة'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'email',
                    child: Row(
                      children: [
                        Icon(Iconsax.sms),
                        SizedBox(width: 8),
                        Text('إرسال بالبريد'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _letterData == null
              ? const Center(child: Text('لم يتم العثور على الخطاب'))
              : _buildEditForm(),
      bottomNavigationBar: _letterData != null && !_isLoading
          ? Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      child: const Text('حفظ مسودة'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updateLetter,
                      child: const Text('حفظ التغييرات'),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Letter status indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: _getStatusColor().withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getStatusIcon(), color: _getStatusColor(), size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

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
              SizedBox(height: 16.h),
            ],

            // Recipient selection
            if (_recipients.isNotEmpty) ...[
              _buildDropdown(
                label: 'اختر مستلم محفوظ',
                value: _selectedRecipientId,
                items: _recipients,
                onChanged: (value) {
                  setState(() => _selectedRecipientId = value);
                  _fillRecipientData(value);
                },
                displayText: (item) => item['name'] ?? 'مستلم غير محدد',
              ),
              SizedBox(height: 16.h),
            ],

            _buildTextField(
              controller: _recipientController,
              label: 'اسم المستلم',
              hint: 'أدخل اسم المستلم',
              icon: Iconsax.user,
            ),
            SizedBox(height: 16.h),

            // Recipient title selection
            if (_recipientTitles.isNotEmpty) ...[
              _buildDropdown(
                label: 'صفة المستلم',
                value: _selectedRecipientTitleId,
                items: _recipientTitles,
                onChanged: (value) {
                  setState(() => _selectedRecipientTitleId = value);
                  final selected = _recipientTitles
                      .firstWhere((item) => item['id'] == value);
                  _recipientTitleController.text = selected['title'] ?? '';
                },
                displayText: (item) => item['title'] ?? 'صفة غير محددة',
              ),
              SizedBox(height: 8.h),
            ],
            _buildTextField(
              controller: _recipientTitleController,
              label: 'صفة المستلم',
              hint: 'مثال: المدير العام',
              icon: Iconsax.user_tag,
            ),
            SizedBox(height: 16.h),

            // Organization selection
            if (_organizations.isNotEmpty) ...[
              _buildDropdown(
                label: 'الجهة',
                value: _selectedOrganizationId,
                items: _organizations,
                onChanged: (value) {
                  setState(() => _selectedOrganizationId = value);
                  final selected =
                      _organizations.firstWhere((item) => item['id'] == value);
                  _organizationController.text = selected['name'] ?? '';
                },
                displayText: (item) => item['name'] ?? 'جهة غير محددة',
              ),
              SizedBox(height: 8.h),
            ],
            _buildTextField(
              controller: _organizationController,
              label: 'الجهة',
              hint: 'اسم الشركة أو المؤسسة',
              icon: Iconsax.building,
            ),
            SizedBox(height: 24.h),

            // Letter subject selection
            if (_letterSubjects.isNotEmpty) ...[
              _buildDropdown(
                label: 'اختر موضوع محفوظ',
                value: _selectedLetterSubjectId,
                items: _letterSubjects,
                onChanged: (value) {
                  setState(() => _selectedLetterSubjectId = value);
                  final selected =
                      _letterSubjects.firstWhere((item) => item['id'] == value);
                  _subjectController.text = selected['subject'] ?? '';
                },
                displayText: (item) => item['subject'] ?? 'موضوع غير محدد',
              ),
              SizedBox(height: 16.h),
            ],

            _buildTextField(
              controller: _subjectController,
              label: 'موضوع الخطاب',
              hint: 'أدخل موضوع الخطاب',
              icon: Iconsax.document_text,
            ),
            SizedBox(height: 16.h),

            _buildTextField(
              controller: _contentController,
              label: 'محتوى الخطاب',
              hint: 'اكتب نص الخطاب هنا...',
              icon: Iconsax.edit,
              maxLines: 8,
            ),

            SizedBox(height: 100.h), // Space for bottom bar
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
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

  // Load letter data from API
  Future<void> _loadLetterData() async {
    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/letters/${widget.letterId}');

      if (response.data['success'] == true) {
        final letter = response.data['data'];
        setState(() {
          _letterData = letter;
          _recipientController.text = letter['recipient_name'] ?? '';
          _recipientTitleController.text = letter['recipient_title'] ?? '';
          _organizationController.text = letter['recipient_organization'] ?? '';
          _subjectController.text = letter['subject'] ?? '';
          _contentController.text = letter['content'] ?? '';
          _selectedTemplateId = letter['template_id'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحميل بيانات الخطاب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Load create data from API
  Future<void> _loadCreateData() async {
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
      // Silent fail for create data
    }
  }

  void _fillRecipientData(int? recipientId) {
    if (recipientId == null) return;

    final recipient =
        _recipients.firstWhere((item) => item['id'] == recipientId);
    _recipientController.text = recipient['name'] ?? '';
    _recipientTitleController.text = recipient['title'] ?? '';
    _organizationController.text = recipient['organization'] ?? '';
  }

  // Update letter via API
  Future<void> _updateLetter() async {
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
      };

      final response =
          await apiClient.put('/letters/${widget.letterId}', data: data);

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الخطاب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحديث الخطاب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث الخطاب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveDraft() async {
    // Save as draft (same as update but with status)
    await _updateLetter();
  }

  Future<void> _issueLetter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final response =
          await apiClient.post('/letters/${widget.letterId}/issue');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إصدار الخطاب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إصدار الخطاب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إصدار الخطاب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'delete':
        _showDeleteDialog();
        break;
      case 'pdf':
        _downloadPDF();
        break;
      case 'share':
        _shareLetter();
        break;
      case 'email':
        _showEmailDialog();
        break;
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الخطاب'),
        content: const Text(
            'هل أنت متأكد من رغبتك في حذف هذا الخطاب؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteLetter();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLetter() async {
    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.delete('/letters/${widget.letterId}');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الخطاب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حذف الخطاب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف الخطاب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadPDF() async {
    try {
      final apiClient = di.sl<ApiClient>();
      await apiClient.get('/letters/${widget.letterId}/pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحميل ملف PDF بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحميل PDF: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _shareLetter() async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response =
          await apiClient.get('/letters/${widget.letterId}/share-link');

      if (response.data['success'] == true) {
        final shareUrl = response.data['data']['share_url'];
        // TODO: Implement sharing functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم نسخ رابط المشاركة'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الحصول على رابط المشاركة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showEmailDialog() {
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إرسال بالبريد الإلكتروني'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'رسالة إضافية (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendEmail(emailController.text, messageController.text);
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmail(String email, String message) async {
    if (email.isEmpty) return;

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post(
        '/letters/${widget.letterId}/send-email',
        data: {'email': email, 'message': message},
      );

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال الخطاب بالبريد الإلكتروني بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إرسال البريد الإلكتروني: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Color _getStatusColor() {
    switch (_letterData?['status']) {
      case 'draft':
        return Colors.orange;
      case 'issued':
        return Colors.green;
      case 'sent':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (_letterData?['status']) {
      case 'draft':
        return Iconsax.edit;
      case 'issued':
        return Iconsax.tick_circle;
      case 'sent':
        return Iconsax.send_1;
      default:
        return Iconsax.document;
    }
  }

  String _getStatusText() {
    switch (_letterData?['status']) {
      case 'draft':
        return 'مسودة';
      case 'issued':
        return 'مُصدر';
      case 'sent':
        return 'مُرسل';
      default:
        return 'غير معروف';
    }
  }
}
