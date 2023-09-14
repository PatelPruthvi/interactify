part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchInitialEvent extends SearchEvent {}

class SearchOnTextFieldClickedEvent extends SearchEvent {}

class SearchOnCancelButtonClickedEvent extends SearchEvent {}

class SearchOnTextFieldValueChangedEvent extends SearchEvent {
  final String usernameValue;

  SearchOnTextFieldValueChangedEvent(this.usernameValue);
}

class SearchRandomUserClickedEvent extends SearchEvent {
  final String searchedUid;
  final FirebaseAuth auth;

  SearchRandomUserClickedEvent(this.searchedUid, this.auth);
}
