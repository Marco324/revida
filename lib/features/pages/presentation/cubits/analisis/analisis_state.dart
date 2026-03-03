abstract class AnalisisState {}

class AnalisisInitial extends AnalisisState {}

class AnalisisLoading extends AnalisisState {}

class AnalisisSuccess extends AnalisisState {
  final String objetoDetectado;
  final double confianza;
  final String categoriaResiduo;

  AnalisisSuccess({
    required this.objetoDetectado,
    required this.confianza,
    required this.categoriaResiduo,
  });
}

class AnalisisError extends AnalisisState {
  final String mensaje;
  
  AnalisisError(this.mensaje);
}