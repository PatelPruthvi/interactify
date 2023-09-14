// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/loggedIn/bloc/login_bloc.dart';
import 'package:chat_app/screens/notifications_page/ui/notif_screen.dart';
import 'package:chat_app/screens/profile_page/ui/profile_page_screen.dart';
import 'package:chat_app/screens/search_page/ui/search_screen.dart';
import 'package:chat_app/screens/time_line/ui/time_line_screen.dart';
import 'package:chat_app/screens/upload_photo/ui/upload_post_screen.dart';

class LoggedInPage extends StatefulWidget {
  final FirebaseAuth auth;

  const LoggedInPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  final LoginBloc loginBloc = LoginBloc();
  final userNotifsRef = FirebaseFirestore.instance.collection("userNotifs");
  @override
  Widget build(BuildContext context) {
    List views = [
      TimeLinePage(auth: widget.auth),
      SearchPage(auth: widget.auth),
      UploadPost(auth: widget.auth),
      NotificationPage(
        stream: userNotifsRef
            .doc(widget.auth.currentUser!.uid)
            .collection("notify")
            .snapshots(),
        auth: widget.auth,
      ),
      ProfilePage(auth: widget.auth, searchedUid: widget.auth.currentUser!.uid)
    ];
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      listener: (context, state) {
        // if(state is Login)
      },
      buildWhen: (previous, current) => current is! LoginActionState,
      builder: (context, state) {
        switch (state.runtimeType) {
          case LoginInitial:
            return Scaffold(
                resizeToAvoidBottomInset: true,
                body: views[4],
                bottomNavigationBar: BottomNavigationBar(
                  showSelectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: '',
                        activeIcon: Icon(Icons.home)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search_sharp),
                        label: '',
                        activeIcon: Icon(Icons.search, size: 32)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_a_photo_outlined),
                        label: '',
                        activeIcon: Icon(Icons.add_a_photo)),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border_outlined),
                      label: '',
                      activeIcon: Icon(Icons.favorite_rounded),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        label: '',
                        activeIcon: Icon(Icons.person))
                  ],
                  currentIndex: 4,
                  onTap: (value) =>
                      loginBloc.add(LoginBarButtonPressedEvent(value)),
                ));

          case LoginIndexIPressedState:
            final successState = state as LoginIndexIPressedState;
            return Scaffold(
                // resizeToAvoidBottomInset: false,
                body: views[successState.index],
                bottomNavigationBar: BottomNavigationBar(
                  showSelectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: '',
                        activeIcon: Icon(Icons.home)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search_sharp),
                        label: '',
                        activeIcon: Icon(Icons.search, size: 32)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_a_photo_outlined),
                        label: '',
                        activeIcon: Icon(Icons.add_a_photo)),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border_outlined),
                      label: '',
                      activeIcon: Icon(Icons.favorite_rounded),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        label: '',
                        activeIcon: Icon(Icons.person))
                  ],
                  currentIndex: successState.index,
                  onTap: (value) =>
                      loginBloc.add(LoginBarButtonPressedEvent(value)),
                ));

          default:
            return const SizedBox();
        }
      },
    );
  }
}
