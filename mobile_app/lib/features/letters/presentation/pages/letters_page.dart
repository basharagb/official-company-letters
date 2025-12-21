import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة قائمة الخطابات مع بحث وفلترة
class LettersPage extends StatefulWidget {
  const LettersPage({super.key});

  @override
  State<LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<LettersPage> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'all';

  // API integration
  List<dynamic> _letters = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Pagination
  int _currentPage = 1;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  // Filtering
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _loadLetters();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('الخطابات'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: _showFilterSheet,
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
                  hintText: 'بحث بالرقم، الموضوع، المستلم...',
                  prefixIcon: const Icon(Iconsax.search_normal),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),

          // فلاتر الحالة
          FadeInRight(
            duration: const Duration(milliseconds: 500),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatusChip('all', 'الكل'),
                  _buildStatusChip('draft', 'مسودة'),
                  _buildStatusChip('issued', 'صادر'),
                  _buildStatusChip('sent', 'مُرسل'),
                ],
              ),
            ),
          ),

          // قائمة الخطابات
          Expanded(
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: _buildLettersList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'letters_page_fab',
        onPressed: () => context.push(AppRoutes.letterCreate),
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: Colors.white),
        label: const Text(
          'خطاب جديد',
          style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedStatus = status);
        },
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  // Load letters from API
  Future<void> _loadLetters({bool loadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      if (!loadMore) {
        _letters.clear();
        _currentPage = 1;
      }
    });

    try {
      final apiClient = di.sl<ApiClient>();

      final queryParams = <String, dynamic>{
        'page': _currentPage,
        'per_page': 20,
      };

      if (_searchController.text.isNotEmpty) {
        queryParams['search'] = _searchController.text;
      }

      if (_selectedStatus != 'all') {
        queryParams['status'] = _selectedStatus;
      }

      if (_fromDate != null) {
        queryParams['from'] = _fromDate!.toIso8601String().split('T')[0];
      }

      if (_toDate != null) {
        queryParams['to'] = _toDate!.toIso8601String().split('T')[0];
      }

      final response =
          await apiClient.get('/letters', queryParameters: queryParams);

      if (response.data['success'] == true) {
        final newLetters = response.data['data']['data'] as List;

        setState(() {
          if (loadMore) {
            _letters.addAll(newLetters);
          } else {
            _letters = newLetters;
          }

          _hasMoreData = newLetters.length == 20;
          _currentPage++;
        });
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

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMoreData && !_isLoading) {
        _loadLetters(loadMore: true);
      }
    }
  }

  Widget _buildLettersList() {
    if (_isLoading && _letters.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError && _letters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'خطأ في تحميل الخطابات',
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
              onPressed: () => _loadLetters(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_letters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'لا توجد خطابات',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
            ),
            SizedBox(height: 8.h),
            Text(
              'ابدأ بإنشاء خطاب جديد',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: _letters.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _letters.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _buildLetterCard(_letters[index], index);
      },
    );
  }

  Widget _buildLetterCard(Map<String, dynamic> letter, int index) {
    final status = letter['status'] ?? 'draft';
    final statusColor = _getStatusColorFromString(status);
    final statusText = _getStatusTextFromString(status);

    return FadeInUp(
      delay: Duration(milliseconds: 50 * index),
      duration: const Duration(milliseconds: 400),
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: InkWell(
          onTap: () => context.push('/letters/${letter['id']}'),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        letter['reference_number'] ?? 'غير محدد',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  letter['subject'] ?? 'بدون موضوع',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Iconsax.user,
                        size: 16.sp, color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        letter['recipient_name'] ?? 'غير محدد',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.sp,
                          fontFamily: 'Cairo',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Iconsax.calendar,
                        size: 16.sp, color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(letter['created_at']),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColorFromString(String status) {
    switch (status) {
      case 'draft':
        return AppColors.warning;
      case 'issued':
        return AppColors.info;
      case 'sent':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  String _getStatusTextFromString(String status) {
    switch (status) {
      case 'draft':
        return 'مسودة';
      case 'issued':
        return 'صادر';
      case 'sent':
        return 'مُرسل';
      default:
        return 'غير معروف';
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

  void _performSearch() {
    _loadLetters();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فلترة الخطابات',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 20.h),

            // Date range filter
            Text(
              'فترة التاريخ',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectFromDate(),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.calendar, size: 16.sp),
                          SizedBox(width: 8.w),
                          Text(
                            _fromDate != null
                                ? _formatDate(_fromDate!.toIso8601String())
                                : 'من تاريخ',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectToDate(),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.calendar, size: 16.sp),
                          SizedBox(width: 8.w),
                          Text(
                            _toDate != null
                                ? _formatDate(_toDate!.toIso8601String())
                                : 'إلى تاريخ',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Clear filters button
            TextButton(
              onPressed: () {
                setState(() {
                  _fromDate = null;
                  _toDate = null;
                });
              },
              child: const Text('مسح الفلاتر'),
            ),

            const Spacer(),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _loadLetters();
                },
                child: const Text('تطبيق الفلتر'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _fromDate = date);
    }
  }

  Future<void> _selectToDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _toDate = date);
    }
  }
}
