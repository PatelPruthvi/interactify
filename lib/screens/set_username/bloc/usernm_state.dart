part of 'usernm_bloc.dart';

@immutable
abstract class UsernmState {}

abstract class UsernmActionState extends UsernmState {}

class UsernmInitial extends UsernmState {}

class UsernmErrorMsgState extends UsernmState {
  final String errorMsg;

  UsernmErrorMsgState(this.errorMsg);
}

class UsernmNavigateToLoggedInPageActionState extends UsernmActionState {
  final FirebaseAuth auth;

  UsernmNavigateToLoggedInPageActionState(this.auth);
}

class UsernmLoadingState extends UsernmState {}
