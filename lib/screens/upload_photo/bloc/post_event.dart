// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class PostInitialEvent extends PostEvent {}

class PostUploadPhotoButtonClickedEvent extends PostEvent {}

class PostAddFromCameraClickedEvent extends PostEvent {}

class PostAddFromGalleryClickedEvent extends PostEvent {}

class PostAddMultipleFromGalleryClickedEvent extends PostEvent {}

class PostGetCurrentLocationButtonClickedEvent extends PostEvent {}

class PostShareButtonClickedEvent extends PostEvent {
  final String caption;
  final String location;
  final FirebaseAuth auth;
  // final imgUrl;

  PostShareButtonClickedEvent(this.caption, this.location, this.auth);
}

class PostBackButtonPressedEvent extends PostEvent {
  TextEditingController caption;
  TextEditingController location;
  PostBackButtonPressedEvent({
    required this.caption,
    required this.location,
  });
}
