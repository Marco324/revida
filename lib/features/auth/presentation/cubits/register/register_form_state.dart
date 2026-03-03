part of 'register_form_cubit.dart';

@immutable
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
    final bool isPasswordsEquals;
  final FullName name;
  final Email email;
  final Password password;
  final Password passwordReplica;

  const RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.isPasswordsEquals = true,
    this.name = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordReplica = const Password.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? isPasswordsEquals,
    FullName? name,
    Email? email,
    Password? password,
    Password? passwordReplica,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isPasswordsEquals: isPasswordsEquals ?? this.isPasswordsEquals,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordReplica: passwordReplica ?? this.passwordReplica,
    );
  }
}
