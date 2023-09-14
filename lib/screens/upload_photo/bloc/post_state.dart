part of 'post_bloc.dart';

@immutable
abstract class PostState {}

abstract class PostActionState extends PostState {}

class PostInitial extends PostState {}

class PostLoadingState extends PostState {
  final List<Uint8List> image;

  PostLoadingState(this.image);
}

class PostBottomSheetDisplayActionState extends PostActionState {}

class PostCaptureSingleImageState extends PostState {
  final Uint8List image;

  PostCaptureSingleImageState(this.image);
}

class PostImageCapturedState extends PostState {
  final List<Uint8List> image;

  PostImageCapturedState(this.image);
}

class PostCurrentLocationSetActionState extends PostActionState {
  final String currLocation;

  PostCurrentLocationSetActionState(this.currLocation);
}

class PostErrorMsgActionState extends PostActionState {
  final String errorMsg;

  PostErrorMsgActionState(this.errorMsg);
}

class PostUploadedSuccessfullyStateActionState extends PostActionState {}
