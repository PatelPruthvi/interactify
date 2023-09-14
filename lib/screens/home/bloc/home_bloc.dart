import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection("users");

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeLogInButtonClickedEvent>(homeLogInButtonClickedEvent);
    on<HomeForgotPasswordButtonClickedEvent>(
        homeForgotPasswordButtonClickedEvent);
    on<HomeSignInWithGoogleButtonClickedEvent>(
        homeSignInWithGoogleButtonClickedEvent);
    on<HomeCreateAccountButtonClickedEvent>(
        homeCreateAccountButtonClickedEvent);
    on<HomeBackClickedFromUserEvent>(homeBackClickedFromUserEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    if (_auth.currentUser != null) {
      emit(HomeNavigateToLoginScreenActionState(_auth));
    } else {
      emit(HomeLoadedSuccessState());
    }
  }

  FutureOr<void> homeLogInButtonClickedEvent(
      HomeLogInButtonClickedEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      await _auth.signInWithEmailAndPassword(
          email: event.emailValue, password: event.passwordValue);
      emit(HomeNavigateToLoginScreenActionState(_auth));
    } on FirebaseAuthException catch (e) {
      emit(HomeErrorMsgActionState(e.message.toString()));
    }
  }

  FutureOr<void> homeForgotPasswordButtonClickedEvent(
      HomeForgotPasswordButtonClickedEvent event,
      Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      await _auth.sendPasswordResetEmail(email: event.emailValue);
      emit(HomeForgotPasswordSuccessFulActionState());
    } on FirebaseAuthException catch (e) {
      emit(HomeErrorMsgActionState(e.message.toString()));
    }
  }

  Future<FutureOr<void>> homeSignInWithGoogleButtonClickedEvent(
      HomeSignInWithGoogleButtonClickedEvent event,
      Emitter<HomeState> emit) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      emit(HomeLoadingState());
      UserCredential cred = await _auth.signInWithCredential(credential);
      if (cred.additionalUserInfo!.isNewUser) {
        emit(HomeNavigateToUserDetailsSetActionState(_auth));
      } else {
        emit(HomeNavigateToLoginScreenActionState(_auth));
      }
    } on FirebaseAuthException catch (e) {
      emit(HomeErrorMsgActionState(e.message.toString()));
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  FutureOr<void> homeCreateAccountButtonClickedEvent(
      HomeCreateAccountButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToSignUpScreenActionState());
  }

  FutureOr<void> homeBackClickedFromUserEvent(
      HomeBackClickedFromUserEvent event, Emitter<HomeState> emit) async {
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();
    if (!docSnap.exists) {
      await _auth.currentUser!.delete();
    }
    emit(HomeLoadedSuccessState());
  }

  Future getUserName() async {
    DocumentSnapshot documentSnapshot =
        await userRef.doc(_auth.currentUser!.uid).get();

    return documentSnapshot["userName"];
  }

  Future getUserTimeStamp() async {
    DocumentSnapshot documentSnapshot =
        await userRef.doc(_auth.currentUser!.uid).get();

    return documentSnapshot["timestamp"];
  }
}
