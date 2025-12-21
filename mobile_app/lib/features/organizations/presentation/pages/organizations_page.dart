import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة الجهات/المنظمات
class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({super.key});

  @override
  State<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  final _searchController = TextEditingController();

  // API integration
  List<dynamic> _organizations = [];
  List<dynamic> _filteredOrganizations = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
    _searchController.addListener(_filterOrganizations);
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
          child: const Text('الجهات'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showOrganizationDialog(),
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
                  hintText: 'بحث عن جهة...',
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

          // قائمة الجهات
          Expanded(
            child: _buildOrganizationsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'organizations_fab',
        onPressed: () => _showOrganizationDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOrganizationsList() {
    if (_isLoading && _filteredOrganizations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError && _filteredOrganizations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.building, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'خطأ في تحميل الجهات',
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
              onPressed: _loadOrganizations,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_filteredOrganizations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.building, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'لا توجد نتائج'
                  : 'لا توجد جهات',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'جرب مصطلحات بحث مختلفة'
                  : 'ابدأ بإضافة جهة جديدة',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _filteredOrganizations.length,
      itemBuilder: (context, index) {
        final organization = _filteredOrganizations[index];
        return _buildOrganizationCard(organization, index);
      },
    );
  }

  Widget _buildOrganizationCard(Map<String, dynamic> organization, int index) {
    final isActive = organization['is_active'] ?? false;
    final name = organization['name'] ?? 'بدون اسم';
    final lettersCount = organization['letters_count'] ?? 0;

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
                  ? AppColors.info.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Iconsax.building,
              color: isActive ? AppColors.info : Colors.grey,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  name,
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
                '$lettersCount خطاب',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'تم الإنشاء: ${_formatDate(organization['created_at'])}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) =>
                _handleOrganizationAction(value, organization),
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

  // Load organizations from API
  Future<void> _loadOrganizations() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/organizations');

      if (response.data['success'] == true) {
        setState(() {
          _organizations = response.data['data'] ?? [];
          _filteredOrganizations = List.from(_organizations);
        });
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحميل الجهات');
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

  void _filterOrganizations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOrganizations = List.from(_organizations);
      } else {
        _filteredOrganizations = _organizations.where((organization) {
          final name = (organization['name'] ?? '').toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

  void _handleOrganizationAction(
      String action, Map<String, dynamic> organization) {
    switch (action) {
      case 'edit':
        _showOrganizationDialog(organization: organization);
        break;
      case 'toggle':
        _toggleOrganizationStatus(organization);
        break;
      case 'delete':
        _showDeleteConfirmation(organization);
        break;
    }
  }

  void _showOrganizationDialog({Map<String, dynamic>? organization}) {
    final nameController =
        TextEditingController(text: organization?['name'] ?? '');
    final descriptionController =
        TextEditingController(text: organization?['description'] ?? '');

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
              organization != null ? 'تعديل الجهة' : 'إضافة جهة جديدة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'اسم الجهة',
                prefixIcon: const Icon(Iconsax.building),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'وصف الجهة (اختياري)',
                prefixIcon: const Icon(Iconsax.document_text),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    Navigator.pop(context);
                    if (organization != null) {
                      _updateOrganization(
                        organization['id'],
                        nameController.text,
                        descriptionController.text,
                      );
                    } else {
                      _createOrganization(
                        nameController.text,
                        descriptionController.text,
                      );
                    }
                  }
                },
                child: Text(organization != null ? 'تحديث' : 'إضافة'),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> organization) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الجهة "${organization['name']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteOrganization(organization['id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _createOrganization(String name, String? description) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post('/organizations', data: {
        'name': name,
        'description': description,
        'is_active': true,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الجهة بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadOrganizations();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إنشاء الجهة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إنشاء الجهة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _updateOrganization(
      int id, String name, String? description) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.put('/organizations/$id', data: {
        'name': name,
        'description': description,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الجهة بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadOrganizations();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحديث الجهة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث الجهة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _toggleOrganizationStatus(
      Map<String, dynamic> organization) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient
          .post('/organizations/${organization['id']}/toggle-active');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              organization['is_active']
                  ? 'تم إلغاء تفعيل الجهة'
                  : 'تم تفعيل الجهة',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        _loadOrganizations();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تغيير حالة الجهة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تغيير حالة الجهة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteOrganization(int id) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.delete('/organizations/$id');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الجهة بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadOrganizations();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حذف الجهة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف الجهة: $e'),
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
