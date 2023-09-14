part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {}

class HomeNavigateToLoginScreenActionState extends HomeActionState {
  final FirebaseAuth auth;

  HomeNavigateToLoginScreenActionState(this.auth);
}

class HomeForgotPasswordSuccessFulActionState extends HomeActionState {}

class HomeErrorMsgActionState extends HomeActionState {
  final String errorMsg;

  HomeErrorMsgActionState(this.errorMsg);
}

class HomeNavigateToUserDetailsSetActionState extends HomeActionState {
  final FirebaseAuth auth;

  HomeNavigateToUserDetailsSetActionState(this.auth);
}

class HomeNavigateToSignUpScreenActionState extends HomeActionState {}
