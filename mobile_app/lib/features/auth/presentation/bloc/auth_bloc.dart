import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC للمصادقة
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetUserUseCase getUserUseCase;
  final FlutterSecureStorage secureStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getUserUseCase,
    required this.secureStorage,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  /// التحقق من حالة المصادقة عند بدء التطبيق
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await secureStorage.read(key: AppConfig.tokenKey);

      if (token != null && token.isNotEmpty) {
        // جلب بيانات المستخدم
        final result = await getUserUseCase();
        await result.fold(
          (failure) async {
            // Token غير صالح
            await secureStorage.delete(key: AppConfig.tokenKey);
            emit(AuthUnauthenticated());
          },
          (user) async => emit(AuthAuthenticated(user: user)),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  /// تسجيل الدخول
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (authResponse) async {
        // حفظ Token
        await secureStorage.write(
          key: AppConfig.tokenKey,
          value: authResponse.token,
        );

        // التحقق من حالة إعداد المؤسسة
        final needsSetup = authResponse.user.companyName == null ||
            authResponse.user.companyName!.isEmpty;

        emit(AuthAuthenticated(
          user: authResponse.user,
          needsOrganizationSetup: needsSetup,
        ));
      },
    );
  }

  /// تسجيل الخروج
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await logoutUseCase();
    await secureStorage.delete(key: AppConfig.tokenKey);

    emit(AuthUnauthenticated());
  }
}
