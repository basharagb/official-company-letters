part of 'letters_bloc.dart';

/// أحداث الخطابات
abstract class LettersEvent extends Equatable {
  const LettersEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل الخطابات
class LoadLettersEvent extends LettersEvent {}

/// تحديث الخطابات
class RefreshLettersEvent extends LettersEvent {}

/// البحث في الخطابات
class SearchLettersEvent extends LettersEvent {
  final String query;

  const SearchLettersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// فلترة الخطابات
class FilterLettersEvent extends LettersEvent {
  final String? status;

  const FilterLettersEvent({this.status});

  @override
  List<Object?> get props => [status];
}

/// إنشاء خطاب
class CreateLetterEvent extends LettersEvent {
  final Map<String, dynamic> data;

  const CreateLetterEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
