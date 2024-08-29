part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged(this.user);
}

final class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});


}

final class SignUpUserEvent extends AuthEvent {
  final String? userName;
  final String email;
  final String password;

  SignUpUserEvent({this.userName, required this.email, required this.password});


}

final class SignOutEvent extends AuthEvent {}

final class GetCurrentUserEvent extends AuthEvent {}