part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class LoginRedirectToHomePageActionState extends LoginActionState {}

class LoginIndexIPressedState extends LoginState {
  final int index;

  LoginIndexIPressedState(this.index);
}
