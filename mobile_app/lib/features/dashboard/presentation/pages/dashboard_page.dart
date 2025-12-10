import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_letters_list.dart';

/// صفحة لوحة التحكم - مطابقة لتصميم الويب
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // جلب بيانات لوحة التحكم
    context.read<DashboardBloc>().add(LoadDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(LoadDashboardEvent());
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.warning_2,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DashboardBloc>().add(LoadDashboardEvent());
                      },
                      icon: const Icon(Iconsax.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is DashboardLoaded) {
              return _buildContent(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: FadeInDown(
        duration: const Duration(milliseconds: 500),
        child: const Text('لوحة التحكم'),
      ),
      actions: [
        FadeInRight(
          duration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () {
              // TODO: Notifications
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(DashboardLoaded state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              // الترحيب
              _buildWelcomeSection(state),
              const SizedBox(height: 24),

              // الإحصائيات
              _buildStatsSection(state),
              const SizedBox(height: 24),

              // الإجراءات السريعة
              _buildQuickActionsSection(),
              const SizedBox(height: 24),

              // آخر الخطابات
              _buildRecentLettersSection(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(DashboardLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً، ${state.userName}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.companyName ?? 'نظام الخطابات الرسمية',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.user, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإحصائيات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            StatCard(
              title: 'إجمالي الخطابات',
              value: '${state.totalLetters}',
              icon: Iconsax.document,
              color: AppColors.primary,
            ),
            StatCard(
              title: 'مسودات',
              value: '${state.draftLetters}',
              icon: Iconsax.edit,
              color: AppColors.warning,
            ),
            StatCard(
              title: 'صادرة',
              value: '${state.issuedLetters}',
              icon: Iconsax.tick_circle,
              color: AppColors.info,
            ),
            StatCard(
              title: 'مُرسلة',
              value: '${state.sentLetters}',
              icon: Iconsax.send_2,
              color: AppColors.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إجراءات سريعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              QuickActionCard(
                icon: Iconsax.add_circle,
                label: 'خطاب جديد',
                color: AppColors.primary,
                onTap: () => context.push(AppRoutes.letterCreate),
              ),
              const SizedBox(width: 12),
              QuickActionCard(
                icon: Iconsax.search_normal,
                label: 'بحث',
                color: AppColors.info,
                onTap: () => context.go(AppRoutes.letters),
              ),
              const SizedBox(width: 12),
              QuickActionCard(
                icon: Iconsax.document_text,
                label: 'القوالب',
                color: AppColors.secondary,
                onTap: () => context.go(AppRoutes.templates),
              ),
              const SizedBox(width: 12),
              QuickActionCard(
                icon: Iconsax.building,
                label: 'الشركة',
                color: AppColors.success,
                onTap: () => context.go(AppRoutes.companySettings),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentLettersSection(DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'آخر الخطابات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.letters),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.recentLetters.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Iconsax.document, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'لا توجد خطابات بعد',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.letterCreate),
                    icon: const Icon(Iconsax.add),
                    label: const Text('إنشاء أول خطاب'),
                  ),
                ],
              ),
            ),
          )
        else
          RecentLettersList(letters: state.recentLetters),
      ],
    );
  }
}
