part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

abstract class SearchActionState extends SearchState {}

class SearchInitial extends SearchState {}

class SearchTextFieldEnabledState extends SearchState {}

class SearchListViewChangedState extends SearchState {
  final List<Users> searchResult;

  SearchListViewChangedState(this.searchResult);
}

class SearchLoadingState extends SearchState {}

class SearchNavigateToProfileActionState extends SearchActionState {
  final FirebaseAuth auth;
  final String searchedUid;

  SearchNavigateToProfileActionState(this.auth, this.searchedUid);
}
