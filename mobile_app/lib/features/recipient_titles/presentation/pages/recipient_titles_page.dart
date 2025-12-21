import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة صفات المستلمين
class RecipientTitlesPage extends StatefulWidget {
  const RecipientTitlesPage({super.key});

  @override
  State<RecipientTitlesPage> createState() => _RecipientTitlesPageState();
}

class _RecipientTitlesPageState extends State<RecipientTitlesPage> {
  final _searchController = TextEditingController();

  // API integration
  List<dynamic> _recipientTitles = [];
  List<dynamic> _filteredRecipientTitles = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRecipientTitles();
    _searchController.addListener(_filterRecipientTitles);
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
          child: const Text('صفات المستلمين'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showRecipientTitleDialog(),
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
                  hintText: 'بحث عن صفة...',
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

          // قائمة صفات المستلمين
          Expanded(
            child: _buildRecipientTitlesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'recipient_titles_fab',
        onPressed: () => _showRecipientTitleDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRecipientTitlesList() {
    if (_isLoading && _filteredRecipientTitles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError && _filteredRecipientTitles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.user_tag, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'خطأ في تحميل الصفات',
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
              onPressed: _loadRecipientTitles,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_filteredRecipientTitles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.user_tag, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'لا توجد نتائج'
                  : 'لا توجد صفات',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'جرب مصطلحات بحث مختلفة'
                  : 'ابدأ بإضافة صفة جديدة',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _filteredRecipientTitles.length,
      itemBuilder: (context, index) {
        final recipientTitle = _filteredRecipientTitles[index];
        return _buildRecipientTitleCard(recipientTitle, index);
      },
    );
  }

  Widget _buildRecipientTitleCard(
      Map<String, dynamic> recipientTitle, int index) {
    final isActive = recipientTitle['is_active'] ?? false;
    final title = recipientTitle['title'] ?? 'بدون عنوان';
    final usageCount = recipientTitle['usage_count'] ?? 0;

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
                  ? AppColors.success.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Iconsax.user_tag,
              color: isActive ? AppColors.success : Colors.grey,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
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
                'تم الإنشاء: ${_formatDate(recipientTitle['created_at'])}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) =>
                _handleRecipientTitleAction(value, recipientTitle),
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

  // Load recipient titles from API
  Future<void> _loadRecipientTitles() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/recipient-titles');

      if (response.data['success'] == true) {
        setState(() {
          _recipientTitles = response.data['data'] ?? [];
          _filteredRecipientTitles = List.from(_recipientTitles);
        });
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحميل الصفات');
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

  void _filterRecipientTitles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRecipientTitles = List.from(_recipientTitles);
      } else {
        _filteredRecipientTitles = _recipientTitles.where((recipientTitle) {
          final title = (recipientTitle['title'] ?? '').toLowerCase();
          return title.contains(query);
        }).toList();
      }
    });
  }

  void _handleRecipientTitleAction(
      String action, Map<String, dynamic> recipientTitle) {
    switch (action) {
      case 'edit':
        _showRecipientTitleDialog(recipientTitle: recipientTitle);
        break;
      case 'toggle':
        _toggleRecipientTitleStatus(recipientTitle);
        break;
      case 'delete':
        _showDeleteConfirmation(recipientTitle);
        break;
    }
  }

  void _showRecipientTitleDialog({Map<String, dynamic>? recipientTitle}) {
    final titleController =
        TextEditingController(text: recipientTitle?['title'] ?? '');

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
              recipientTitle != null ? 'تعديل الصفة' : 'إضافة صفة جديدة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'نص الصفة',
                hintText: 'مثال: المدير العام، الرئيس التنفيذي',
                prefixIcon: const Icon(Iconsax.user_tag),
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
                  if (titleController.text.isNotEmpty) {
                    Navigator.pop(context);
                    if (recipientTitle != null) {
                      _updateRecipientTitle(
                        recipientTitle['id'],
                        titleController.text,
                      );
                    } else {
                      _createRecipientTitle(
                        titleController.text,
                      );
                    }
                  }
                },
                child: Text(recipientTitle != null ? 'تحديث' : 'إضافة'),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> recipientTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content:
            Text('هل أنت متأكد من حذف الصفة "${recipientTitle['title']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRecipientTitle(recipientTitle['id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _createRecipientTitle(String title) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post('/recipient-titles', data: {
        'title': title,
        'is_active': true,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الصفة بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipientTitles();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إنشاء الصفة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إنشاء الصفة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _updateRecipientTitle(int id, String title) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.put('/recipient-titles/$id', data: {
        'title': title,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الصفة بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipientTitles();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحديث الصفة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث الصفة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _toggleRecipientTitleStatus(
      Map<String, dynamic> recipientTitle) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient
          .post('/recipient-titles/${recipientTitle['id']}/toggle-active');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              recipientTitle['is_active']
                  ? 'تم إلغاء تفعيل الصفة'
                  : 'تم تفعيل الصفة',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipientTitles();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تغيير حالة الصفة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تغيير حالة الصفة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteRecipientTitle(int id) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.delete('/recipient-titles/$id');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الصفة بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipientTitles();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حذف الصفة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف الصفة: $e'),
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
