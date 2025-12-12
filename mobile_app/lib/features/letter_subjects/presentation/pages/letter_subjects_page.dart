import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة مواضيع الخطابات
class LetterSubjectsPage extends StatefulWidget {
  const LetterSubjectsPage({super.key});

  @override
  State<LetterSubjectsPage> createState() => _LetterSubjectsPageState();
}

class _LetterSubjectsPageState extends State<LetterSubjectsPage> {
  final _searchController = TextEditingController();

  // API integration
  List<dynamic> _letterSubjects = [];
  List<dynamic> _filteredLetterSubjects = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLetterSubjects();
    _searchController.addListener(_filterLetterSubjects);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('مواضيع الخطابات'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showLetterSubjectDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'بحث عن موضوع...',
                  prefixIcon: const Icon(Iconsax.search_normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
            ),
          ),

          // قائمة مواضيع الخطابات
          Expanded(
            child: _buildLetterSubjectsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLetterSubjectDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLetterSubjectsList() {
    if (_isLoading && _filteredLetterSubjects.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError && _filteredLetterSubjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'خطأ في تحميل المواضيع',
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
              onPressed: _loadLetterSubjects,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_filteredLetterSubjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'لا توجد نتائج'
                  : 'لا توجد مواضيع',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'جرب مصطلحات بحث مختلفة'
                  : 'ابدأ بإضافة موضوع جديد',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _filteredLetterSubjects.length,
      itemBuilder: (context, index) {
        final letterSubject = _filteredLetterSubjects[index];
        return _buildLetterSubjectCard(letterSubject, index);
      },
    );
  }

  Widget _buildLetterSubjectCard(
      Map<String, dynamic> letterSubject, int index) {
    final isActive = letterSubject['is_active'] ?? false;
    final subject = letterSubject['subject'] ?? 'بدون موضوع';
    final usageCount = letterSubject['usage_count'] ?? 0;

    return FadeInUp(
      delay: Duration(milliseconds: 50 * index),
      duration: const Duration(milliseconds: 400),
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(12.w),
          leading: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.warning.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Iconsax.document_text,
              color: isActive ? AppColors.warning : Colors.grey,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  subject,
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
              SizedBox(height: 4.h),
              Text(
                'مستخدم $usageCount مرة',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'تم الإنشاء: ${_formatDate(letterSubject['created_at'])}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) =>
                _handleLetterSubjectAction(value, letterSubject),
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

  // Load letter subjects from API
  Future<void> _loadLetterSubjects() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/letter-subjects');

      if (response.data['success'] == true) {
        setState(() {
          _letterSubjects = response.data['data'] ?? [];
          _filteredLetterSubjects = List.from(_letterSubjects);
        });
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحميل المواضيع');
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

  void _filterLetterSubjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLetterSubjects = List.from(_letterSubjects);
      } else {
        _filteredLetterSubjects = _letterSubjects.where((letterSubject) {
          final subject = (letterSubject['subject'] ?? '').toLowerCase();
          return subject.contains(query);
        }).toList();
      }
    });
  }

  void _handleLetterSubjectAction(
      String action, Map<String, dynamic> letterSubject) {
    switch (action) {
      case 'edit':
        _showLetterSubjectDialog(letterSubject: letterSubject);
        break;
      case 'toggle':
        _toggleLetterSubjectStatus(letterSubject);
        break;
      case 'delete':
        _showDeleteConfirmation(letterSubject);
        break;
    }
  }

  void _showLetterSubjectDialog({Map<String, dynamic>? letterSubject}) {
    final subjectController =
        TextEditingController(text: letterSubject?['subject'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20.w,
          right: 20.w,
          top: 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              letterSubject != null ? 'تعديل الموضوع' : 'إضافة موضوع جديد',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'نص الموضوع',
                hintText: 'مثال: طلب تعاون، خطاب شكر',
                prefixIcon: const Icon(Iconsax.document_text),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (subjectController.text.isNotEmpty) {
                    Navigator.pop(context);
                    if (letterSubject != null) {
                      _updateLetterSubject(
                        letterSubject['id'],
                        subjectController.text,
                      );
                    } else {
                      _createLetterSubject(
                        subjectController.text,
                      );
                    }
                  }
                },
                child: Text(letterSubject != null ? 'تحديث' : 'إضافة'),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> letterSubject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content:
            Text('هل أنت متأكد من حذف الموضوع "${letterSubject['subject']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteLetterSubject(letterSubject['id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _createLetterSubject(String subject) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post('/letter-subjects', data: {
        'subject': subject,
        'is_active': true,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الموضوع بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadLetterSubjects();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إنشاء الموضوع');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إنشاء الموضوع: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _updateLetterSubject(int id, String subject) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.put('/letter-subjects/$id', data: {
        'subject': subject,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الموضوع بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadLetterSubjects();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحديث الموضوع');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث الموضوع: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _toggleLetterSubjectStatus(
      Map<String, dynamic> letterSubject) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient
          .post('/letter-subjects/${letterSubject['id']}/toggle-active');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              letterSubject['is_active']
                  ? 'تم إلغاء تفعيل الموضوع'
                  : 'تم تفعيل الموضوع',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        _loadLetterSubjects();
      } else {
        throw Exception(
            response.data['message'] ?? 'فشل في تغيير حالة الموضوع');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تغيير حالة الموضوع: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteLetterSubject(int id) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.delete('/letter-subjects/$id');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الموضوع بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadLetterSubjects();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حذف الموضوع');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف الموضوع: $e'),
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
}
