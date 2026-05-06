import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:revida/features/shared/infrastructure/inputs/inputs.dart';

part 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  final Future<void> Function(String, String) loginUserCallback;
  final Future<String> Function(String)? forgetSubmitCallback;

  LoginFormCubit({required this.loginUserCallback, this.forgetSubmitCallback,})
    : super(const LoginFormState());

  void onEmailChange(String value) {
    final newEmail = Email.dirty(value);

    emit(
      state.copyWith(
        email: newEmail,
        isValid: Formz.validate([newEmail, state.password]),
      ),
    );
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value);

    emit(
      state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]),
      ),
    );
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    emit(state.copyWith(isPosting: true));

    try {
      await loginUserCallback(state.email.value, state.password.value);
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isPosting: false));
      }
      return;
    }

    if (!isClosed) {
      emit(state.copyWith(isPosting: false));
    }
  }

  void onForgetPassword(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(emailForgetPassword: email, isValid: Formz.validate([email])));
  }

  Future<String> forgetPasswordSubmit(String email) async {
    if (!state.isValid) return '';

    return await forgetSubmitCallback!(email);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    emit(
      state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]),
      ),
    );
  }
}
