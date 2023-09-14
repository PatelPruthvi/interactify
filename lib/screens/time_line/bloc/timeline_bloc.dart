// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/post_model.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final userRef = FirebaseFirestore.instance.collection("users");
  final postsRef = FirebaseFirestore.instance.collection("posts");
  final userNotifsRef = FirebaseFirestore.instance.collection("userNotifs");
  TimelineBloc() : super(TimelineInitial()) {
    on<TimelineInitialLoadEvent>(timelineInitialLoadEvent);
    on<TimelineUserNameButtonClickedEvent>(timelineUserNameButtonClickedEvent);
    on<TimelinefavouriteButtonClickedEvent>(
        timelinefavouriteButtonClickedEvent);
    on<TimelineCommentButtonClickedEvent>(timelineCommentButtonClickedEvent);
  }

  FutureOr<void> timelineInitialLoadEvent(
      TimelineInitialLoadEvent event, Emitter<TimelineState> emit) async {
    List<Posts> totalPosts = [];
    List<String> profileUrl = [];
    profileUrl.clear();
    if (event.snapshot.connectionState == ConnectionState.waiting) {
      emit(TimelineLoadingState());
    } else if (event.snapshot.data!.docs.isEmpty) {
      emit(TimelineErrorState("unable to load new Posts.."));
    } else {
      for (var element in event.snapshot.data!.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        totalPosts.add(Posts.fromJson(data));
      }
      totalPosts.sort((a, b) {
        return num.parse(b.postId!).compareTo(num.parse(a.postId!));
      });
      for (var element in totalPosts) {
        await userRef.doc(element.ownerId).get().then((value) {
          profileUrl.add(value["imgUrl"]);
        });
      }
      emit(TimelineInitialLoadState(totalPosts, profileUrl));
    }
  }

  FutureOr<void> timelineUserNameButtonClickedEvent(
      TimelineUserNameButtonClickedEvent event, Emitter<TimelineState> emit) {
    emit(TimelineNavigateToUserProfilePageActionState(
        event.searchedUid, event.auth));
  }

  FutureOr<void> timelineCommentButtonClickedEvent(
      TimelineCommentButtonClickedEvent event,
      Emitter<TimelineState> emit) async {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection("posts")
        .doc(event.postId)
        .collection("comments")
        .snapshots();

    emit(TimelineNavigateToCommentPageActionState(event.postId, stream));
  }

  FutureOr<void> timelinefavouriteButtonClickedEvent(
      TimelinefavouriteButtonClickedEvent event,
      Emitter<TimelineState> emit) async {
    if (event.post.likes!.contains(event.currentUserId) == false) {
      await postsRef.doc(event.post.postId).update({
        "likes": FieldValue.arrayUnion([event.currentUserId]),
      });
      var notifyid = DateTime.now().millisecondsSinceEpoch.toString();
      await userNotifsRef
          .doc(event.post.ownerId)
          .collection("notify")
          .doc(notifyid)
          .set(UserNotifications("liked your post.", event.currentUserId,
                  event.post.images![0], notifyid)
              .toMap());
    } else {
      await postsRef.doc(event.post.postId).update({
        "likes": FieldValue.arrayRemove([event.currentUserId]),
      });
    }
    emit(TimelineLikedButtonPressedState());
  }
}
