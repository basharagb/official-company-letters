import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة المستلمين
class RecipientsPage extends StatefulWidget {
  const RecipientsPage({super.key});

  @override
  State<RecipientsPage> createState() => _RecipientsPageState();
}

class _RecipientsPageState extends State<RecipientsPage> {
  final _searchController = TextEditingController();

  // API integration
  List<dynamic> _recipients = [];
  List<dynamic> _filteredRecipients = [];
  List<dynamic> _organizations = [];
  List<dynamic> _recipientTitles = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRecipients();
    _loadSupportingData();
    _searchController.addListener(_filterRecipients);
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
          child: const Text('المستلمين'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showAddRecipientDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'بحث عن مستلم...',
                  prefixIcon: const Icon(Iconsax.search_normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
            ),
          ),

          // قائمة المستلمين
          Expanded(
            child: _buildRecipientsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecipientDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRecipientsList() {
    if (_isLoading && _filteredRecipients.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError && _filteredRecipients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.user, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'خطأ في تحميل المستلمين',
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
              onPressed: _loadRecipients,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_filteredRecipients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.user, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'لا توجد نتائج'
                  : 'لا توجد مستلمين',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'جرب مصطلحات بحث مختلفة'
                  : 'ابدأ بإضافة مستلم جديد',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _filteredRecipients.length,
      itemBuilder: (context, index) {
        final recipient = _filteredRecipients[index];
        return _buildRecipientCard(recipient, index);
      },
    );
  }

  Widget _buildRecipientCard(Map<String, dynamic> recipient, int index) {
    final isActive = recipient['is_active'] ?? false;
    final name = recipient['name'] ?? 'بدون اسم';
    final title = recipient['title'] ?? '';
    final organization = recipient['organization'] ?? '';

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
          leading: CircleAvatar(
            backgroundColor: isActive
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'م',
              style: TextStyle(
                color: isActive ? AppColors.primary : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
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
              if (title.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
              if (organization.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  organization,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11.sp,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
              SizedBox(height: 8.h),
              Text(
                'تم الإنشاء: ${_formatDate(recipient['created_at'])}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => _handleRecipientAction(value, recipient),
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

  // Load recipients from API
  Future<void> _loadRecipients() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.get('/recipients');

      if (response.data['success'] == true) {
        setState(() {
          _recipients = response.data['data'] ?? [];
          _filteredRecipients = List.from(_recipients);
        });
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحميل المستلمين');
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

  // Load supporting data (organizations, recipient titles)
  Future<void> _loadSupportingData() async {
    try {
      final apiClient = di.sl<ApiClient>();

      // Load organizations and recipient titles in parallel
      final futures = await Future.wait([
        apiClient.get('/organizations/active'),
        apiClient.get('/recipient-titles/active'),
      ]);

      setState(() {
        _organizations = futures[0].data['success'] == true
            ? (futures[0].data['data'] ?? [])
            : [];
        _recipientTitles = futures[1].data['success'] == true
            ? (futures[1].data['data'] ?? [])
            : [];
      });
    } catch (e) {
      // Silent fail for supporting data
    }
  }

  void _filterRecipients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRecipients = List.from(_recipients);
      } else {
        _filteredRecipients = _recipients.where((recipient) {
          final name = (recipient['name'] ?? '').toLowerCase();
          final title = (recipient['title'] ?? '').toLowerCase();
          final organization = (recipient['organization'] ?? '').toLowerCase();

          return name.contains(query) ||
              title.contains(query) ||
              organization.contains(query);
        }).toList();
      }
    });
  }

  void _handleRecipientAction(String action, Map<String, dynamic> recipient) {
    switch (action) {
      case 'edit':
        _showRecipientDialog(recipient: recipient);
        break;
      case 'toggle':
        _toggleRecipientStatus(recipient);
        break;
      case 'delete':
        _showDeleteConfirmation(recipient);
        break;
    }
  }

  void _showAddRecipientDialog(BuildContext context, {bool isEdit = false}) {
    _showRecipientDialog();
  }

  void _showRecipientDialog({Map<String, dynamic>? recipient}) {
    final nameController =
        TextEditingController(text: recipient?['name'] ?? '');
    final titleController =
        TextEditingController(text: recipient?['title'] ?? '');
    final organizationController =
        TextEditingController(text: recipient?['organization'] ?? '');

    int? selectedOrganizationId = recipient?['organization_id'];
    int? selectedRecipientTitleId = recipient?['recipient_title_id'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                recipient != null ? 'تعديل مستلم' : 'إضافة مستلم جديد',
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
                  labelText: 'اسم المستلم',
                  prefixIcon: const Icon(Iconsax.user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Recipient title dropdown
              if (_recipientTitles.isNotEmpty) ...[
                DropdownButtonFormField<int>(
                  value: selectedRecipientTitleId,
                  decoration: InputDecoration(
                    labelText: 'اختر صفة محفوظة (اختياري)',
                    prefixIcon: const Icon(Iconsax.user_tag),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  items: _recipientTitles.map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(item['title'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() {
                      selectedRecipientTitleId = value;
                      if (value != null) {
                        final selected = _recipientTitles
                            .firstWhere((item) => item['id'] == value);
                        titleController.text = selected['title'] ?? '';
                      }
                    });
                  },
                ),
                SizedBox(height: 16.h),
              ],

              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'الصفة (يدوي)',
                  prefixIcon: const Icon(Iconsax.user_tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Organization dropdown
              if (_organizations.isNotEmpty) ...[
                DropdownButtonFormField<int>(
                  value: selectedOrganizationId,
                  decoration: InputDecoration(
                    labelText: 'اختر جهة محفوظة (اختياري)',
                    prefixIcon: const Icon(Iconsax.building),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  items: _organizations.map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(item['name'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() {
                      selectedOrganizationId = value;
                      if (value != null) {
                        final selected = _organizations
                            .firstWhere((item) => item['id'] == value);
                        organizationController.text = selected['name'] ?? '';
                      }
                    });
                  },
                ),
                SizedBox(height: 16.h),
              ],

              TextFormField(
                controller: organizationController,
                decoration: InputDecoration(
                  labelText: 'الجهة (يدوي)',
                  prefixIcon: const Icon(Iconsax.building),
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
                    if (nameController.text.isNotEmpty) {
                      Navigator.pop(context);
                      if (recipient != null) {
                        _updateRecipient(
                          recipient['id'],
                          nameController.text,
                          titleController.text,
                          organizationController.text,
                          selectedOrganizationId,
                          selectedRecipientTitleId,
                        );
                      } else {
                        _createRecipient(
                          nameController.text,
                          titleController.text,
                          organizationController.text,
                          selectedOrganizationId,
                          selectedRecipientTitleId,
                        );
                      }
                    }
                  },
                  child: Text(recipient != null ? 'تحديث' : 'إضافة'),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> recipient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المستلم "${recipient['name']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRecipient(recipient['id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _createRecipient(String name, String? title,
      String? organization, int? organizationId, int? recipientTitleId) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post('/recipients', data: {
        'name': name,
        'title': title,
        'organization': organization,
        'organization_id': organizationId,
        'recipient_title_id': recipientTitleId,
        'is_active': true,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء المستلم بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipients();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إنشاء المستلم');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إنشاء المستلم: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _updateRecipient(int id, String name, String? title,
      String? organization, int? organizationId, int? recipientTitleId) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.put('/recipients/$id', data: {
        'name': name,
        'title': title,
        'organization': organization,
        'organization_id': organizationId,
        'recipient_title_id': recipientTitleId,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث المستلم بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipients();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تحديث المستلم');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث المستلم: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _toggleRecipientStatus(Map<String, dynamic> recipient) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response =
          await apiClient.post('/recipients/${recipient['id']}/toggle-active');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              recipient['is_active']
                  ? 'تم إلغاء تفعيل المستلم'
                  : 'تم تفعيل المستلم',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipients();
      } else {
        throw Exception(
            response.data['message'] ?? 'فشل في تغيير حالة المستلم');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تغيير حالة المستلم: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteRecipient(int id) async {
    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.delete('/recipients/$id');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المستلم بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadRecipients();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في حذف المستلم');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف المستلم: $e'),
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
