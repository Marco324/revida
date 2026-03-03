import 'package:formz/formz.dart';

enum FullNameError {empty, longer}

class FullName extends FormzInput<String, FullNameError> {
  // Call super.pure to represent an unmodified form input.
  const FullName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const FullName.dirty( super.value ) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == FullNameError.empty) return 'El campo requiere al menos una letra';
    if (displayError == FullNameError.longer) return 'El campo debe ser igual o menor a 50 caracteres';


    return null;
    
  }


  @override
  FullNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return FullNameError.empty;
    if (value.length > 50) return FullNameError.longer;

    return null;
  }
  
}