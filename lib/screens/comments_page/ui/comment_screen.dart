// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/screens/comments_page/bloc/comment_bloc.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final FirebaseAuth auth;
  final Stream<QuerySnapshot> stream;
  const CommentScreen(
      {Key? key,
      required this.postId,
      required this.auth,
      required this.stream})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  final CommentBloc commentBloc = CommentBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Comments",
              style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily))),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.stream,
          builder: (context, snapshot) {
            commentBloc.add(CommentInitialEvent(snapshot));
            return BlocBuilder<CommentBloc, CommentState>(
              bloc: commentBloc,
              buildWhen: (previous, current) => current is! CommentActionState,
              builder: (context, state) {
                switch (state.runtimeType) {
                  case CommentLoadingState:
                    return const Center(child: CircularProgressIndicator());
                  case CommentNoCommentYetState:
                    return const Center(child: Text("No Comments Yet..."));
                  case CommentLoadedState:
                    final successState = state as CommentLoadedState;
                    return ListView.builder(
                        itemCount: successState.userComments.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              tileColor:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              title: Row(
                                children: [
                                  Text(successState.userName[index],
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.050)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  Text(successState.time[index],
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))
                                ],
                              ),
                              subtitle: Text(
                                  successState.userComments[index].comment ??
                                      "",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045)),
                              leading: smallRoundedProfileContainer(
                                  context, state.photoUrls[index]));
                        });
                  default:
                    return Container(color: Colors.black);
                }
              },
            );
          }),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BlocListener<CommentBloc, CommentState>(
          bloc: commentBloc,
          listener: (context, state) {
            if (state is CommentEmptyActionState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMsg.toString())));
            } else if (state is CommentAddedToFirebaseState) {
              commentController.clear();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Posted :)")));
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.01),
            child: TextField(
              style: TextStyle(color: Theme.of(context).primaryColor),
              controller: commentController,
              autocorrect: false,
              decoration: InputDecoration(
                  hintText: "Add a comment",
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).canvasColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).canvasColor)),
                  prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: smallRoundedProfileContainer(
                          context, widget.auth.currentUser!.photoURL)),
                  suffix: TextButton(
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      commentBloc.add(CommentPostButtonClickedEvent(
                          commentController.text, widget.auth, widget.postId));
                    },
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
