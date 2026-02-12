part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

//! Initial
final class AuthInitial extends AuthState {}

//! Loading
final class AuthLoading extends AuthState {}

//! Authenticated
final class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

//! Unauthenticated
final class Unauthenticated extends AuthState {}

//! Errors
final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
