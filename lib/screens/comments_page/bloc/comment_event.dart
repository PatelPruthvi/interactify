// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'comment_bloc.dart';

@immutable
abstract class CommentEvent {}

class CommentInitialEvent extends CommentEvent {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  CommentInitialEvent(this.snapshot);
}

class CommentPostButtonClickedEvent extends CommentEvent {
  final String comment;
  final FirebaseAuth auth;
  final String postId;
  CommentPostButtonClickedEvent(this.comment, this.auth, this.postId);
}
