import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:chat_app/screens/profile_page/bloc/profile_bloc.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_like_button/insta_like_button.dart';

import '../../../models/post_model.dart';

class ProfilePostListView extends StatefulWidget {
  final List<Posts> userPosts;
  final String profileUrl;
  final FirebaseAuth auth;
  final ProfileBloc profileBloc;
  const ProfilePostListView(
      {super.key,
      required this.userPosts,
      required this.profileUrl,
      required this.auth,
      required this.profileBloc});

  @override
  State<ProfilePostListView> createState() => _ProfilePostListViewState();
}

class _ProfilePostListViewState extends State<ProfilePostListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.userPosts.isEmpty) {
      return const Center(child: Text("No Posts Yet"));
    } else {
      return ListView.builder(
          itemCount: widget.userPosts.length,
          itemBuilder: (context, index) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        smallRoundedProfileContainer(
                            context, widget.profileUrl),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.userPosts[index].userName!,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045)),
                                widget.userPosts[index].location != ""
                                    ? Text(widget.userPosts[index].location!,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark))
                                    : Container()
                              ]),
                        ),
                        widget.auth.currentUser!.uid ==
                                widget.userPosts[index].ownerId
                            ? IconButton(
                                onPressed: () {
                                  widget.profileBloc.add(
                                      ProfileMoreButtonClickedEvent(
                                          widget.userPosts[index].postId!));
                                },
                                icon: Icon(Icons.more_vert))
                            : Container()
                      ])),
                  const Divider(height: 1),
                  GestureDetector(
                      onDoubleTap: () {},
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          color: Theme.of(context).primaryColorLight,
                          child: widget.userPosts[index].images!.length == 1
                              ? InstaLikeButton(
                                  image: NetworkImage(
                                    widget.userPosts[index].images![0],
                                  ),
                                  iconColor: Colors.red,
                                  imageBoxfit: BoxFit.cover,
                                  width: double.infinity,
                                  onChanged: () => widget.profileBloc.add(
                                      ProfileFavouriteButtonClickedEvent(
                                          widget.auth.currentUser!.uid,
                                          widget.userPosts[index])),
                                )
                              : AnotherCarousel(
                                  autoplay: false,
                                  dotBgColor: Colors.transparent,
                                  images: [
                                      for (var element
                                          in widget.userPosts[index].images!)
                                        InstaLikeButton(
                                          iconColor: Colors.red,
                                          image: NetworkImage(element),
                                          imageBoxfit: BoxFit.cover,
                                          onChanged: () => widget.profileBloc.add(
                                              ProfileFavouriteButtonClickedEvent(
                                                  widget.auth.currentUser!.uid,
                                                  widget.userPosts[index])),
                                        )
                                    ]))),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            widget.profileBloc.add(
                                ProfileFavouriteButtonClickedEvent(
                                    widget.auth.currentUser!.uid,
                                    widget.userPosts[index]));
                          },
                          child: widget.userPosts[index].likes!
                                  .contains(widget.auth.currentUser!.uid)
                              ? Icon(Icons.favorite,
                                  color: Colors.red,
                                  size: MediaQuery.of(context).size.height *
                                      0.040)
                              : Icon(Icons.favorite_outline,
                                  size: MediaQuery.of(context).size.height *
                                      0.040),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            widget.profileBloc.add(
                                ProfileCommentButtonClickedEvent(
                                    widget.userPosts[index].postId!));
                          },
                          child: Icon(Icons.mode_comment_outlined,
                              size: MediaQuery.of(context).size.height * 0.035),
                        )
                      ])),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.015,
                        bottom: MediaQuery.of(context).size.height * 0.005),
                    child: Text(
                      "${widget.userPosts[index].likes!.length} likes",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.userPosts[index].userName!,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.040)),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.015),
                            Expanded(
                              child: Text(widget.userPosts[index].caption!,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.040)),
                            )
                          ])),
                  Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015,
                          top: MediaQuery.of(context).size.height * 0.006),
                      child: Text(widget.userPosts[index].timestamp.toString(),
                          style: const TextStyle(color: Colors.grey))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                ]);
          });
    }
  }
}
