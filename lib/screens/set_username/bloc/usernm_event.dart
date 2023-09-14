part of 'usernm_bloc.dart';

@immutable
abstract class UsernmEvent {}

class UsernmProceedButtonClickedEvent extends UsernmEvent {
  final String usernm;
  final FirebaseAuth auth;

  UsernmProceedButtonClickedEvent(this.auth, this.usernm);
}
