import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:chat_app/screens/comments_page/ui/comment_screen.dart';
import 'package:chat_app/screens/profile_page/ui/profile_page_screen.dart';
import 'package:chat_app/screens/time_line/bloc/timeline_bloc.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:insta_like_button/insta_like_button.dart';

class TimeLinePage extends StatefulWidget {
  final FirebaseAuth auth;
  const TimeLinePage({super.key, required this.auth});

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  final postsRef = FirebaseFirestore.instance.collection("posts");
  final TimelineBloc timelineBloc = TimelineBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Interactify')),
        body: StreamBuilder<QuerySnapshot>(
            stream: postsRef
                .where("ownerId", isNotEqualTo: widget.auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              timelineBloc.add(TimelineInitialLoadEvent(snapshot));
              return BlocConsumer<TimelineBloc, TimelineState>(
                  bloc: timelineBloc,
                  listener: (context, state) {
                    if (state is TimelineNavigateToUserProfilePageActionState) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  auth: state.auth,
                                  searchedUid: state.ownerId)));
                    } else if (state
                        is TimelineNavigateToCommentPageActionState) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                  auth: widget.auth,
                                  postId: state.postId,
                                  stream: state.stream)));
                    }
                  },
                  listenWhen: (previous, current) =>
                      current is TimelineActionState,
                  buildWhen: (previous, current) =>
                      current is! TimelineActionState,
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case TimelineInitialLoadState:
                        final successState = state as TimelineInitialLoadState;
                        return ListView.builder(
                          itemCount: state.totalPosts.length,
                          itemBuilder: (context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 1),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          timelineBloc.add(
                                              TimelineUserNameButtonClickedEvent(
                                                  widget.auth,
                                                  successState.totalPosts[index]
                                                      .ownerId!));
                                        },
                                        child: Row(children: [
                                          smallRoundedProfileContainer(
                                              context, state.imgUrls[index]),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    state.totalPosts[index]
                                                        .userName!,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.045)),
                                                state.totalPosts[index]
                                                            .location !=
                                                        ""
                                                    ? Text(
                                                        state.totalPosts[index]
                                                            .location!,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      )
                                                    : Container()
                                              ])
                                        ]),
                                      )),
                                  const Divider(height: 1),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      child: state.totalPosts[index].images!
                                                  .length ==
                                              1
                                          ? InstaLikeButton(
                                              onChanged: () {
                                                timelineBloc.add(
                                                    TimelinefavouriteButtonClickedEvent(
                                                        state.totalPosts[index],
                                                        widget.auth.currentUser!
                                                            .uid));
                                              },
                                              imageBoxfit: BoxFit.cover,
                                              iconColor: Colors.red,
                                              image: NetworkImage(
                                                state.totalPosts[index]
                                                    .images![0],
                                              ),
                                              width: double.infinity)
                                          : AnotherCarousel(
                                              autoplay: false,
                                              dotBgColor: Colors.transparent,
                                              images: [
                                                  for (var element in state
                                                      .totalPosts[index]
                                                      .images!)
                                                    InstaLikeButton(
                                                        iconColor: Colors.red,
                                                        onChanged: () => timelineBloc.add(
                                                            TimelinefavouriteButtonClickedEvent(
                                                                state.totalPosts[
                                                                    index],
                                                                widget
                                                                    .auth
                                                                    .currentUser!
                                                                    .uid)),
                                                        image: NetworkImage(
                                                            element),
                                                        imageBoxfit:
                                                            BoxFit.cover)
                                                ])),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            timelineBloc.add(
                                                TimelinefavouriteButtonClickedEvent(
                                              state.totalPosts[index],
                                              widget.auth.currentUser!.uid,
                                            ));
                                          },
                                          child: state.totalPosts[index].likes!
                                                  .contains(widget
                                                      .auth.currentUser!.uid)
                                              ? Icon(Icons.favorite,
                                                  color: Colors.red,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.040)
                                              : Icon(Icons.favorite_outline,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.040),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () => timelineBloc.add(
                                              TimelineCommentButtonClickedEvent(
                                                  state.totalPosts[index]
                                                      .postId!)),
                                          child: Icon(
                                              Icons.mode_comment_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.035),
                                        )
                                      ])),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005),
                                      child: Text(
                                          "${state.totalPosts[index].likes!.length} likes",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor))),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                state.totalPosts[index]
                                                    .userName!,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.040)),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015),
                                            Expanded(
                                                child: Text(
                                                    state.totalPosts[index]
                                                        .caption!,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.040)))
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.008,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015),
                                      child: Text(
                                          state.totalPosts[index].timestamp
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.grey))),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.045),
                                ]);
                          },
                        );

                      default:
                        return getListViewLoadingWidget(context);
                    }
                  });
            }));
  }
}
