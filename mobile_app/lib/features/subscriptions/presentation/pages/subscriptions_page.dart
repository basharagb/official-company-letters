import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;

/// صفحة الاشتراكات
class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  // API integration
  Map<String, dynamic>? _currentSubscription;
  List<dynamic> _availablePlans = [];
  List<dynamic> _subscriptionHistory = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSubscriptionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text('الاشتراكات'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  // Load subscription data from API
  Future<void> _loadSubscriptionData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = di.sl<ApiClient>();

      // Load current subscription, available plans, and history in parallel
      final futures = await Future.wait([
        apiClient.get('/subscriptions/current'),
        apiClient.get('/subscriptions/plans'),
        apiClient.get('/subscriptions/history'),
      ]);

      setState(() {
        _currentSubscription =
            futures[0].data['success'] == true ? futures[0].data['data'] : null;
        _availablePlans = futures[1].data['success'] == true
            ? (futures[1].data['data'] ?? [])
            : [];
        _subscriptionHistory = futures[2].data['success'] == true
            ? (futures[2].data['data'] ?? [])
            : [];
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildBody() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.refresh, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'خطأ في تحميل بيانات الاشتراك',
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
              onPressed: _loadSubscriptionData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current subscription
          if (_currentSubscription != null) ...[
            _buildCurrentSubscriptionCard(),
            SizedBox(height: 24.h),
          ],

          // Available plans
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 400),
            child: Text(
              'الباقات المتاحة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Plans list
          ..._buildPlanCards(),

          // Subscription history
          if (_subscriptionHistory.isNotEmpty) ...[
            SizedBox(height: 32.h),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 400),
              child: Text(
                'سجل الاشتراكات',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _buildSubscriptionHistory(),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard() {
    final subscription = _currentSubscription!;
    final planName = subscription['plan_name'] ?? 'غير محدد';
    final status = subscription['status'] ?? 'active';
    final expiryDate = subscription['expires_at'];
    final isActive = status == 'active';

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: isActive ? AppColors.sidebarGradient : null,
            color: isActive ? null : Colors.grey.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الباقة الحالية',
                    style: TextStyle(
                      color: isActive ? Colors.white70 : Colors.grey.shade600,
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.success : Colors.orange,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      isActive ? 'نشط' : _getStatusText(status),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                planName,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              if (expiryDate != null)
                Text(
                  'ينتهي في: ${_formatDate(expiryDate)}',
                  style: TextStyle(
                    color: isActive
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.shade600,
                    fontFamily: 'Cairo',
                    fontSize: 14.sp,
                  ),
                ),
              SizedBox(height: 16.h),
              if (subscription['features'] != null) ...[
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: (subscription['features'] as List)
                      .map((feature) => _buildFeatureChip(feature, isActive))
                      .toList(),
                ),
              ],
              if (!isActive) ...[
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showRenewDialog(),
                    child: const Text('تجديد الاشتراك'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String text, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade700,
          fontSize: 11.sp,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  List<Widget> _buildPlanCards() {
    return _availablePlans.asMap().entries.map((entry) {
      final index = entry.key;
      final plan = entry.value;
      final isRecommended = plan['is_recommended'] == true;
      final isCurrentPlan = _currentSubscription != null &&
          _currentSubscription!['plan_id'] == plan['id'];

      return FadeInUp(
        delay: Duration(milliseconds: 300 + (index * 100)),
        duration: const Duration(milliseconds: 400),
        child: Card(
          margin: EdgeInsets.only(bottom: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: isRecommended
                ? const BorderSide(color: AppColors.success, width: 2)
                : BorderSide.none,
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan['name'] ?? 'باقة غير محددة',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    if (isRecommended)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'موصى به',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${plan['price'] ?? '0'} ر.س',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: _getPlanColor(plan['name']),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(
                        '/ ${plan['billing_cycle'] ?? 'شهرياً'}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const Divider(),
                SizedBox(height: 12.h),
                if (plan['features'] != null) ...[
                  ...(plan['features'] as List).map(
                    (feature) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.tick_circle,
                            size: 18.sp,
                            color: _getPlanColor(plan['name']),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: isCurrentPlan
                      ? OutlinedButton(
                          onPressed: null,
                          child: const Text('الباقة الحالية'),
                        )
                      : isRecommended
                          ? ElevatedButton(
                              onPressed: () => _subscribeToPlan(plan),
                              child: const Text('اشترك الآن'),
                            )
                          : OutlinedButton(
                              onPressed: () => _subscribeToPlan(plan),
                              child: const Text('اختر الباقة'),
                            ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSubscriptionHistory() {
    return Column(
      children: _subscriptionHistory.asMap().entries.map((entry) {
        final index = entry.key;
        final subscription = entry.value;

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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(
                  Iconsax.receipt_1,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                subscription['plan_name'] ?? 'باقة غير محددة',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    'من ${_formatDate(subscription['start_date'])} إلى ${_formatDate(subscription['end_date'])}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${subscription['amount'] ?? '0'} ر.س',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:
                      _getStatusColor(subscription['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _getStatusText(subscription['status']),
                  style: TextStyle(
                    color: _getStatusColor(subscription['status']),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getPlanColor(String? planName) {
    switch (planName?.toLowerCase()) {
      case 'مجانية':
      case 'free':
        return AppColors.info;
      case 'أساسية':
      case 'basic':
        return AppColors.warning;
      case 'احترافية':
      case 'professional':
      case 'pro':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'expired':
        return AppColors.error;
      case 'cancelled':
        return AppColors.warning;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'active':
        return 'نشط';
      case 'expired':
        return 'منتهي';
      case 'cancelled':
        return 'ملغي';
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

  void _subscribeToPlan(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الاشتراك'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل تريد الاشتراك في "${plan['name']}"؟'),
            SizedBox(height: 8.h),
            Text(
              'السعر: ${plan['price']} ر.س / ${plan['billing_cycle']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processSubscription(plan['id']);
            },
            child: const Text('تأكيد الاشتراك'),
          ),
        ],
      ),
    );
  }

  void _showRenewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تجديد الاشتراك'),
        content: const Text('هل تريد تجديد اشتراكك الحالي؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _renewCurrentSubscription();
            },
            child: const Text('تجديد'),
          ),
        ],
      ),
    );
  }

  Future<void> _processSubscription(int planId) async {
    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post('/subscriptions/subscribe', data: {
        'plan_id': planId,
      });

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم الاشتراك بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadSubscriptionData();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في الاشتراك');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الاشتراك: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _renewCurrentSubscription() async {
    setState(() => _isLoading = true);

    try {
      final apiClient = di.sl<ApiClient>();
      final response = await apiClient.post('/subscriptions/renew');

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تجديد الاشتراك بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadSubscriptionData();
      } else {
        throw Exception(response.data['message'] ?? 'فشل في تجديد الاشتراك');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تجديد الاشتراك: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
