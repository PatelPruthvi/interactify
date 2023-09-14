import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/comment_model.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final postRef = FirebaseFirestore.instance.collection("posts");
  final userRef = FirebaseFirestore.instance.collection("users");
  final userNotifsRef = FirebaseFirestore.instance.collection("userNotifs");
  CommentBloc() : super(CommentInitial()) {
    on<CommentInitialEvent>(commentInitialEvent);

    on<CommentPostButtonClickedEvent>(commentPostButtonClickedEvent);
  }
  FutureOr<void> commentInitialEvent(
      CommentInitialEvent event, Emitter<CommentState> emit) async {
    List<Comments> userComments = [];
    List<String> photoUrls = [];
    List<String> userName = [];
    List<String> time = [];

    if (event.snapshot.connectionState == ConnectionState.waiting) {
      emit(CommentLoadingState());
    } else if (event.snapshot.data!.size == 0) {
      emit(CommentNoCommentYetState());
    } else {
      for (var element in event.snapshot.data!.docs) {
        userComments
            .add(Comments.fromJson(element.data() as Map<String, dynamic>));
      }
      userComments.sort((a, b) {
        if (num.parse(a.commentId!) > num.parse(b.commentId!)) {
          return 0;
        } else {
          return 1;
        }
      });
      for (var element in userComments) {
        await userRef.doc(element.commenterUserId).get().then((value) {
          photoUrls.add(value["imgUrl"]);
          userName.add(value["userName"]);
        });
        String timeOfPosting = "";

        int diff = ((DateTime.now().millisecondsSinceEpoch -
                    num.parse(element.commentId!)) *
                0.001)
            .ceil();
        if (diff < 60) {
          timeOfPosting = "${diff}s";
        } else if (diff < 3600) {
          timeOfPosting = "${(diff / 60).toStringAsFixed(0)} min";
        } else if (diff < 86400) {
          timeOfPosting = "${(diff / 3600).ceil()}h";
        } else if (diff < 604800) {
          timeOfPosting = "${(diff / 86400).ceil()}d ";
        }
        time.add(timeOfPosting);
      }
      emit(CommentLoadedState(userComments, photoUrls, userName, time));
    }
  }

  FutureOr<void> commentPostButtonClickedEvent(
      CommentPostButtonClickedEvent event, Emitter<CommentState> emit) async {
    if (event.comment.toString().trim().isEmpty) {
      emit(CommentEmptyActionState("Comment can not be empty..."));
    } else {
      String ownerId = "";
      String photoUrl = "";
      String commentId = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        await postRef
            .doc(event.postId)
            .collection("comments")
            .doc(commentId)
            .set(Comments(
                    comment: event.comment,
                    commenterUserId: event.auth.currentUser!.uid,
                    commentId: commentId)
                .toMap());
        await postRef.doc(event.postId).get().then((value) {
          ownerId = value["ownerId"];
          photoUrl = value["images"][0];
        });

        await userNotifsRef
            .doc(ownerId)
            .collection("notify")
            .doc(commentId)
            .set(UserNotifications("Commented on your post : ${event.comment}",
                    event.auth.currentUser!.uid, photoUrl, commentId)
                .toMap());
      } on Exception catch (e) {
        emit(CommentEmptyActionState(e.toString()));
      }

      emit(CommentAddedToFirebaseState());
    }
  }
}
