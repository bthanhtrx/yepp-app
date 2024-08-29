part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final YeppUser user;

  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {

}


class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}