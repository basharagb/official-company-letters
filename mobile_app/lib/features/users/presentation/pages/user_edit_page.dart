import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import '../../domain/entities/user.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';

class UserEditPage extends StatefulWidget {
  final UserEntity user;

  const UserEditPage({super.key, required this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _jobTitleController;
  late TextEditingController _passwordController;
  late String _selectedRole;
  late String _selectedStatus;
  late bool _isCompanyOwner;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _jobTitleController =
        TextEditingController(text: widget.user.jobTitle ?? '');
    _passwordController = TextEditingController();
    _selectedRole = widget.user.role;
    _selectedStatus = widget.user.status;
    _isCompanyOwner = widget.user.isCompanyOwner;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final data = <String, dynamic>{
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text.isEmpty ? null : _phoneController.text,
        'job_title':
            _jobTitleController.text.isEmpty ? null : _jobTitleController.text,
        'role': _selectedRole,
        'status': _selectedStatus,
        'is_company_owner': _isCompanyOwner,
      };

      if (_passwordController.text.isNotEmpty) {
        data['password'] = _passwordController.text;
      }

      context.read<UsersBloc>().add(UpdateUserEvent(widget.user.id, data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل المستخدم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: BlocConsumer<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UserOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is UsersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is UsersLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
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
                              widget.user.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'تعديل بيانات ${widget.user.name}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: _buildTextField(
                      controller: _nameController,
                      label: 'الاسم',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: _buildTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!value.contains('@')) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 250),
                    child: _buildTextField(
                      controller: _jobTitleController,
                      label: 'المسمى الوظيفي',
                      icon: Icons.work,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور الجديدة (اختياري)',
                      icon: Icons.lock,
                      obscureText: true,
                      helperText:
                          'اتركه فارغاً إذا كنت لا تريد تغيير كلمة المرور',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 350),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'الدور',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'user', child: Text('مستخدم')),
                        DropdownMenuItem(value: 'manager', child: Text('مدير')),
                        DropdownMenuItem(value: 'admin', child: Text('أدمن')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedRole = value);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'الحالة',
                        prefixIcon: const Icon(Icons.check_circle),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'approved', child: Text('معتمد')),
                        DropdownMenuItem(
                            value: 'pending', child: Text('قيد الانتظار')),
                        DropdownMenuItem(
                            value: 'rejected', child: Text('مرفوض')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 450),
                    child: SwitchListTile(
                      title: const Text('مالك الشركة'),
                      subtitle: const Text('تحديد المستخدم كمالك للشركة'),
                      value: _isCompanyOwner,
                      onChanged: (value) {
                        setState(() => _isCompanyOwner = value);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'حفظ التغييرات',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
