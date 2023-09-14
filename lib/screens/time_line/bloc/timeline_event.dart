part of 'timeline_bloc.dart';

@immutable
abstract class TimelineEvent {}

class TimelineInitialEvent extends TimelineEvent {}

class TimelineUserNameButtonClickedEvent extends TimelineEvent {
  final FirebaseAuth auth;
  final String searchedUid;

  TimelineUserNameButtonClickedEvent(this.auth, this.searchedUid);
}

class TimelinefavouriteButtonClickedEvent extends TimelineEvent {
  final Posts post;
  final String currentUserId;

  TimelinefavouriteButtonClickedEvent(this.post, this.currentUserId);
}

class TimelineCommentButtonClickedEvent extends TimelineEvent {
  final String postId;

  TimelineCommentButtonClickedEvent(this.postId);
}

class TimelineInitialLoadEvent extends TimelineEvent {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  TimelineInitialLoadEvent(this.snapshot);
}
