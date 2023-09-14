import 'package:chat_app/screens/home/bloc/home_bloc.dart';
import 'package:chat_app/screens/loggedIn/ui/logged_in.dart';
import 'package:chat_app/screens/set_username/ui/username_screen.dart';
import 'package:chat_app/screens/signupwithemail/ui/signup_email_screen.dart';
import 'package:chat_app/widgets/widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc homeBloc = HomeBloc();
  bool isNotVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        listener: (context, state) {
          if (state is HomeErrorMsgActionState) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      icon: Icon(Icons.dangerous), title: Text(state.errorMsg));
                }).whenComplete(() => homeBloc.add(HomeInitialEvent()));
          } else if (state is HomeNavigateToLoginScreenActionState) {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoggedInPage(auth: state.auth)));
          } else if (state is HomeForgotPasswordSuccessFulActionState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Password reset link sent to the email..")));
            homeBloc.add(HomeInitialEvent());
          } else if (state is HomeNavigateToSignUpScreenActionState) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpMailScreen()));
          } else if (state is HomeNavigateToUserDetailsSetActionState) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserName(auth: state.auth)))
                .whenComplete(
                    () => homeBloc.add(HomeBackClickedFromUserEvent()));
          }
        },
        buildWhen: (previous, current) => current is! HomeActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case HomeLoadingState:
              return const Center(child: CircularProgressIndicator());
            case HomeLoadedSuccessState:
              return Container(
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image.network(
                              'https://www.transparentpng.com/thumb/logo-instagram/orzG9u-instagram-picture-logo-png.png',
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textFieldType1(
                                  context, emailController, "Email address"),
                              TextField(
                                  controller: passController,
                                  autocorrect: false,
                                  obscureText: isNotVisible,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                    fillColor: Theme.of(context).canvasColor,
                                    filled: true,
                                    labelText: "Password ",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none),
                                    suffix: InkWell(
                                        child: isNotVisible
                                            ? const Icon(
                                                CupertinoIcons.eye_slash)
                                            : const Icon(CupertinoIcons.eye),
                                        onTap: () {
                                          setState(() {
                                            isNotVisible = !isNotVisible;
                                          });
                                        }),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                              CupertinoButton(
                                  color: Colors.blue.shade600,
                                  borderRadius: BorderRadius.circular(30),
                                  onPressed: () {
                                    homeBloc.add(HomeLogInButtonClickedEvent(
                                        emailController.text,
                                        passController.text.toString()));
                                  },
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Center(
                                          child: Text(
                                        "Log In",
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.lato().fontFamily,
                                            fontWeight: FontWeight.w600),
                                      )))),
                              TextButton(
                                onPressed: () {
                                  homeBloc.add(
                                      HomeForgotPasswordButtonClickedEvent(
                                          emailController.text));
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                      child: Divider(
                                    color: Colors.grey,
                                  )),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("OR"),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey))
                                ],
                              ),
                              OutlinedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      side: MaterialStateProperty.all(
                                          const BorderSide(
                                              color: Colors.grey))),
                                  onPressed: () {
                                    homeBloc.add(
                                        HomeSignInWithGoogleButtonClickedEvent());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2008px-Google_%22G%22_Logo.svg.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        Text(
                                          "    Continue With Google",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      ],
                                    ),
                                  )),
                              OutlinedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      side: MaterialStateProperty.all(
                                          const BorderSide(
                                              color: Colors.grey))),
                                  onPressed: () {
                                    homeBloc.add(
                                        HomeCreateAccountButtonClickedEvent());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Create a New Account",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
