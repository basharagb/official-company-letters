part of 'letters_bloc.dart';

/// حالات الخطابات
abstract class LettersState extends Equatable {
  const LettersState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class LettersInitial extends LettersState {}

/// جاري التحميل
class LettersLoading extends LettersState {}

/// تم التحميل
class LettersLoaded extends LettersState {
  final List<Letter> letters;

  const LettersLoaded({required this.letters});

  @override
  List<Object?> get props => [letters];
}

/// خطأ
class LettersError extends LettersState {
  final String message;

  const LettersError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// جاري إنشاء خطاب
class LetterCreating extends LettersState {}

/// تم إنشاء الخطاب
class LetterCreated extends LettersState {
  final Letter letter;

  const LetterCreated({required this.letter});

  @override
  List<Object?> get props => [letter];
}

/// خطأ في إنشاء الخطاب
class LetterCreateError extends LettersState {
  final String message;

  const LetterCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}
