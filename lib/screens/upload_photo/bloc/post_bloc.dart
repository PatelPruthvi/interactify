import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final ImagePicker picker = ImagePicker();
  List<Uint8List> photosData = [];
  final Reference baseStorageRef =
      FirebaseStorage.instance.ref().child("PostsPics");
  final postRef = FirebaseFirestore.instance.collection("posts");

  PostBloc() : super(PostInitial()) {
    on<PostInitialEvent>(postInitialEvent);
    on<PostBackButtonPressedEvent>(postBackButtonPressedEvent);
    on<PostUploadPhotoButtonClickedEvent>(postUploadPhotoButtonClickedEvent);
    on<PostAddFromCameraClickedEvent>(postAddFromCameraClickedEvent);
    on<PostAddFromGalleryClickedEvent>(postAddFromGalleryClickedEvent);
    on<PostAddMultipleFromGalleryClickedEvent>(
        postAddMultipleFromGalleryClickedEvent);
    on<PostGetCurrentLocationButtonClickedEvent>(
        postGetCurrentLocationButtonClickedEvent);
    on<PostShareButtonClickedEvent>(postShareButtonClickedEvent);
  }

  FutureOr<void> postInitialEvent(
      PostInitialEvent event, Emitter<PostState> emit) {
    if (photosData.isEmpty) {
      emit(PostInitial());
    } else {
      emit(PostImageCapturedState(photosData));
    }
  }

  FutureOr<void> postUploadPhotoButtonClickedEvent(
      PostUploadPhotoButtonClickedEvent event, Emitter<PostState> emit) {
    emit(PostBottomSheetDisplayActionState());
  }

  FutureOr<void> postAddFromCameraClickedEvent(
      PostAddFromCameraClickedEvent event, Emitter<PostState> emit) async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    Uint8List photoMemory = await photo!.readAsBytes();
    photosData.add(photoMemory);
    emit(PostImageCapturedState(photosData));
  }

  FutureOr<void> postAddFromGalleryClickedEvent(
      PostAddFromGalleryClickedEvent event, Emitter<PostState> emit) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    Uint8List photoMemory = await image!.readAsBytes();
    photosData.add(photoMemory);
    emit(PostImageCapturedState(photosData));
  }

  FutureOr<void> postAddMultipleFromGalleryClickedEvent(
      PostAddMultipleFromGalleryClickedEvent event,
      Emitter<PostState> emit) async {
    final List<XFile> medias = await picker.pickMultipleMedia();

    for (var element in medias) {
      photosData.add(await element.readAsBytes());
    }
    emit(PostImageCapturedState(photosData));
  }

  Future<FutureOr<void>> postGetCurrentLocationButtonClickedEvent(
      PostGetCurrentLocationButtonClickedEvent event,
      Emitter<PostState> emit) async {
    // emit(PostLoadingState());
    LocationPermission permission;
    //checking if user has permission
    await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //if not we will ask again for permission
      await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      // if user has denied it from the settings section we can not ask for location so he himself has to do it
      emit(PostErrorMsgActionState(
          "Location not available, allow location services from your settings..."));
      emit(PostInitial());
      return 0;
    }

    try {
      Position position = await Geolocator
          .getCurrentPosition(); //getting latitude and longitude from current posi and use them to find accurate address
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String location =
          "${placemark[0].name} , ${placemark[0].administrativeArea} , ${placemark[0].country}";
      placemark[0].name! +
          placemark[0].administrativeArea! +
          placemark[0].country!;
      emit(PostCurrentLocationSetActionState(location));
    } on Exception catch (e) {
      emit(PostErrorMsgActionState(e.toString()));
      emit(PostInitial());
    }
  }

  FutureOr<void> postShareButtonClickedEvent(
      PostShareButtonClickedEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState(photosData));
    Reference refImageToUpload;
    TaskSnapshot taskSnapshot;
    List<String> imgUrl = [];
    String url;
    int cnt = 1;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    for (var element in photosData) {
      String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$cnt';
      refImageToUpload = baseStorageRef.child("post_$uniqueFileName.jpg");
      taskSnapshot = await refImageToUpload.putData(element);
      url = await taskSnapshot.ref.getDownloadURL();
      imgUrl.add(url);
      cnt++;
    }
    if (imgUrl.isEmpty) {
      emit(PostErrorMsgActionState(
          "Unable to upload post, check your connectivity"));
      emit(PostInitial());
    } else {
      var dataSaved = await _savePostDataToFirestore(
          imgUrl, event.caption, event.location, event.auth, postId);
      if (dataSaved == null) {
        emit(PostUploadedSuccessfullyStateActionState());
      } else {
        emit(PostErrorMsgActionState(dataSaved));
        emit(PostImageCapturedState(photosData));
      }
    }
  }

  _savePostDataToFirestore(List<String> imgUrl, String caption, String location,
      FirebaseAuth auth, String postId) async {
    try {
      DocumentSnapshot userDetails = await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get();
      await postRef.doc(postId).set(Posts(
              caption: caption,
              likes: [],
              location: location,
              images: imgUrl,
              ownerId: auth.currentUser!.uid,
              timestamp: DateTime.now(),
              postId: postId,
              userName: userDetails["userName"])
          .toJson());
    } on Exception catch (e) {
      return e.toString();
    }
  }

  FutureOr<void> postBackButtonPressedEvent(
      PostBackButtonPressedEvent event, Emitter<PostState> emit) {
    photosData.clear();
    event.caption.clear();
    event.location.clear();
    emit(PostInitial());
  }
}
