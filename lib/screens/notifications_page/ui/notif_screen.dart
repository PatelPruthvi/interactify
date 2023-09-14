import 'package:chat_app/screens/notifications_page/bloc/notif_bloc.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final FirebaseAuth auth;
  const NotificationPage({super.key, required this.stream, required this.auth});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotifBloc notifBloc = NotifBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0),
        body: StreamBuilder<QuerySnapshot>(
          stream: widget.stream,
          builder: (context, snapshot) {
            notifBloc.add(NotifInitialEvent(snapshot, widget.auth));

            return BlocBuilder<NotifBloc, NotifState>(
              bloc: notifBloc,
              builder: (context, state) {
                switch (state.runtimeType) {
                  case NotifLoadingState:
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.blue.shade600));
                  case NotifEmptyState:
                    return const Center(child: Text("No recent Activity"));
                  case NotifLoadedState:
                    final successState = state as NotifLoadedState;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: successState.userNotifs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(15)),
                          tileColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          leading: smallRoundedProfileContainer(
                              context, successState.imgUrls[index]),
                          title: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: successState.userNames[index],
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w700)),
                              const TextSpan(text: " "),
                              TextSpan(
                                  text: successState.userNotifs[index].action!,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor))
                            ])),
                          ),
                          subtitle: Text(
                              getRelativeTime(
                                  successState.userNotifs[index].notifId!),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark)),
                          trailing: successState.userNotifs[index].objectUrl !=
                                  ""
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Image.network(
                                    successState.userNotifs[index].objectUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(width: 0),
                        );
                      },
                    );

                  default:
                    return Container(color: Colors.black);
                }
              },
            );
          },
        ));
  }
}
