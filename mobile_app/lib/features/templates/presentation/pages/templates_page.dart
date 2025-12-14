import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;
import 'template_upload_page.dart';

/// صفحة قوالب الخطابات
class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  List<dynamic> _templates = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('قوالب الخطابات'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showAddTemplateOptions(),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _templates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError && _templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'خطأ في تحميل القوالب',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadTemplates,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'لا توجد قوالب',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
            ),
            SizedBox(height: 8.h),
            Text(
              'ابدأ بإنشاء قالب جديد',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => _showAddTemplateOptions(),
              icon: const Icon(Iconsax.add),
              label: const Text('إضافة قالب'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        return _buildTemplateCard(template, index);
      },
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template, int index) {
    final isActive = template['is_active'] ?? false;

    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      duration: const Duration(milliseconds: 400),
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.w),
          leading: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Iconsax.document_text,
              color: isActive ? AppColors.primary : Colors.grey,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  template['name'] ?? 'قالب بدون اسم',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    fontSize: 14.sp,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              if (!isActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'غير مفعل',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.sp,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (template['description'] != null) ...[
                SizedBox(height: 4.h),
                Text(
                  template['description'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Cairo',
                    fontSize: 12.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: 8.h),
              Text(
                'تم الإنشاء: ${_formatDate(template['created_at'])}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => _handleTemplateAction(value, template),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Iconsax.edit, size: 18),
                    SizedBox(width: 8),
                    Text('تعديل'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      isActive ? Iconsax.eye_slash : Iconsax.eye,
                      size: 18,
                      color: isActive ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isActive ? 'إلغاء التفعيل' : 'تفعيل',
                      style: TextStyle(
                        color: isActive ? Colors.orange : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Iconsax.trash, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('حذف', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Load templates from API
  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/templates');

      if (response.data['success'] == true) {
        setState(() {
          _templates = response.data['data'] ?? [];
        });
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحميل القوالب');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleTemplateAction(String action, Map<String, dynamic> template) {
    switch (action) {
      case 'edit':
        _showEditTemplateDialog(template);
        break;
      case 'toggle':
        _toggleTemplateStatus(template);
        break;
      case 'delete':
        _showDeleteConfirmation(template);
        break;
    }
  }

  void _showCreateTemplateDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة قالب جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم القالب',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف القالب (اختياري)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'محتوى القالب',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Navigator.of(context).pop();
                _createTemplate(
                  nameController.text,
                  descriptionController.text,
                  contentController.text,
                );
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditTemplateDialog(Map<String, dynamic> template) {
    final nameController = TextEditingController(text: template['name']);
    final descriptionController =
        TextEditingController(text: template['description'] ?? '');
    final contentController =
        TextEditingController(text: template['content'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل القالب'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم القالب',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف القالب (اختياري)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'محتوى القالب',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Navigator.of(context).pop();
                _updateTemplate(
                  template['id'],
                  nameController.text,
                  descriptionController.text,
                  contentController.text,
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف القالب'),
        content: Text('هل أنت متأكد من حذف القالب "${template['name']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTemplate(template['id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _createTemplate(
      String name, String? description, String content) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post('/templates', data: {
        'name': name,
        'description': description,
        'content': content,
        'is_active': true,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء القالب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadTemplates();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إنشاء القالب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إنشاء القالب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _updateTemplate(
      int id, String name, String? description, String content) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.put('/templates/$id', data: {
        'name': name,
        'description': description,
        'content': content,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث القالب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadTemplates();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحديث القالب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث القالب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _toggleTemplateStatus(Map<String, dynamic> template) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response =
          await apiClient.post('/templates/${template['id']}/toggle-active');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              template['is_active']
                  ? 'تم إلغاء تفعيل القالب'
                  : 'تم تفعيل القالب',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        _loadTemplates();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تغيير حالة القالب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تغيير حالة القالب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteTemplate(int id) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.delete('/templates/$id');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف القالب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadTemplates();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حذف القالب');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف القالب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'غير محدد';

    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'غير محدد';
    }
  }

  /// عرض خيارات إضافة قالب جديد
  void _showAddTemplateOptions() {
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
              'إضافة قالب جديد',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'اختر طريقة إضافة القالب',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 20.h),

            // خيار رفع ورق رسمي (سكان)
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.scan, color: AppColors.primary),
              ),
              title: const Text('رفع ورق رسمي (سكان)'),
              subtitle: const Text('مسح ضوئي أو رفع PDF للورق الرسمي'),
              trailing: const Icon(Iconsax.arrow_left_2),
              onTap: () {
                Navigator.pop(context);
                _navigateToTemplateUpload();
              },
            ),
            const Divider(),

            // خيار إنشاء قالب نصي
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.document_text, color: Colors.green),
              ),
              title: const Text('إنشاء قالب نصي'),
              subtitle: const Text('قالب نصي بسيط للخطابات'),
              trailing: const Icon(Iconsax.arrow_left_2),
              onTap: () {
                Navigator.pop(context);
                _showCreateTemplateDialog();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  /// الانتقال لصفحة رفع القالب
  void _navigateToTemplateUpload() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TemplateUploadPage(),
      ),
    );

    // إعادة تحميل القوالب إذا تم إضافة قالب جديد
    if (result == true) {
      _loadTemplates();
    }
  }
}
