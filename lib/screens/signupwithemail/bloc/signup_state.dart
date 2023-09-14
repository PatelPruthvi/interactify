part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

abstract class SignupActionState extends SignupState {}

class SignupInitial extends SignupState {}

class SignUpLoadingState extends SignupState {}

class SignUpLoadedSuccesState extends SignupState {}

class SignUpNavigateOnSignUpClickedActionState extends SignupActionState {}

class SignUpEnterUserDetailsActionState extends SignupActionState {
  final FirebaseAuth auth;

  SignUpEnterUserDetailsActionState(this.auth);
}

class SignUpErrorMsgActionState extends SignupActionState {
  final String errorMsg;

  SignUpErrorMsgActionState(this.errorMsg);
}
