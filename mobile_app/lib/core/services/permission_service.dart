import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة إدارة الصلاحيات - تطلب جميع الصلاحيات عند أول فتح للتطبيق
class PermissionService {
  static const String _permissionsRequestedKey = 'permissions_requested';

  /// التحقق مما إذا تم طلب الصلاحيات من قبل
  static Future<bool> hasRequestedPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionsRequestedKey) ?? false;
  }

  /// تعيين أن الصلاحيات تم طلبها
  static Future<void> setPermissionsRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionsRequestedKey, true);
  }

  /// طلب جميع الصلاحيات المطلوبة
  static Future<Map<Permission, PermissionStatus>>
      requestAllPermissions() async {
    List<Permission> permissions = [];

    if (Platform.isIOS) {
      permissions = [
        Permission.camera,
        Permission.photos,
        Permission.notification,
      ];
    } else if (Platform.isAndroid) {
      permissions = [
        Permission.camera,
        Permission.photos,
        Permission.storage,
        Permission.notification,
      ];
    }

    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.request();
    }

    await setPermissionsRequested();
    return statuses;
  }

  /// عرض شاشة طلب الصلاحيات
  static Future<void> showPermissionRequestDialog(BuildContext context) async {
    final hasRequested = await hasRequestedPermissions();
    if (hasRequested) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PermissionRequestDialog(),
    );
  }
}

/// شاشة طلب الصلاحيات
class PermissionRequestDialog extends StatefulWidget {
  const PermissionRequestDialog({super.key});

  @override
  State<PermissionRequestDialog> createState() =>
      _PermissionRequestDialogState();
}

class _PermissionRequestDialogState extends State<PermissionRequestDialog> {
  bool _isLoading = false;
  int _currentStep = 0;

  final List<PermissionInfo> _permissions = [
    PermissionInfo(
      permission: Permission.camera,
      icon: Icons.camera_alt_rounded,
      title: 'الكاميرا',
      description:
          'نحتاج الوصول إلى الكاميرا لمسح المستندات والورق الرسمي ضوئياً وإنشاء قوالب الخطابات بسهولة.',
      reason: 'يتيح لك التقاط صور للمستندات مباشرة من التطبيق',
    ),
    PermissionInfo(
      permission: Permission.photos,
      icon: Icons.photo_library_rounded,
      title: 'مكتبة الصور',
      description:
          'نحتاج الوصول إلى مكتبة الصور لاختيار صور الشعارات والأختام والتوقيعات لإضافتها إلى الخطابات الرسمية.',
      reason: 'يتيح لك اختيار الصور من معرض الصور الخاص بك',
    ),
    PermissionInfo(
      permission: Permission.notification,
      icon: Icons.notifications_rounded,
      title: 'الإشعارات',
      description:
          'نحتاج إرسال إشعارات لتنبيهك بحالة الخطابات والتحديثات المهمة والتذكيرات.',
      reason: 'يبقيك على اطلاع بآخر التحديثات والإشعارات المهمة',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.security_rounded,
                  size: 48,
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'صلاحيات التطبيق',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'لتقديم أفضل تجربة، يحتاج التطبيق إلى بعض الصلاحيات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 24),

              // Permission List
              ...List.generate(_permissions.length, (index) {
                final info = _permissions[index];
                final isCompleted = index < _currentStep;
                final isCurrent = index == _currentStep;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.shade50
                        : isCurrent
                            ? const Color(0xFF1E3A5F).withOpacity(0.05)
                            : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCompleted
                          ? Colors.green.shade300
                          : isCurrent
                              ? const Color(0xFF1E3A5F)
                              : Colors.grey.shade200,
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green.shade100
                              : const Color(0xFF1E3A5F).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isCompleted ? Icons.check_rounded : info.icon,
                          color: isCompleted
                              ? Colors.green
                              : const Color(0xFF1E3A5F),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: isCompleted
                                    ? Colors.green.shade700
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              info.reason,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Privacy Note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'نحترم خصوصيتك ولن نستخدم بياناتك إلا لتحسين تجربتك',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handlePermissionRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _currentStep < _permissions.length
                              ? 'السماح بالصلاحيات'
                              : 'متابعة',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              if (_currentStep == 0) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _skipPermissions(),
                  child: Text(
                    'تخطي الآن',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePermissionRequest() async {
    if (_currentStep >= _permissions.length) {
      await PermissionService.setPermissionsRequested();
      if (mounted) Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final permission = _permissions[_currentStep].permission;
      await permission.request();

      setState(() {
        _currentStep++;
        _isLoading = false;
      });

      if (_currentStep >= _permissions.length) {
        await PermissionService.setPermissionsRequested();
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _skipPermissions() async {
    await PermissionService.setPermissionsRequested();
    if (mounted) Navigator.of(context).pop();
  }
}

/// معلومات الصلاحية
class PermissionInfo {
  final Permission permission;
  final IconData icon;
  final String title;
  final String description;
  final String reason;

  PermissionInfo({
    required this.permission,
    required this.icon,
    required this.title,
    required this.description,
    required this.reason,
  });
}
