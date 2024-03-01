import 'package:chat_app/screens/signupwithemail/bloc/signup_bloc.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../set_username/ui/username_screen.dart';

class SignUpMailScreen extends StatefulWidget {
  const SignUpMailScreen({super.key});

  @override
  State<SignUpMailScreen> createState() => _SignUpMailScreenState();
}

class _SignUpMailScreenState extends State<SignUpMailScreen> {
  final SignupBloc signupBloc = SignupBloc();
  bool isNotVisible = true;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  void initState() {
    signupBloc.add(SignUpInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Image.network(
                    'https://www.edigitalagency.com.au/wp-content/uploads/new-Instagram-logo-png-full-colour-glyph.png',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.1),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textFieldType1(context, fnameController, "First Name"),
                    textFieldType1(context, lnameController, "Last Name"),
                    textFieldType1(context, emailController, "Email address"),
                    TextField(
                        controller: passController,
                        autocorrect: false,
                        obscureText: isNotVisible,
                        decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          fillColor: Theme.of(context).canvasColor,
                          filled: true,
                          labelText: "Password ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          suffix: InkWell(
                              child: isNotVisible
                                  ? const Icon(CupertinoIcons.eye_slash)
                                  : const Icon(CupertinoIcons.eye),
                              onTap: () {
                                setState(() {
                                  isNotVisible = !isNotVisible;
                                });
                              }),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                        )),
                    BlocConsumer<SignupBloc, SignupState>(
                      bloc: signupBloc,
                      listenWhen: (previous, current) =>
                          current is SignupActionState,
                      listener: (context, state) {
                        if (state is SignUpEnterUserDetailsActionState) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserName(auth: state.auth))).whenComplete(
                              () => signupBloc
                                  .add(SignupBackClickedFromUsernmSetEvent()));
                        } else if (state is SignUpErrorMsgActionState) {
                          showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        icon: const Icon(Icons.dangerous),
                                        title: Text(state.errorMsg));
                                  })
                              .whenComplete(
                                  () => signupBloc.add(SignUpInitialEvent()));
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is! SignupActionState,
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case SignUpLoadedSuccesState:
                            return CupertinoButton(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(30),
                                onPressed: () {
                                  signupBloc.add(SignupButtonClickedEvent(
                                      emailController.text,
                                      passController.text,
                                      "${fnameController.text.trim()} ${lnameController.text.trim()}"));
                                },
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Center(
                                        child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                          fontWeight: FontWeight.w600),
                                    ))));
                          case SignUpLoadingState:
                            return const Center(
                                child: CircularProgressIndicator());
                          default:
                            return SizedBox();
                        }
                      },
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
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Already have an Account? Sign In",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
