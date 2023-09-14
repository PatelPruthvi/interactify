import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/screens/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSignOutButtonPressedEvent>(loginSignOutButtonPressedEvent);
    on<LoginBarButtonPressedEvent>(loginBarButtonPressedEvent);
  }

  FutureOr<void> loginSignOutButtonPressedEvent(
      LoginSignOutButtonPressedEvent event, Emitter<LoginState> emit) async {
    await HomeBloc().logOut();

    emit(LoginRedirectToHomePageActionState());
  }

  FutureOr<void> loginBarButtonPressedEvent(
      LoginBarButtonPressedEvent event, Emitter<LoginState> emit) {
    emit(LoginIndexIPressedState(event._selectedIndex));
  }
}
