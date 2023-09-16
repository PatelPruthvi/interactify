// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SignupBloc() : super(SignupInitial()) {
    on<SignUpInitialEvent>(signUpInitialEvent);
    on<SignupButtonClickedEvent>(signupButtonClickedEvent);
    on<SignupBackClickedFromUsernmSetEvent>(
        signupBackClickedFromUsernmSetEvent);
  }
  FutureOr<void> signUpInitialEvent(
      SignUpInitialEvent event, Emitter<SignupState> emit) {
    emit(SignUpLoadedSuccesState());
  }

  FutureOr<void> signupButtonClickedEvent(
      SignupButtonClickedEvent event, Emitter<SignupState> emit) async {
    emit(SignUpLoadingState());

    if (event.displayName.startsWith(" ") || event.displayName.endsWith(" ")) {
      emit(SignUpErrorMsgActionState(
          "First Name and Last Name can not be empty"));
    } else if (event.displayName.contains("@") ||
        event.displayName.contains("#") ||
        event.displayName.contains("_")) {
      emit(SignUpErrorMsgActionState(
          "name should not contain any special character"));
    } else {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: event.emailValue, password: event.passValue);
        await _auth.currentUser!.updateDisplayName(event.displayName);
        await _auth.currentUser!.updatePhotoURL(
            "https://www.pngkit.com/png/detail/126-1262807_instagram-default-profile-picture-png.png");

        emit(SignUpEnterUserDetailsActionState(_auth));
      } on FirebaseAuthException catch (e) {
        emit(SignUpErrorMsgActionState(e.message.toString()));
      }
    }
  }

  FutureOr<void> signupBackClickedFromUsernmSetEvent(
      SignupBackClickedFromUsernmSetEvent event,
      Emitter<SignupState> emit) async {
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();
    if (!docSnap.exists) {
      _auth.currentUser!.delete();
    }

    emit(SignUpLoadedSuccesState());
  }
}
