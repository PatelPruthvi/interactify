part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignUpInitialEvent extends SignupEvent {}

class SignupButtonClickedEvent extends SignupEvent {
  final String emailValue;
  final String passValue;
  final String displayName;

  SignupButtonClickedEvent(this.emailValue, this.passValue, this.displayName);
}

class SignupBackClickedFromUsernmSetEvent extends SignupEvent {}
