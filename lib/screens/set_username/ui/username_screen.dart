// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/screens/loggedIn/ui/logged_in.dart';
import 'package:chat_app/screens/set_username/bloc/usernm_bloc.dart';
import 'package:chat_app/widgets/widgets.dart';

class UserName extends StatefulWidget {
  final FirebaseAuth auth;

  const UserName({Key? key, required this.auth}) : super(key: key);

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final UsernmBloc usernmBloc = UsernmBloc();
  TextEditingController userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Theme.of(context).highlightColor,
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColorLight,
              Theme.of(context).indicatorColor
            ])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Text(
                "What's your name?",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const Text("Add your name so that friends can find you."),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              textFieldType1(context, userNameController, "User name"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              BlocConsumer<UsernmBloc, UsernmState>(
                bloc: usernmBloc,
                listenWhen: (previous, current) => current is UsernmActionState,
                listener: (context, state) {
                  if (state is UsernmNavigateToLoggedInPageActionState) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoggedInPage(auth: state.auth)));
                  }
                },
                buildWhen: (previous, current) => current is! UsernmActionState,
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case UsernmLoadingState:
                      return Center(child: CircularProgressIndicator());
                    case UsernmErrorMsgState:
                      final successState = state as UsernmErrorMsgState;
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                successState.errorMsg,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            CupertinoButton(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(30),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [Text("Proceed")]),
                                onPressed: () {
                                  usernmBloc.add(
                                      UsernmProceedButtonClickedEvent(
                                          widget.auth,
                                          userNameController.text.trim()));
                                })
                          ]);

                    default:
                      return CupertinoButton(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Text("Proceed")]),
                          onPressed: () {
                            usernmBloc.add(UsernmProceedButtonClickedEvent(
                                widget.auth, userNameController.text.trim()));
                          });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
