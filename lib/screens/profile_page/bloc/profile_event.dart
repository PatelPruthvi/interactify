// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileEditButtonClickedEvent extends ProfileEvent {
  final FirebaseAuth auth;
  ProfileEditButtonClickedEvent(this.auth);
}

class ProfileCommentButtonClickedEvent extends ProfileEvent {
  final String postId;

  ProfileCommentButtonClickedEvent(this.postId);
}

class ProfileDeletePostPressedEvent extends ProfileEvent {
  final String postId;
  ProfileDeletePostPressedEvent(this.postId);
}

class ProfileFavouriteButtonClickedEvent extends ProfileEvent {
  final String currUserId;
  final Posts post;
  ProfileFavouriteButtonClickedEvent(this.currUserId, this.post);
}

class ProfileFollowButtonClickedEvent extends ProfileEvent {
  final String searchedUid;
  final String currUserUid;
  ProfileFollowButtonClickedEvent(
      {required this.searchedUid, required this.currUserUid});
}

class ProfileUnfollowButtonClickedEvent extends ProfileEvent {
  final String searchedUid;
  final String currUserUid;

  ProfileUnfollowButtonClickedEvent(this.searchedUid, this.currUserUid);
}

class ProfileInitialLoadEvent extends ProfileEvent {
  final AsyncSnapshot<DocumentSnapshot<Object?>> snapshot;
  final FirebaseAuth auth;
  ProfileInitialLoadEvent(this.snapshot, this.auth);
}

class ProfileListViewIntialFetchEvent extends ProfileEvent {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  ProfileListViewIntialFetchEvent(this.snapshot);
}

class ProfileMoreButtonClickedEvent extends ProfileEvent {
  final String postId;

  ProfileMoreButtonClickedEvent(this.postId);
}
