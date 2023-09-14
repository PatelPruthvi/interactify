import 'package:flutter/material.dart';

import '../../../models/post_model.dart';

class ProfilePostGridView extends StatefulWidget {
  final List<Posts> userPosts;
  const ProfilePostGridView({super.key, required this.userPosts});

  @override
  State<ProfilePostGridView> createState() => _ProfilePostGridViewState();
}

class _ProfilePostGridViewState extends State<ProfilePostGridView> {
  @override
  Widget build(BuildContext context) {
    if (widget.userPosts.isEmpty) {
      return const Center(child: Text("No Posts Yet"));
    } else {
      return GridView.builder(
        itemCount: widget.userPosts.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
              child: Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.userPosts[index].images![0]),
                              fit: BoxFit.cover))),
                  widget.userPosts[index].images!.length != 1
                      ? const Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(Icons.filter, color: Colors.white))
                      : Container()
                ],
              ));
        },
      );
    }
  }
}
