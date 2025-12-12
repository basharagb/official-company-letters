import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/letter.dart';
import '../../domain/usecases/get_letters_usecase.dart';
import '../../domain/usecases/create_letter_usecase.dart';

part 'letters_event.dart';
part 'letters_state.dart';

/// BLoC الخطابات
class LettersBloc extends Bloc<LettersEvent, LettersState> {
  final GetLettersUseCase getLettersUseCase;
  final CreateLetterUseCase createLetterUseCase;

  LettersBloc({
    required this.getLettersUseCase,
    required this.createLetterUseCase,
  }) : super(LettersInitial()) {
    on<LoadLettersEvent>(_onLoadLetters);
    on<RefreshLettersEvent>(_onRefreshLetters);
    on<SearchLettersEvent>(_onSearchLetters);
    on<FilterLettersEvent>(_onFilterLetters);
    on<CreateLetterEvent>(_onCreateLetter);
  }

  String? _currentSearch;
  String? _currentStatus;

  Future<void> _onLoadLetters(
    LoadLettersEvent event,
    Emitter<LettersState> emit,
  ) async {
    emit(LettersLoading());

    final result = await getLettersUseCase(
      search: _currentSearch,
      status: _currentStatus,
    );

    result.fold(
      (failure) => emit(LettersError(message: failure.message)),
      (letters) => emit(LettersLoaded(letters: letters)),
    );
  }

  Future<void> _onRefreshLetters(
    RefreshLettersEvent event,
    Emitter<LettersState> emit,
  ) async {
    final result = await getLettersUseCase(
      search: _currentSearch,
      status: _currentStatus,
    );

    result.fold(
      (failure) => emit(LettersError(message: failure.message)),
      (letters) => emit(LettersLoaded(letters: letters)),
    );
  }

  Future<void> _onSearchLetters(
    SearchLettersEvent event,
    Emitter<LettersState> emit,
  ) async {
    _currentSearch = event.query;
    emit(LettersLoading());

    final result = await getLettersUseCase(
      search: _currentSearch,
      status: _currentStatus,
    );

    result.fold(
      (failure) => emit(LettersError(message: failure.message)),
      (letters) => emit(LettersLoaded(letters: letters)),
    );
  }

  Future<void> _onFilterLetters(
    FilterLettersEvent event,
    Emitter<LettersState> emit,
  ) async {
    _currentStatus = event.status;
    emit(LettersLoading());

    final result = await getLettersUseCase(
      search: _currentSearch,
      status: _currentStatus,
    );

    result.fold(
      (failure) => emit(LettersError(message: failure.message)),
      (letters) => emit(LettersLoaded(letters: letters)),
    );
  }

  Future<void> _onCreateLetter(
    CreateLetterEvent event,
    Emitter<LettersState> emit,
  ) async {
    emit(LetterCreating());

    final result = await createLetterUseCase(event.data);

    result.fold(
      (failure) => emit(LetterCreateError(message: failure.message)),
      (letter) => emit(LetterCreated(letter: letter)),
    );
  }
}
