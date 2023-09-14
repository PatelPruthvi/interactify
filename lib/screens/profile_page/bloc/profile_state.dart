// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

abstract class ProfileActionState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileNavigateToEditDetailsPageActionState extends ProfileActionState {
  final FirebaseAuth auth;

  ProfileNavigateToEditDetailsPageActionState(this.auth);
}

class ProfileUidFollowedButtonActionState extends ProfileActionState {}

class ProfileUidUnfollowedButtonActionState extends ProfileActionState {}

class ProfileNavigateToCommentActionState extends ProfileActionState {
  final String postId;
  final Stream<QuerySnapshot> stream;
  ProfileNavigateToCommentActionState(this.postId, this.stream);
}

class ProfileScreenLoadedState extends ProfileState {
  final Users dbUser;
  final String userStatus; //self ,following, follow
  final String postLength;

  ProfileScreenLoadedState(this.dbUser, this.userStatus, this.postLength);
}

class ProfileLikedButtonPressedState extends ProfileActionState {}

class ProfileListViewInitialLoadedState extends ProfileState {
  final List<Posts> userPosts;
  final String imgUrl;

  ProfileListViewInitialLoadedState(this.userPosts, this.imgUrl);
}

class ProfileOnPressedShowDialogForMoreButtonActionState
    extends ProfileActionState {
  final String postId;

  ProfileOnPressedShowDialogForMoreButtonActionState(this.postId);
}

class ProfileDeletePressedActionState extends ProfileActionState {}
