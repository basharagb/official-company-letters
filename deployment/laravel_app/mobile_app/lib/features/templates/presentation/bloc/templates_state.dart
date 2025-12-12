part of 'templates_bloc.dart';

abstract class TemplatesState extends Equatable {
  const TemplatesState();
  @override
  List<Object?> get props => [];
}

class TemplatesInitial extends TemplatesState {}

class TemplatesLoading extends TemplatesState {}

class TemplatesLoaded extends TemplatesState {
  final List<Map<String, dynamic>> templates;
  const TemplatesLoaded({required this.templates});
  @override
  List<Object?> get props => [templates];
}

class TemplateCreated extends TemplatesState {
  final Map<String, dynamic> template;
  const TemplateCreated({required this.template});
  @override
  List<Object?> get props => [template];
}

class TemplatesError extends TemplatesState {
  final String message;
  const TemplatesError({required this.message});
  @override
  List<Object?> get props => [message];
}
