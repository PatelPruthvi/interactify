import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TextField textFieldType1(
    BuildContext context, TextEditingController controller, String labelText) {
  return TextField(
    autocorrect: false,
    controller: controller,
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        labelText: labelText),
  );
}

Container smallRoundedProfileContainer(context, imgUrl) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.12,
    width: MediaQuery.of(context).size.width * 0.12,
    decoration: ShapeDecoration(
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.06)),
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover)),
  );
}

String getRelativeTime(String serverTimeInMilliSecs) {
  String time;

  int originalTime = int.parse(serverTimeInMilliSecs);
  int diff =
      ((DateTime.now().millisecondsSinceEpoch - originalTime) * 0.001).ceil();

  if (diff < 15) {
    time = "few seconds ago";
  } else if (diff < 60) {
    time = "$diff seconds ago";
  } else if (diff < 3600) {
    time = "${(diff / 60).toStringAsFixed(0)} minutes ago";
  } else if (diff < 86400) {
    time = "${(diff / 3600).ceil()} hours ago";
  } else {
    time = DateFormat.MMMMd()
        .format(DateTime.fromMillisecondsSinceEpoch(
            int.parse(serverTimeInMilliSecs)))
        .toString();
  }
  return time;
}

Widget getProfileDetailsLoadingWidget(BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: MediaQuery.of(context).size.width * 0.24,
              width: MediaQuery.of(context).size.width * 0.23,
              decoration: ShapeDecoration(
                  color: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.12)))),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              height: MediaQuery.of(context).size.width * 0.28,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        "0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.065),
                      )),
                      Expanded(
                          child: Text(
                        "0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.065),
                      )),
                      Expanded(
                          child: Text(
                        "0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.065),
                      ))
                    ]),
                    Row(children: [
                      Expanded(
                          child: Text("Posts",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("followers",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("following",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center)),
                    ]),
                    OutlinedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.grey))),
                        onPressed: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("following",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor))
                            ])),
                  ]))
        ]),
    Container(height: MediaQuery.of(context).size.height * 0.1)
  ]);
}

Widget getUserGridViewLoading(BuildContext context) {
  return GridView.builder(
    itemCount: 20,
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    itemBuilder: (context, index) {
      return Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
          child: Stack(children: [
            Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorLight))
          ]));
    },
  );
}

Widget getListViewLoadingWidget(BuildContext context) {
  return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(height: 1),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                smallRoundedProfileContainer(context, ""),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              ])),
          Container(
              height: MediaQuery.of(context).size.height * 0.6,
              color: Theme.of(context).primaryColorLight),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.favorite_outline,
                    size: MediaQuery.of(context).size.height * 0.040),
                const SizedBox(width: 10),
                Icon(Icons.mode_comment_outlined,
                    size: MediaQuery.of(context).size.height * 0.035)
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.015,
                  bottom: MediaQuery.of(context).size.height * 0.005),
              child: Text("0 likes",
                  style: TextStyle(color: Theme.of(context).primaryColor))),
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.015),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.040)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                Expanded(
                  child: Text("",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.040)),
                )
              ])),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.008,
                  left: MediaQuery.of(context).size.height * 0.015),
              child: const Text("", style: TextStyle(color: Colors.grey))),
          SizedBox(height: MediaQuery.of(context).size.height * 0.045),
        ]);
      });
}
