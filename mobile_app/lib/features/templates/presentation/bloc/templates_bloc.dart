import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/templates_repository.dart';

part 'templates_event.dart';
part 'templates_state.dart';

class TemplatesBloc extends Bloc<TemplatesEvent, TemplatesState> {
  final TemplatesRepository _repository;

  TemplatesBloc(this._repository) : super(TemplatesInitial()) {
    on<LoadTemplatesEvent>(_onLoadTemplates);
    on<CreateTemplateEvent>(_onCreateTemplate);
    on<DeleteTemplateEvent>(_onDeleteTemplate);
    on<ToggleTemplateEvent>(_onToggleTemplate);
  }

  Future<void> _onLoadTemplates(
    LoadTemplatesEvent event,
    Emitter<TemplatesState> emit,
  ) async {
    emit(TemplatesLoading());
    final result = await _repository.getTemplates();
    result.fold(
      (failure) => emit(TemplatesError(message: failure.message)),
      (templates) => emit(TemplatesLoaded(templates: templates)),
    );
  }

  Future<void> _onCreateTemplate(
    CreateTemplateEvent event,
    Emitter<TemplatesState> emit,
  ) async {
    emit(TemplatesLoading());
    final result = await _repository.createTemplate(event.data);
    result.fold(
      (failure) => emit(TemplatesError(message: failure.message)),
      (template) => emit(TemplateCreated(template: template)),
    );
  }

  Future<void> _onDeleteTemplate(
    DeleteTemplateEvent event,
    Emitter<TemplatesState> emit,
  ) async {
    final result = await _repository.deleteTemplate(event.id);
    result.fold(
      (failure) => emit(TemplatesError(message: failure.message)),
      (_) => add(LoadTemplatesEvent()),
    );
  }

  Future<void> _onToggleTemplate(
    ToggleTemplateEvent event,
    Emitter<TemplatesState> emit,
  ) async {
    final result = await _repository.toggleActive(event.id);
    result.fold(
      (failure) => emit(TemplatesError(message: failure.message)),
      (_) => add(LoadTemplatesEvent()),
    );
  }
}
