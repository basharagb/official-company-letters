import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_activity.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';

class UserDetailsPage extends StatefulWidget {
  final int userId;
  final bool showActivityLog;

  const UserDetailsPage({
    super.key,
    required this.userId,
    this.showActivityLog = false,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.showActivityLog ? 1 : 0,
    );
    _loadData();
  }

  void _loadData() {
    context.read<UsersBloc>().add(LoadUserDetailsEvent(widget.userId));
    context.read<UsersBloc>().add(LoadUserActivityLogEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المستخدم'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'المعلومات الأساسية'),
            Tab(text: 'سجل النشاطات'),
          ],
        ),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildUserInfo(state),
              _buildActivityLog(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(UsersState state) {
    if (state is! UserDetailsLoaded) {
      return const Center(child: Text('لا توجد بيانات'));
    }

    final user = state.user;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    alignment: WrapAlignment.center,
                    children: [
                      if (user.isSuperAdmin)
                        _buildBadge('Super Admin', Colors.red),
                      if (user.isCompanyOwner)
                        _buildBadge('مالك الشركة', Colors.orange),
                      _buildBadge(user.roleLabel, Colors.purple),
                      _buildBadge(
                          user.statusLabel, _getStatusColor(user.status)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: _buildInfoCard('المعلومات الشخصية', [
              _buildInfoRow(Icons.person, 'الاسم', user.name),
              _buildInfoRow(Icons.email, 'البريد الإلكتروني', user.email),
              if (user.phone != null)
                _buildInfoRow(Icons.phone, 'رقم الهاتف', user.phone!),
              if (user.jobTitle != null)
                _buildInfoRow(Icons.work, 'المسمى الوظيفي', user.jobTitle!),
            ]),
          ),
          SizedBox(height: 16.h),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _buildInfoCard('معلومات الشركة', [
              _buildInfoRow(
                Icons.business,
                'الشركة',
                user.companyName ?? 'غير محدد',
              ),
            ]),
          ),
          SizedBox(height: 16.h),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: _buildInfoCard('معلومات الحساب', [
              _buildInfoRow(Icons.badge, 'الدور', user.roleLabel),
              _buildInfoRow(Icons.check_circle, 'الحالة', user.statusLabel),
              _buildInfoRow(
                Icons.calendar_today,
                'تاريخ التسجيل',
                user.createdAt.split(' ')[0],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLog(UsersState state) {
    if (state is! UserActivityLogLoaded) {
      return const Center(child: Text('لا توجد نشاطات'));
    }

    final activities = state.activities;

    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'لا توجد نشاطات',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: index * 50),
          child: _buildActivityCard(activities[index]),
        );
      },
    );
  }

  Widget _buildActivityCard(UserActivity activity) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.description,
                    color: Theme.of(context).primaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.action,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        activity.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (activity.referenceNumber != null) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.numbers, size: 14.sp, color: Colors.blue),
                    SizedBox(width: 4.w),
                    Text(
                      'رقم الصادر: ${activity.referenceNumber}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.access_time, size: 14.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  activity.createdAt,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
                if (activity.company != null) ...[
                  SizedBox(width: 12.w),
                  Icon(Icons.business, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      activity.company!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
