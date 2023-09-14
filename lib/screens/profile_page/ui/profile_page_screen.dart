import 'package:chat_app/screens/comments_page/ui/comment_screen.dart';
import 'package:chat_app/screens/edit_profile/ui/edit_profile_screen.dart';
import 'package:chat_app/screens/profile_page/bloc/profile_bloc.dart';
import 'package:chat_app/screens/profile_page/ui/profile_post_listview.dart';
import 'package:chat_app/screens/profile_page/ui/profile_post_widget.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseAuth auth;
  final String searchedUid;
  const ProfilePage({super.key, required this.auth, required this.searchedUid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc profileBloc = ProfileBloc();
  final userRef = FirebaseFirestore.instance.collection("users");
  final postsRef = FirebaseFirestore.instance.collection("posts");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: userRef.doc(widget.searchedUid).snapshots(),
        builder: (context, snapshot) {
          profileBloc.add(ProfileInitialLoadEvent(snapshot, widget.auth));
          return Scaffold(
            appBar: AppBar(title: const Text("Interactify")),
            body: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return <Widget>[
                        SliverToBoxAdapter(
                          child: StreamBuilder<DocumentSnapshot>(
                              stream:
                                  userRef.doc(widget.searchedUid).snapshots(),
                              builder: (context, snapshot) {
                                profileBloc.add(ProfileInitialLoadEvent(
                                    snapshot, widget.auth));

                                return BlocConsumer<ProfileBloc, ProfileState>(
                                  bloc: profileBloc,
                                  listenWhen: (previous, current) =>
                                      current is ProfileActionState,
                                  listener: (context, state) {
                                    if (state
                                        is ProfileNavigateToEditDetailsPageActionState) {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile(
                                                          auth: widget.auth)))
                                          .whenComplete(() {
                                        setState(() {});
                                        profileBloc.add(ProfileInitialLoadEvent(
                                            snapshot, widget.auth));
                                      });
                                    } else if (state
                                        is ProfileUidFollowedButtonActionState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("User followed")));
                                    } else if (state
                                        is ProfileUidUnfollowedButtonActionState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("User Unfollowed")));
                                    } else if (state
                                        is ProfileNavigateToCommentActionState) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen(
                                                      postId: state.postId,
                                                      auth: widget.auth,
                                                      stream: state.stream)));
                                    } else if (state
                                        is ProfileOnPressedShowDialogForMoreButtonActionState) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              icon: const Icon(Icons.delete),
                                              title: const Text(
                                                  "Do You want to delete this post?"),
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      profileBloc.add(
                                                          ProfileDeletePostPressedEvent(
                                                              state.postId));
                                                    },
                                                    style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.red)),
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text("Cancel")),
                                              ],
                                            );
                                          });
                                    } else if (state
                                        is ProfileDeletePressedActionState) {
                                      Navigator.pop(context);
                                      setState(() {});
                                    }
                                  },
                                  buildWhen: (previous, current) =>
                                      current is! ProfileActionState &&
                                      current
                                          is! ProfileListViewInitialLoadedState,
                                  builder: (context, state) {
                                    switch (state.runtimeType) {
                                      case ProfileScreenLoadedState:
                                        final successState =
                                            state as ProfileScreenLoadedState;
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        height: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.24,
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.23,
                                                        decoration: ShapeDecoration(
                                                            color: Colors
                                                                .grey.shade400,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    successState.dbUser.imgUrl ??
                                                                        ""),
                                                                fit: BoxFit
                                                                    .cover),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(MediaQuery.of(context).size.width * 0.12)))),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.70,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.28,
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Row(children: [
                                                                Expanded(
                                                                    child: Text(
                                                                  successState
                                                                      .postLength,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.065),
                                                                )),
                                                                Expanded(
                                                                    child: Text(
                                                                  successState
                                                                      .dbUser
                                                                      .followers!
                                                                      .length
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.065),
                                                                )),
                                                                Expanded(
                                                                    child: Text(
                                                                  successState
                                                                      .dbUser
                                                                      .following!
                                                                      .length
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.065),
                                                                ))
                                                              ]),
                                                              Row(children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        "Posts",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor),
                                                                        textAlign:
                                                                            TextAlign.center)),
                                                                Expanded(
                                                                    child: Text(
                                                                        "followers",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor),
                                                                        textAlign:
                                                                            TextAlign.center)),
                                                                Expanded(
                                                                    child: Text(
                                                                        "following",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor),
                                                                        textAlign:
                                                                            TextAlign.center)),
                                                              ]),
                                                              successState.userStatus ==
                                                                      "self"
                                                                  ? OutlinedButton(
                                                                      style: ButtonStyle(
                                                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  10))),
                                                                          side: MaterialStateProperty.all(const BorderSide(
                                                                              color: Colors
                                                                                  .grey))),
                                                                      onPressed:
                                                                          () {
                                                                        profileBloc
                                                                            .add(ProfileEditButtonClickedEvent(widget.auth));
                                                                      },
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Text(
                                                                              "Edit profile",
                                                                              style: TextStyle(color: Theme.of(context).primaryColor),
                                                                            )
                                                                          ]))
                                                                  : successState
                                                                              .userStatus ==
                                                                          "following"
                                                                      ? OutlinedButton(
                                                                          style: ButtonStyle(
                                                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                                              side: MaterialStateProperty.all(const BorderSide(color: Colors.grey))),
                                                                          onPressed: () {
                                                                            profileBloc.add(ProfileUnfollowButtonClickedEvent(widget.searchedUid,
                                                                                widget.auth.currentUser!.uid));
                                                                          },
                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("following", style: TextStyle(color: Theme.of(context).primaryColor))]))
                                                                      : OutlinedButton(
                                                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue.shade600), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), side: MaterialStateProperty.all(const BorderSide(color: Colors.grey))),
                                                                          onPressed: () {
                                                                            profileBloc.add(ProfileFollowButtonClickedEvent(
                                                                                searchedUid: widget.searchedUid,
                                                                                currUserUid: widget.auth.currentUser!.uid));
                                                                          },
                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                                                                            Text("Follow",
                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
                                                                          ])),
                                                            ]))
                                                  ]),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            successState.dbUser
                                                                    .profileName ??
                                                                "",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05)),
                                                        Text(
                                                            successState.dbUser
                                                                    .bio ??
                                                                "",
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                      ])),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02)
                                            ]);

                                      default:
                                        return getProfileDetailsLoadingWidget(
                                            context);
                                    }
                                  },
                                );
                              }),
                        ),
                        SliverAppBar(
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          toolbarHeight: 0,
                          bottom: TabBar(
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.grid_on,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.list,
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                            indicatorColor: Theme.of(context).primaryColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                        ),
                      ];
                    },
                    body: StreamBuilder<QuerySnapshot>(
                        stream: postsRef
                            .where("ownerId", isEqualTo: widget.searchedUid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          profileBloc
                              .add(ProfileListViewIntialFetchEvent(snapshot));
                          return BlocBuilder<ProfileBloc, ProfileState>(
                              bloc: profileBloc,
                              buildWhen: (previous, current) =>
                                  current is! ProfileActionState &&
                                  current is! ProfileScreenLoadedState,
                              builder: (context, state) {
                                switch (state.runtimeType) {
                                  case ProfileListViewInitialLoadedState:
                                    final successState = state
                                        as ProfileListViewInitialLoadedState;

                                    return TabBarView(children: [
                                      ProfilePostGridView(
                                          userPosts: successState.userPosts),
                                      ProfilePostListView(
                                        userPosts: successState.userPosts,
                                        profileUrl: successState.imgUrl,
                                        auth: widget.auth,
                                        profileBloc: profileBloc,
                                      )
                                    ]);

                                  default:
                                    return getUserGridViewLoading(context);
                                }
                              });
                        }))),
          );
        });
  }
}
