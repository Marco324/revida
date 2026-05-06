part of 'image_db_revida_cubit.dart';

abstract class ImageDbRevidaState extends Equatable {
  const ImageDbRevidaState();

  @override
  List<Object?> get props => [];
}

class ImageDbRevidaInitial extends ImageDbRevidaState {}

class ImageDbRevidaLoading extends ImageDbRevidaState {}

class ImageDbRevidaSuccess extends ImageDbRevidaState {}

class ImageDbRevidaError extends ImageDbRevidaState {
  final String message;

  const ImageDbRevidaError(this.message);

  @override
  List<Object?> get props => [message];
}

// Para listar reciclajes

class ImageDbRevidaLoaded extends ImageDbRevidaState {
  final List<Reciclaje> reciclajes;
  final int racha;

  const ImageDbRevidaLoaded(this.reciclajes, this.racha);

  @override
  List<Object?> get props => [reciclajes, racha];
}
