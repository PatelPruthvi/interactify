import 'package:chat_app/screens/profile_page/ui/profile_page_screen.dart';
import 'package:chat_app/screens/search_page/bloc/search_bloc.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  final FirebaseAuth auth;
  const SearchPage({super.key, required this.auth});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBloc searchBloc = SearchBloc();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0, elevation: 0),
        body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(children: [
              BlocBuilder<SearchBloc, SearchState>(
                bloc: searchBloc,
                buildWhen: (previous, current) =>
                    current is! SearchActionState &&
                    current is! SearchListViewChangedState,
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case SearchInitial:
                      return GestureDetector(
                        onTap: () =>
                            searchBloc.add(SearchOnTextFieldClickedEvent()),
                        child: Container(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.width * 0.04,
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.width * 0.02),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: TextField(
                            enabled: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                fillColor: Theme.of(context).primaryColorLight,
                                suffix: TextButton(
                                    onPressed: () {}, child: Text("Cancel")),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade500,
                                  size:
                                      MediaQuery.of(context).size.width * 0.07,
                                ),
                                filled: true,
                                hintText: "Search ",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.048,
                                )),
                          ),
                        ),
                      );
                    case SearchTextFieldEnabledState:
                      searchController.clear();
                      return Row(children: [
                        Container(
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.05,
                                MediaQuery.of(context).size.width * 0.04,
                                0,
                                MediaQuery.of(context).size.width * 0.02),
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Row(children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.78,
                                child: TextField(
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                    autocorrect: false,
                                    controller: searchController,
                                    onChanged: (value) {
                                      searchBloc.add(
                                          SearchOnTextFieldValueChangedEvent(
                                              value));
                                    },
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        counterStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none),
                                        fillColor:
                                            Theme.of(context).primaryColorLight,
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.grey.shade500,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                        ),
                                        filled: true,
                                        hintText: "Search puzzles",
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.048,
                                        ))),
                              ),
                              TextButton(
                                  onPressed: () {
                                    searchBloc.add(
                                        SearchOnCancelButtonClickedEvent());
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ))
                            ]))
                      ]);
                    default:
                      return const SizedBox();
                  }
                },
              ),
              BlocConsumer(
                  bloc: searchBloc,
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case SearchListViewChangedState:
                        final successState =
                            state as SearchListViewChangedState;
                        if (successState.searchResult.isEmpty) {
                          return const Center(
                              child: Text("No matching results found..."));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ListView.builder(
                                itemCount: successState.searchResult.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        searchBloc.add(
                                            SearchRandomUserClickedEvent(
                                                successState
                                                    .searchResult[index].uid!,
                                                widget.auth));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 0),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          tileColor: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                          leading: smallRoundedProfileContainer(
                                              context,
                                              successState
                                                  .searchResult[index].imgUrl),
                                          title: Text(
                                            successState.searchResult[index]
                                                    .profileName ??
                                                " ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 20),
                                          ),
                                          subtitle: Text(
                                              successState.searchResult[index]
                                                      .userName ??
                                                  "",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark)),
                                        ),
                                      ));
                                }),
                          ),
                        );
                      default:
                        return Container();
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is! SearchActionState,
                  listener: (context, state) {
                    if (state is SearchNavigateToProfileActionState) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  auth: widget.auth,
                                  searchedUid: state.searchedUid)));
                    }
                  },
                  listenWhen: (previous, current) =>
                      current is SearchActionState)
            ])));
  }
}
