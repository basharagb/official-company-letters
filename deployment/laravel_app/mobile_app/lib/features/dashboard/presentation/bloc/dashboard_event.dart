part of 'dashboard_bloc.dart';

/// أحداث لوحة التحكم
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل لوحة التحكم
class LoadDashboardEvent extends DashboardEvent {}

/// تحديث لوحة التحكم
class RefreshDashboardEvent extends DashboardEvent {}
