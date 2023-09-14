part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginSignOutButtonPressedEvent extends LoginEvent {}

class LoginBarButtonPressedEvent extends LoginEvent {
  final int _selectedIndex;

  LoginBarButtonPressedEvent(this._selectedIndex);
}
