import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';

/// صفحة الجهات/المنظمات
class OrganizationsPage extends StatelessWidget {
  const OrganizationsPage({super.key});

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
            onPressed: () {
              // TODO: Add organization
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return FadeInUp(
            delay: Duration(milliseconds: 50 * index),
            duration: const Duration(milliseconds: 400),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Iconsax.building, color: AppColors.info),
                ),
                title: Text(
                  'جهة رقم ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                subtitle: Text(
                  '${(index + 1) * 5} خطابات',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {},
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }
}
