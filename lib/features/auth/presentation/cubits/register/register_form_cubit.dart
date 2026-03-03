import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:revida/features/shared/infrastructure/inputs/inputs.dart';

part 'register_form_state.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  final Future<void> Function(String, String, String) registerUserCallback;
  RegisterFormCubit({required this.registerUserCallback})
    : super(RegisterFormState());

  void onEmailChange(String value) {
    final newEmail = Email.dirty(value);

    emit(
      state.copyWith(
        email: newEmail,
        isValid: Formz.validate([
          newEmail,
          state.password,
          state.name,
          state.passwordReplica,
        ]),
      ),
    );
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value);

    emit(
      state.copyWith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
          state.name,
          state.passwordReplica,
        ]),
      ),
    );
  }

  void onPasswordReplicaChange(String value) {
    final newPassword = Password.dirty(value);

    emit(
      state.copyWith(
        passwordReplica: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
          state.name,
          state.password,
        ]),
      ),
    );
  }

  void onFullNameChange(String value) {
    final newFullName = FullName.dirty(value);
    emit(
      state.copyWith(
        name: newFullName,
        isValid: Formz.validate([
          newFullName,
          state.password,
          state.email,
          state.passwordReplica,
        ]),
      ),
    );
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();

    emit(state.copyWith(isPasswordsEquals: true));
    if (state.passwordReplica != state.password) {
      emit(state.copyWith(isPasswordsEquals: false));
      return;
    }

    if (!state.isValid) return;

    emit(state.copyWith(isPosting: true));

    await registerUserCallback(
      state.name.value,
      state.email.value,
      state.password.value,
    );

    emit(state.copyWith(isPosting: false));
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final name = FullName.dirty(state.name.value);
    final password = Password.dirty(state.password.value);
    final passwordReplica = Password.dirty(state.passwordReplica.value);

    emit(
      state.copyWith(
        isFormPosted: true,
        name: name,
        email: email,
        password: password,
        passwordReplica: passwordReplica,
        isValid: Formz.validate([name, email, password, passwordReplica]),
      ),
    );
  }
}
