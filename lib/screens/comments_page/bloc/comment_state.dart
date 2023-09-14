// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'comment_bloc.dart';

@immutable
abstract class CommentState {}

abstract class CommentActionState extends CommentState {}

class CommentInitial extends CommentState {}

class CommentEmptyActionState extends CommentActionState {
  final String errorMsg;

  CommentEmptyActionState(this.errorMsg);
}

class CommentAddedToFirebaseState extends CommentActionState {}

class CommentLoadingState extends CommentState {}

class CommentNoCommentYetState extends CommentState {}

class CommentLoadedState extends CommentState {
  final List<Comments> userComments;
  final List<String> photoUrls;
  final List<String> userName;
  final List<String> time;
  CommentLoadedState(
    this.userComments,
    this.photoUrls,
    this.userName,
    this.time,
  );
}
