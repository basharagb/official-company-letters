import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

/// الصفحة الرئيسية مع Bottom Navigation
class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(
      icon: Iconsax.document_copy,
      activeIcon: Iconsax.document_copy5,
      label: 'القوالب',
      route: AppRoutes.templates,
    ),
    _NavItem(
      icon: Iconsax.document,
      activeIcon: Iconsax.document5,
      label: 'الخطابات',
      route: AppRoutes.letters,
    ),
    _NavItem(
      icon: Iconsax.add_circle,
      activeIcon: Iconsax.add_circle5,
      label: 'جديد',
      route: AppRoutes.letterCreate,
    ),
    _NavItem(
      icon: Iconsax.home,
      activeIcon: Iconsax.home_15,
      label: 'الرئيسية',
      route: AppRoutes.main,
    ),
    _NavItem(
      icon: Iconsax.menu_1,
      activeIcon: Iconsax.menu_15,
      label: 'المزيد',
      route: '', // سيفتح Drawer
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      // فتح القائمة الجانبية
      _scaffoldKey.currentState?.openEndDrawer();
      return;
    }

    if (index == 2) {
      // صفحة إنشاء خطاب جديد - Full Screen (FAB في المنتصف)
      context.push(AppRoutes.letterCreate);
      return;
    }

    setState(() => _currentIndex = index);
    context.go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: widget.child,
      endDrawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              if (index == 2) {
                // مكان FAB - إنشاء خطاب (في المنتصف)
                return const SizedBox(width: 56);
              }
              return _buildNavItem(index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return ZoomIn(
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton(
        heroTag: 'main_page_fab',
        onPressed: () => context.push(AppRoutes.letterCreate),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Iconsax.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.sidebarGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المستخدم',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            'مستخدم النظام',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white24),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildDrawerItem(
                      icon: Iconsax.document,
                      label: 'القوالب',
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.templates);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Iconsax.card,
                      label: 'الاشتراكات',
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.subscriptions);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Iconsax.people,
                      label: 'المستلمين',
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.recipients);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Iconsax.building,
                      label: 'الجهات',
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.organizations);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Iconsax.user_tag,
                      label: 'صفات المستلمين',
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.recipientTitles);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Iconsax.note_text,
                      label: 'مواضيع الخطابات',
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.letterSubjects);
                      },
                    ),
                  ],
                ),
              ),

              // Logout
              Padding(
                padding: const EdgeInsets.all(16),
                child: ListTile(
                  leading: const Icon(Iconsax.logout, color: Colors.red),
                  title: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(color: Colors.red, fontFamily: 'Cairo'),
                  ),
                  onTap: () {
                    // TODO: Implement logout
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
