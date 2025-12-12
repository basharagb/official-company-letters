import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Dashboard
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Letters
import '../../features/letters/data/datasources/letters_remote_datasource.dart';
import '../../features/letters/data/repositories/letters_repository_impl.dart';
import '../../features/letters/domain/repositories/letters_repository.dart';
import '../../features/letters/domain/usecases/get_letters_usecase.dart';
import '../../features/letters/domain/usecases/create_letter_usecase.dart';
import '../../features/letters/presentation/bloc/letters_bloc.dart';

// Company
import '../../features/company/data/datasources/company_remote_datasource.dart';
import '../../features/company/data/repositories/company_repository_impl.dart';
import '../../features/company/domain/repositories/company_repository.dart';
import '../../features/company/presentation/bloc/company_bloc.dart';

// Templates
import '../../features/templates/data/datasources/templates_remote_datasource.dart';
import '../../features/templates/data/repositories/templates_repository_impl.dart';
import '../../features/templates/domain/repositories/templates_repository.dart';
import '../../features/templates/presentation/bloc/templates_bloc.dart';

// Recipients
import '../../features/recipients/data/datasources/recipients_remote_datasource.dart';
import '../../features/recipients/data/repositories/recipients_repository_impl.dart';
import '../../features/recipients/domain/repositories/recipients_repository.dart';
import '../../features/recipients/presentation/bloc/recipients_bloc.dart';

// Organizations
import '../../features/organizations/data/datasources/organizations_remote_datasource.dart';
import '../../features/organizations/data/repositories/organizations_repository_impl.dart';
import '../../features/organizations/domain/repositories/organizations_repository.dart';
import '../../features/organizations/presentation/bloc/organizations_bloc.dart';

// Subscriptions
import '../../features/subscriptions/data/datasources/subscriptions_remote_datasource.dart';
import '../../features/subscriptions/data/repositories/subscriptions_repository_impl.dart';
import '../../features/subscriptions/domain/repositories/subscriptions_repository.dart';
import '../../features/subscriptions/presentation/bloc/subscriptions_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);

  //! Core
  sl.registerLazySingleton(
    () => Dio()
      ..options = BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      )
      ..interceptors.add(AuthInterceptor(sl()))
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true)),
  );

  sl.registerLazySingleton(() => ApiClient(sl()));

  //! Features - Auth
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetUserUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getUserUseCase: sl(),
      secureStorage: sl(),
    ),
  );

  //! Features - Dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));
  sl.registerFactory(() => DashboardBloc(sl()));

  //! Features - Letters
  sl.registerLazySingleton<LettersRemoteDataSource>(
    () => LettersRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LettersRepository>(
    () => LettersRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetLettersUseCase(sl()));
  sl.registerLazySingleton(() => CreateLetterUseCase(sl()));
  sl.registerFactory(
    () => LettersBloc(getLettersUseCase: sl(), createLetterUseCase: sl()),
  );

  //! Features - Company
  sl.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(sl()),
  );
  sl.registerFactory(() => CompanyBloc(sl()));

  //! Features - Templates
  sl.registerLazySingleton<TemplatesRemoteDataSource>(
    () => TemplatesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TemplatesRepository>(
    () => TemplatesRepositoryImpl(sl()),
  );
  sl.registerFactory(() => TemplatesBloc(sl()));

  //! Features - Recipients
  sl.registerLazySingleton<RecipientsRemoteDataSource>(
    () => RecipientsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RecipientsRepository>(
    () => RecipientsRepositoryImpl(sl()),
  );
  sl.registerFactory(() => RecipientsBloc(sl()));

  //! Features - Organizations
  sl.registerLazySingleton<OrganizationsRemoteDataSource>(
    () => OrganizationsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OrganizationsRepository>(
    () => OrganizationsRepositoryImpl(sl()),
  );
  sl.registerFactory(() => OrganizationsBloc(sl()));

  //! Features - Subscriptions
  sl.registerLazySingleton<SubscriptionsRemoteDataSource>(
    () => SubscriptionsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SubscriptionsRepository>(
    () => SubscriptionsRepositoryImpl(sl()),
  );
  sl.registerFactory(() => SubscriptionsBloc(sl()));
}
