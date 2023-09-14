import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/users_model.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final userRef = FirebaseFirestore.instance.collection("users");
  final Reference baseStorageRef =
      FirebaseStorage.instance.ref().child("DisplayPhotos");
  final imagePicker = ImagePicker();
  String imgUrl = "";
  Uint8List photoData = Uint8List.fromList([]);
  EditProfileBloc() : super(EditProfileInitial()) {
    on<EditProfileInitialEvent>(editProfileInitialEvent);
    on<EditProfilePhotoClickedEvent>(editProfilePhotoClickedEvent);
    on<EditProfileLogOutClickedEvent>(editProfileLogOutClickedEvent);
    on<EditProfileTakePhotoFromCameraPressedEvent>(
        editProfileTakePhotoFromCameraPressedEvent);
    on<EditProfileTakePhotoFromGalleryePressedEvent>(
        editProfileTakePhotoFromGalleryePressedEvent);
    on<EditProfileRemoveCurrentDPPressedEvent>(
        editProfileRemoveCurrentDPPressedEvent);
    on<EditProfileDoneClickedEvent>(editProfileDoneClickedEvent);
  }
  FutureOr<void> editProfileInitialEvent(
      EditProfileInitialEvent event, Emitter<EditProfileState> emit) async {
    DocumentSnapshot userData =
        await userRef.doc(event.auth.currentUser!.uid).get();
    Users dbUser = Users.fromJson(userData.data() as Map<String, dynamic>);
    emit(EditProfileLoadedSuccessActionState(dbUser));
  }

  FutureOr<void> editProfilePhotoClickedEvent(
      EditProfilePhotoClickedEvent event, Emitter<EditProfileState> emit) {
    emit(EditProfilePhotoClickedActionState());
  }

  FutureOr<void> editProfileLogOutClickedEvent(
      EditProfileLogOutClickedEvent event,
      Emitter<EditProfileState> emit) async {
    await event.auth.signOut();
    emit(EditProfileLogoutDoneActionState());
  }

  FutureOr<void> editProfileTakePhotoFromCameraPressedEvent(
      EditProfileTakePhotoFromCameraPressedEvent event,
      Emitter<EditProfileState> emit) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    photoData = await image!.readAsBytes();
    imgUrl = "";
    emit(EditProfileNewDisplayPhotoChosenState(MemoryImage(photoData)));
  }

  FutureOr<void> editProfileTakePhotoFromGalleryePressedEvent(
      EditProfileTakePhotoFromGalleryePressedEvent event,
      Emitter<EditProfileState> emit) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    photoData = await image!.readAsBytes();
    imgUrl = "";
    emit(EditProfileNewDisplayPhotoChosenState(MemoryImage(photoData)));
  }

  FutureOr<void> editProfileRemoveCurrentDPPressedEvent(
      EditProfileRemoveCurrentDPPressedEvent event,
      Emitter<EditProfileState> emit) async {
    // await userRef.doc(event.auth.currentUser!.uid).update({
    //   "imgUrl":
    //       "https://www.pngkit.com/png/detail/126-1262807_instagram-default-profile-picture-png.png"
    // });
    // await event.auth.currentUser!.updatePhotoURL(
    //     "https://www.pngkit.com/png/detail/126-1262807_instagram-default-profile-picture-png.png");
    imgUrl =
        "https://www.pngkit.com/png/detail/126-1262807_instagram-default-profile-picture-png.png";
    photoData = Uint8List.fromList([]);
    emit(EditProfileNewDisplayPhotoChosenState(const NetworkImage(
        "https://www.pngkit.com/png/detail/126-1262807_instagram-default-profile-picture-png.png")));
  }

  FutureOr<void> editProfileDoneClickedEvent(
      EditProfileDoneClickedEvent event, Emitter<EditProfileState> emit) async {
    if (event.userName.isEmpty ||
        event.profileName.isEmpty ||
        event.userName.length <= 5) {
      emit(EditProfileErrordDisplayActionState(
          "User name or profile name length too small"));
    } else {
      emit(EditProfileLoadingState());
      try {
        if (imgUrl.isNotEmpty) {
          await userRef.doc(event.auth.currentUser!.uid).update({
            "userName": event.userName,
            "profileName": event.profileName,
            "bio": event.bio,
            "imgUrl": imgUrl
          });
          await event.auth.currentUser!.updatePhotoURL(imgUrl);
          await event.auth.currentUser!.updateDisplayName(event.profileName);
        } else if (photoData.isNotEmpty) {
          Reference refImageToUpload;
          refImageToUpload =
              baseStorageRef.child("dp_${event.auth.currentUser!.uid}");
          await refImageToUpload.putData(photoData);
          String fbUrl = await refImageToUpload.getDownloadURL();
          await userRef.doc(event.auth.currentUser!.uid).update({
            "userName": event.userName,
            "profileName": event.profileName,
            "bio": event.bio,
            "imgUrl": fbUrl
          });
          await event.auth.currentUser!.updateDisplayName(event.profileName);
          await event.auth.currentUser!.updatePhotoURL(fbUrl);
        } else {
          await userRef.doc(event.auth.currentUser!.uid).update({
            "userName": event.userName,
            "profileName": event.profileName,
            "bio": event.bio
          });
          await event.auth.currentUser!.updateDisplayName(event.profileName);
        }
        emit(EditProfileSuccessfullyDoneActionState());
      } on Exception catch (e) {
        emit(EditProfileErrordDisplayActionState(e.toString()));
      }
    }
  }
}
