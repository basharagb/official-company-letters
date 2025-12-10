import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';

/// صفحة إنشاء خطاب جديد
class LetterCreatePage extends StatefulWidget {
  const LetterCreatePage({super.key});

  @override
  State<LetterCreatePage> createState() => _LetterCreatePageState();
}

class _LetterCreatePageState extends State<LetterCreatePage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _recipientController = TextEditingController();
  final _recipientTitleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();

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
            // الخطوة 1: بيانات المستلم
            Step(
              title: const Text('بيانات المستلم'),
              subtitle: const Text('اسم المستلم والجهة'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: FadeInRight(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _recipientController,
                      label: 'اسم المستلم',
                      hint: 'أدخل اسم المستلم',
                      icon: Iconsax.user,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _recipientTitleController,
                      label: 'صفة المستلم',
                      hint: 'مثال: المدير العام',
                      icon: Iconsax.user_tag,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _organizationController,
                      label: 'الجهة',
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
                    _buildTextField(
                      controller: _subjectController,
                      label: 'موضوع الخطاب',
                      hint: 'أدخل موضوع الخطاب',
                      icon: Iconsax.document_text,
                    ),
                    const SizedBox(height: 16),
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

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
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

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ المسودة'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _issueLetter() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement letter creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إصدار الخطاب بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }
}
