import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/screens/home/bloc/home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../models/users_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final userReference = FirebaseFirestore.instance.collection("users");

  SearchBloc() : super(SearchInitial()) {
    on<SearchInitialEvent>(searchInitialEvent);
    on<SearchRandomUserClickedEvent>(searchRandomUserClickedEvent);
    on<SearchOnTextFieldClickedEvent>(searchOnTextFieldClickedEvent);
    on<SearchOnCancelButtonClickedEvent>(searchOnCancelButtonClickedEvent);
    on<SearchOnTextFieldValueChangedEvent>(searchOnTextFieldValueChangedEvent);
  }
  FutureOr<void> searchInitialEvent(
      SearchInitialEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }

  FutureOr<void> searchOnTextFieldClickedEvent(
      SearchOnTextFieldClickedEvent event, Emitter<SearchState> emit) {
    emit(SearchTextFieldEnabledState());
  }

  FutureOr<void> searchOnCancelButtonClickedEvent(
      SearchOnCancelButtonClickedEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }

  FutureOr<void> searchOnTextFieldValueChangedEvent(
      SearchOnTextFieldValueChangedEvent event,
      Emitter<SearchState> emit) async {
    QuerySnapshot<Map<String, dynamic>> allUsers = await userReference
        .where("userName",
            isGreaterThanOrEqualTo: event.usernameValue.toLowerCase())
        .get();
    List<Users> searchResults = [];
    for (var element in allUsers.docs) {
      Map userData = element.data();
      searchResults.add(Users.fromJson(userData as Map<String, dynamic>));
    }
    emit(SearchListViewChangedState(searchResults));
  }

  FutureOr<void> searchRandomUserClickedEvent(
      SearchRandomUserClickedEvent event, Emitter<SearchState> emit) {
    emit(SearchNavigateToProfileActionState(event.auth, event.searchedUid));
  }
}
