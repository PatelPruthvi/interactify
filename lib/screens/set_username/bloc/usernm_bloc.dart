// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../models/users_model.dart';

part 'usernm_event.dart';
part 'usernm_state.dart';

class UsernmBloc extends Bloc<UsernmEvent, UsernmState> {
  final userReference = FirebaseFirestore.instance.collection("users");
  final timeStamp = DateTime.now();
  UsernmBloc() : super(UsernmInitial()) {
    on<UsernmProceedButtonClickedEvent>(usernmProceedButtonClickedEvent);
  }
  FutureOr<void> usernmProceedButtonClickedEvent(
      UsernmProceedButtonClickedEvent event, Emitter<UsernmState> emit) async {
    if (event.usernm.length < 5) {
      emit(UsernmErrorMsgState("Username must be atleast 5 letters"));
    } else if (event.usernm.contains("@") ||
        event.usernm.contains("#") ||
        event.usernm.contains("other")) {
      emit(UsernmErrorMsgState(
          "Username can only contain alphabets, numbers and underscore.."));
    } else {
      emit(UsernmLoadingState());

      await userReference.doc(event.auth.currentUser!.uid).get();
      userReference.doc(event.auth.currentUser!.uid).set(Users(
              uid: event.auth.currentUser!.uid,
              profileName: event.auth.currentUser!.displayName,
              userName: event.usernm.toLowerCase(),
              email: event.auth.currentUser!.email,
              imgUrl: event.auth.currentUser!.photoURL,
              bio: "",
              timestamp: timeStamp,
              followers: [],
              following: []).toMap()
          //   {
          //   "uid": event.auth.currentUser!.uid,
          //   "profileName": event.auth.currentUser!.displayName,
          //   "userName": event.usernm.toLowerCase(),
          //   "email": event.auth.currentUser!.email,
          //   "imgUrl": event.auth.currentUser!.photoURL,
          //   "bio": "",
          //   "timestamp": timeStamp,
          //   "followers": [],
          //   "following": []
          // }
          );

      emit(UsernmNavigateToLoggedInPageActionState(event.auth));
    }
  }
}
