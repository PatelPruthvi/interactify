import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:chat_app/models/users_model.dart';

import '../../../models/post_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final userRef = FirebaseFirestore.instance.collection("users");
  final postsRef = FirebaseFirestore.instance.collection("posts");
  final userNotifsRef = FirebaseFirestore.instance.collection("userNotifs");
  List<Posts> postsModel = [];

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEditButtonClickedEvent>(profileEditButtonClickedEvent);
    on<ProfileFollowButtonClickedEvent>(profileFollowButtonClickedEvent);
    on<ProfileUnfollowButtonClickedEvent>(profileUnfollowButtonClickedEvent);
    on<ProfileCommentButtonClickedEvent>(profileCommentButtonClickedEvent);
    on<ProfileMoreButtonClickedEvent>(profileMoreButtonClickedEvent);
    on<ProfileInitialLoadEvent>(profileInitialLoadEvent);
    on<ProfileListViewIntialFetchEvent>(profileListViewIntialFetchEvent);
    on<ProfileFavouriteButtonClickedEvent>(profileFavouriteButtonClickedEvent);
    on<ProfileDeletePostPressedEvent>(profileDeletePostPressedEvent);
  }

  FutureOr<void> profileEditButtonClickedEvent(
      ProfileEditButtonClickedEvent event, Emitter<ProfileState> emit) {
    emit(ProfileNavigateToEditDetailsPageActionState(event.auth));
  }

  FutureOr<void> profileFollowButtonClickedEvent(
      ProfileFollowButtonClickedEvent event, Emitter<ProfileState> emit) async {
    await userRef.doc(event.currUserUid).update({
      "following": FieldValue.arrayUnion([event.searchedUid])
    });

    await userRef.doc(event.searchedUid).update({
      "followers": FieldValue.arrayUnion([event.currUserUid])
    });
    var notifyid = DateTime.now().millisecondsSinceEpoch.toString();

    await userNotifsRef
        .doc(event.searchedUid)
        .collection("notify")
        .doc(notifyid)
        .set(UserNotifications(
                "started following you.", event.currUserUid, "", notifyid)
            .toMap());

    emit(ProfileUidFollowedButtonActionState());
  }

  FutureOr<void> profileUnfollowButtonClickedEvent(
      ProfileUnfollowButtonClickedEvent event,
      Emitter<ProfileState> emit) async {
    await userRef.doc(event.currUserUid).update({
      "following": FieldValue.arrayRemove([event.searchedUid])
    });

    await userRef.doc(event.searchedUid).update({
      "followers": FieldValue.arrayRemove([event.currUserUid])
    });
    emit(ProfileUidUnfollowedButtonActionState());
  }

  FutureOr<void> profileCommentButtonClickedEvent(
      ProfileCommentButtonClickedEvent event, Emitter<ProfileState> emit) {
    Stream<QuerySnapshot> stream =
        postsRef.doc(event.postId).collection("comments").snapshots();
    emit(ProfileNavigateToCommentActionState(event.postId, stream));
  }

  FutureOr<void> profileInitialLoadEvent(
      ProfileInitialLoadEvent event, Emitter<ProfileState> emit) async {
    if (event.snapshot.connectionState == ConnectionState.waiting) {
      // emit(ProfileLoadingState());
    } else if (event.snapshot.data == null) {
      // emit(ProfileErrorState());
    } else if (event.snapshot.hasData) {
      String userStatus = "";
      String postLength = "0";
      Users dbUser =
          Users.fromJson(event.snapshot.data!.data() as Map<String, dynamic>);
      if (event.auth.currentUser!.uid.compareTo(dbUser.uid!) == 0) {
        userStatus = "self";
      } else if (dbUser.followers!.contains(event.auth.currentUser!.uid)) {
        userStatus = "following";
      } else {
        userStatus = "follow";
      }
      await postsRef.where("ownerId", isEqualTo: dbUser.uid).get().then(
        (value) {
          postLength = value.docs.length.toString();
        },
      );
      emit(ProfileScreenLoadedState(dbUser, userStatus, postLength));
    }
  }

  FutureOr<void> profileFavouriteButtonClickedEvent(
      ProfileFavouriteButtonClickedEvent event,
      Emitter<ProfileState> emit) async {
    if (event.post.likes!.contains(event.currUserId) == false) {
      await postsRef.doc(event.post.postId).update({
        "likes": FieldValue.arrayUnion([event.currUserId]),
      });
      var notifyid = DateTime.now().millisecondsSinceEpoch.toString();
      await userNotifsRef
          .doc(event.post.ownerId)
          .collection("notify")
          .doc(notifyid)
          .set(UserNotifications("liked your post.", event.currUserId,
                  event.post.images![0], notifyid)
              .toMap());
    } else {
      await postsRef.doc(event.post.postId).update({
        "likes": FieldValue.arrayRemove([event.currUserId]),
      });
    }
    emit(ProfileLikedButtonPressedState());
  }

  FutureOr<void> profileListViewIntialFetchEvent(
      ProfileListViewIntialFetchEvent event, Emitter<ProfileState> emit) async {
    if (event.snapshot.hasData) {
      String imgUrl = "";
      postsModel.clear();
      for (var element in event.snapshot.data!.docs) {
        Map<String, dynamic> tempPost = element.data() as Map<String, dynamic>;
        postsModel.add(Posts.fromJson(tempPost));
      }
      if (postsModel.isNotEmpty) {
        await userRef.doc(postsModel[0].ownerId).get().then(
          (value) {
            imgUrl = value["imgUrl"];
          },
        );
      }
      postsModel.sort((a, b) {
        return num.parse(b.postId!).compareTo(num.parse(a.postId!));
      });
      emit(ProfileListViewInitialLoadedState(postsModel, imgUrl));
    }
  }

  FutureOr<void> profileMoreButtonClickedEvent(
      ProfileMoreButtonClickedEvent event, Emitter<ProfileState> emit) {
    emit(ProfileOnPressedShowDialogForMoreButtonActionState(event.postId));
  }

  FutureOr<void> profileDeletePostPressedEvent(
      event, Emitter<ProfileState> emit) async {
    await postsRef.doc(event.postId).delete();
    final Reference baseStorageRef =
        FirebaseStorage.instance.ref().child("PostsPics");

    await baseStorageRef.child("post_${event.postId}_1.jpg").delete();
    emit(ProfileDeletePressedActionState());
  }
}
