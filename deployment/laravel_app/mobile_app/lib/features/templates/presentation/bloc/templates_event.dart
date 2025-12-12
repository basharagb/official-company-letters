part of 'templates_bloc.dart';

abstract class TemplatesEvent extends Equatable {
  const TemplatesEvent();
  @override
  List<Object?> get props => [];
}

class LoadTemplatesEvent extends TemplatesEvent {}

class CreateTemplateEvent extends TemplatesEvent {
  final Map<String, dynamic> data;
  const CreateTemplateEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeleteTemplateEvent extends TemplatesEvent {
  final int id;
  const DeleteTemplateEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class ToggleTemplateEvent extends TemplatesEvent {
  final int id;
  const ToggleTemplateEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
