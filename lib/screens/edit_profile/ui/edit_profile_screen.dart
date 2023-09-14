// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:chat_app/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:chat_app/screens/home/ui/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  final FirebaseAuth auth;

  const EditProfile({Key? key, required this.auth}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final EditProfileBloc editProfileBloc = EditProfileBloc();
  TextEditingController nameC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController bioC = TextEditingController();

  @override
  void initState() {
    editProfileBloc.add(EditProfileInitialEvent(widget.auth));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
        bloc: editProfileBloc,
        listenWhen: (previous, current) => current is EditProfileActionState,
        listener: (context, state) {
          if (state is EditProfilePhotoClickedActionState) {
            showModalBottomSheet(
                context: context,
                builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                editProfileBloc.add(
                                    EditProfileTakePhotoFromCameraPressedEvent());
                              },
                              child: Row(children: [
                                const Icon(CupertinoIcons.camera),
                                const SizedBox(width: 12),
                                Text("Capture photo from camera",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.022))
                              ])),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                editProfileBloc.add(
                                    EditProfileTakePhotoFromGalleryePressedEvent());
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.photo_outlined),
                                  const SizedBox(width: 12),
                                  Text("Select image from gallery",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.022)),
                                ],
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                editProfileBloc.add(
                                    EditProfileRemoveCurrentDPPressedEvent(
                                        widget.auth));
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.delete),
                                  const SizedBox(width: 12),
                                  Text("Remove Current Photo",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.022)),
                                ],
                              ))
                        ])));
          } else if (state is EditProfileLoadedSuccessActionState) {
            setState(() {
              nameC.text = state.dbUser.profileName ?? "";
              usernameC.text = state.dbUser.userName ?? "";
              emailC.text = state.dbUser.email ?? "";
              bioC.text = state.dbUser.bio ?? "";
            });
          } else if (state is EditProfileLogoutDoneActionState) {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (state is EditProfileSuccessfullyDoneActionState) {
            Navigator.of(context).pop();
          } else if (state is EditProfileErrordDisplayActionState) {
            editProfileBloc.add(EditProfileInitialEvent(widget.auth));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMsg)));
          }
        },
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: TextButton(
                  child: Text("cancel",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text("Edit Profile",
                    style: TextStyle(
                      fontFamily: GoogleFonts.varelaRound().fontFamily,
                      fontSize: 18,
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        editProfileBloc.add(EditProfileDoneClickedEvent(
                            widget.auth,
                            nameC.text,
                            usernameC.text,
                            bioC.text));
                      },
                      child: Text("Done",
                          style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w600)))
                ]),
            body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(children: [
                  BlocBuilder<EditProfileBloc, EditProfileState>(
                    bloc: editProfileBloc,
                    buildWhen: (previous, current) =>
                        current is! EditProfileActionState,
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        case EditProfileInitial:
                          return Padding(
                            padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.018),
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      editProfileBloc
                                          .add(EditProfilePhotoClickedEvent());
                                    },
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        width: MediaQuery.of(context).size.width *
                                            0.285,
                                        decoration: ShapeDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            image: DecorationImage(
                                                image: NetworkImage(widget.auth
                                                    .currentUser!.photoURL!),
                                                fit: BoxFit.cover),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.15)))))),
                          );
                        case EditProfileLoadingState:
                          return Stack(children: [
                            LinearProgressIndicator(
                                color: Colors.blue.shade600),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.018),
                                child: Center(
                                    child: Container(
                                        height: MediaQuery.of(context).size.width *
                                            0.30,
                                        width: MediaQuery.of(context).size.width *
                                            0.285,
                                        decoration: ShapeDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15))))))
                          ]);
                        case EditProfileNewDisplayPhotoChosenState:
                          final successState =
                              state as EditProfileNewDisplayPhotoChosenState;
                          return Padding(
                            padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.018),
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      editProfileBloc
                                          .add(EditProfilePhotoClickedEvent());
                                    },
                                    child: Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.30,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.285,
                                        decoration: ShapeDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: successState.photoData),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15)))))),
                          );
                        default:
                          return Padding(
                            padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.018),
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.30,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.285,
                                        decoration: ShapeDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15)))))),
                          );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Center(
                        child: Text(
                      "Click on the photo to edit",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                  Divider(height: 2, color: Theme.of(context).primaryColor),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Name",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        )),
                    Expanded(
                        flex: 3,
                        child: TextField(
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            controller: nameC,
                            autocorrect: false,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColor)))))
                  ]),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Username ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        )),
                    Expanded(
                        flex: 3,
                        child: TextField(
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          controller: usernameC,
                          autocorrect: false,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor))),
                        ))
                  ]),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Email",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        )),
                    Expanded(
                        flex: 3,
                        child: TextField(
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          controller: emailC,
                          autocorrect: false,
                          enabled: false,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor))),
                        ))
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Bio ",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)))),
                    Expanded(
                        flex: 3,
                        child: TextField(
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            controller: bioC,
                            maxLines: 4,
                            autocorrect: false,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColor)))))
                  ]),
                  Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: CupertinoButton(
                          color: Colors.red.shade300,
                          child: Text("Log Out",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.lato().fontFamily)),
                          onPressed: () {
                            editProfileBloc.add(
                                EditProfileLogOutClickedEvent(widget.auth));
                          }))
                ]))));
  }
}
