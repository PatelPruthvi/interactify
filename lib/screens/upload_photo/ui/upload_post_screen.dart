// ignore_for_file: unused_local_variable

import 'package:chat_app/screens/upload_photo/bloc/post_bloc.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadPost extends StatefulWidget {
  final FirebaseAuth auth;
  const UploadPost({super.key, required this.auth});

  @override
  State<UploadPost> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  final PostBloc postBloc = PostBloc();

  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  void initState() {
    postBloc.add(PostInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      bloc: postBloc,
      listenWhen: (previous, current) => current is PostActionState,
      listener: (context, state) {
        if (state is PostBottomSheetDisplayActionState) {
          showModalBottomSheet(
              context: context,
              builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              postBloc.add(PostAddFromCameraClickedEvent());
                            },
                            child: Row(children: [
                              const Icon(CupertinoIcons.camera),
                              const SizedBox(width: 12),
                              Text("Capture image from camera",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.022))
                            ])),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              postBloc.add(
                                  PostAddMultipleFromGalleryClickedEvent());
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.photo_outlined),
                                SizedBox(width: 12),
                                Text("Select images from gallery",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.022)),
                              ],
                            ))
                      ])));
        } else if (state is PostErrorMsgActionState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMsg),
            duration: const Duration(seconds: 2),
          ));
        } else if (state is PostCurrentLocationSetActionState) {
          setState(() {
            locationController.text = state.currLocation.toString();
          });
        } else if (state is PostUploadedSuccessfullyStateActionState) {
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    icon: Icon(Icons.done),
                    content: Text("Post uploaded successfully"),
                  ));
          postBloc.add(PostBackButtonPressedEvent(
              caption: captionController, location: locationController));
        }
      },
      buildWhen: (previous, current) => current is! PostActionState,
      builder: (context, state) {
        switch (state.runtimeType) {
          case PostLoadingState:
            final successState = state as PostLoadingState;
            return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        postBloc.add(PostBackButtonPressedEvent(
                            caption: captionController,
                            location: locationController));
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                  title: Text(
                    "Posting...",
                    style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Share",
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                body: Stack(
                  children: [
                    LinearProgressIndicator(color: Colors.blue.shade600),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    color: Theme.of(context).primaryColorLight,
                                    height: MediaQuery.of(context).size.height *
                                        0.42,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.image.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              padding: const EdgeInsets.only(
                                                  right: 12, left: 12),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image.memory(
                                                state.image[index],
                                                fit: BoxFit.fitHeight,
                                              ));
                                        })),
                                const Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                TextField(
                                  controller: captionController,
                                  maxLines: 4,
                                  autocorrect: false,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      prefixIcon: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade400,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.network(
                                                widget
                                                    .auth.currentUser!.photoURL
                                                    .toString(),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15),
                                          ),
                                        ),
                                      ),
                                      helperMaxLines: 3,
                                      hintText: "Write a caption...",
                                      hintStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500))),
                                ),
                                TextField(
                                    enabled: false,
                                    controller: locationController,
                                    decoration: InputDecoration(
                                        prefixIconColor: Colors.grey.shade500,
                                        prefixIcon: Icon(
                                          Icons.location_pin,
                                          color: Colors.grey.shade500,
                                        ),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade500)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade500)),
                                        hintText: "Update the location here",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor))),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: CupertinoButton(
                                      color: Colors.grey.shade600,
                                      child: Text(
                                        "Get Current Location",
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.lato().fontFamily),
                                      ),
                                      onPressed: () {
                                        // postBloc.add(
                                        //     PostGetCurrentLocationButtonClickedEvent());
                                      }),
                                )
                              ]),
                        )),
                  ],
                ));

          case PostInitial:
            return Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Icon(Icons.add_photo_alternate, size: 180)),
                    const SizedBox(height: 20),
                    CupertinoButton(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(10),
                        child: Text(
                          "Upload image",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorLight,
                              fontFamily: GoogleFonts.varelaRound().fontFamily),
                        ),
                        onPressed: () {
                          postBloc.add(PostUploadPhotoButtonClickedEvent());
                        })
                  ]),
            );
          case PostImageCapturedState:
            final successState = state as PostImageCapturedState;
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: () {
                          postBloc.add(PostBackButtonPressedEvent(
                              caption: captionController,
                              location: locationController));
                        },
                        icon: Icon(Icons.close,
                            color: Theme.of(context).primaryColor)),
                    title: Text("New Post",
                        style: TextStyle(
                            fontFamily: GoogleFonts.lato().fontFamily)),
                    centerTitle: true,
                    actions: [
                      TextButton(
                          onPressed: () {
                            postBloc.add(PostShareButtonClickedEvent(
                                captionController.text,
                                locationController.text,
                                widget.auth));
                          },
                          child: Text(
                            "Share",
                            style: TextStyle(
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.w700),
                          ))
                    ],
                  ),
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  body: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  color: Theme.of(context).primaryColorLight,
                                  height:
                                      MediaQuery.of(context).size.height * 0.42,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.image.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            padding: const EdgeInsets.only(
                                                right: 12, left: 12),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Image.memory(
                                              state.image[index],
                                              fit: BoxFit.fitHeight,
                                            ));
                                      })),
                              const Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              TextField(
                                controller: captionController,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                maxLines: 4,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    fillColor:
                                        Theme.of(context).primaryColorLight,
                                    prefixIcon: smallRoundedProfileContainer(
                                        context,
                                        widget.auth.currentUser!.photoURL),
                                    helperMaxLines: 3,
                                    hintText: "Write a caption...",
                                    hintStyle: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade500))),
                              ),
                              TextField(
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  enabled: false,
                                  controller: locationController,
                                  decoration: InputDecoration(
                                      fillColor:
                                          Theme.of(context).primaryColorLight,
                                      prefixIconColor: Colors.grey.shade500,
                                      prefixIcon: Icon(
                                        Icons.location_pin,
                                        color: Colors.grey.shade500,
                                      ),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500)),
                                      hintText: "Update the location here",
                                      hintStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: CupertinoButton(
                                    color: Colors.blue.shade600,
                                    child: Text(
                                      "Get Current Location",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily),
                                    ),
                                    onPressed: () {
                                      postBloc.add(
                                          PostGetCurrentLocationButtonClickedEvent());
                                    }),
                              )
                            ]),
                      ))),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
