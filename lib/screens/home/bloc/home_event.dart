part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeLogInButtonClickedEvent extends HomeEvent {
  final String emailValue;
  final String passwordValue;

  HomeLogInButtonClickedEvent(this.emailValue, this.passwordValue);
}

class HomeForgotPasswordButtonClickedEvent extends HomeEvent {
  final String emailValue;

  HomeForgotPasswordButtonClickedEvent(this.emailValue);
}

class HomeSignInWithGoogleButtonClickedEvent extends HomeEvent {}

class HomeCreateAccountButtonClickedEvent extends HomeEvent {}

class HomeBackClickedFromUserEvent extends HomeEvent {}
