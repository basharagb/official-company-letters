part of 'dashboard_bloc.dart';

/// حالات لوحة التحكم
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class DashboardInitial extends DashboardState {}

/// جاري التحميل
class DashboardLoading extends DashboardState {}

/// تم التحميل
class DashboardLoaded extends DashboardState {
  final DashboardStats stats;

  const DashboardLoaded({required this.stats});

  // Getters للوصول السهل للبيانات
  String get userName => stats.userName;
  String? get companyName => stats.companyName;
  int get totalLetters => stats.totalLetters;
  int get draftLetters => stats.draftLetters;
  int get issuedLetters => stats.issuedLetters;
  int get sentLetters => stats.sentLetters;
  List<RecentLetter> get recentLetters => stats.recentLetters;
  SubscriptionInfo? get subscription => stats.subscription;

  @override
  List<Object?> get props => [stats];
}

/// خطأ
class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
