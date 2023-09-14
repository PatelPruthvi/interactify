// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'timeline_bloc.dart';

@immutable
abstract class TimelineState {}

abstract class TimelineActionState extends TimelineState {}

class TimelineInitial extends TimelineState {}

class TimelineListLoadedState extends TimelineState {
  final List<Posts> totalPosts;
  final List<String> profileUrl;
  TimelineListLoadedState(this.totalPosts, this.profileUrl);
}

class TimelineLoadingState extends TimelineState {}

class TimelineErrorState extends TimelineActionState {
  final String error;

  TimelineErrorState(this.error);
}

class TimelineNavigateToUserProfilePageActionState extends TimelineActionState {
  final String ownerId;
  final FirebaseAuth auth;
  TimelineNavigateToUserProfilePageActionState(this.ownerId, this.auth);
}

class TimelineNavigateToCommentPageActionState extends TimelineActionState {
  final String postId;
  final Stream<QuerySnapshot> stream;
  TimelineNavigateToCommentPageActionState(this.postId, this.stream);
}

class TimelineInitialLoadState extends TimelineState {
  final List<Posts> totalPosts;
  final List<String> imgUrls;

  TimelineInitialLoadState(this.totalPosts, this.imgUrls);
}

class TimelineLikedButtonPressedState extends TimelineActionState {}
