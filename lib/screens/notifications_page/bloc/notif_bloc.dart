import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'notif_event.dart';
part 'notif_state.dart';

class NotifBloc extends Bloc<NotifEvent, NotifState> {
  final usersRef = FirebaseFirestore.instance.collection("users");
  final userNotifsRef = FirebaseFirestore.instance.collection("userNotifs");
  NotifBloc() : super(NotifInitial()) {
    on<NotifInitialEvent>(notifInitialEvent);
  }

  FutureOr<void> notifInitialEvent(
      NotifInitialEvent event, Emitter<NotifState> emit) async {
    if (event.snapshot.connectionState == ConnectionState.waiting) {
      emit(NotifLoadingState());
    } else if (event.snapshot.data!.docs.isEmpty ||
        event.snapshot.data!.size == 0) {
      emit(NotifEmptyState());
    } else if (event.snapshot.data!.docs.isNotEmpty) {
      List<UserNotifications> userNotifs = [];
      List<String> userNames = [];
      List<String> photoUrls = [];
      await userNotifsRef
          .doc(event.auth.currentUser!.uid)
          .collection("notify")
          .get()
          .then((value) async {
        for (var element in value.docs) {
          userNotifs.add(UserNotifications.fromJson(element.data()));
        }
        userNotifs.sort((a, b) {
          if (num.parse(a.notifId!) > num.parse(b.notifId!)) {
            return 0;
          } else {
            return 1;
          }
        });
        for (var element in userNotifs) {
          await usersRef.doc(element.actorId).get().then((value) {
            userNames.add(value["userName"]);
            photoUrls.add(value["imgUrl"]);
          });
        }
      });

      emit(NotifLoadedState(
          userNotifs: userNotifs, userNames: userNames, imgUrls: photoUrls));
    }
  }
}
