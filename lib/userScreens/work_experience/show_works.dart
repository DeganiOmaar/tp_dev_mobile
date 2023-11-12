import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';
import 'package:tp_dev_mobile/userScreens/work_experience/work_experience.dart';

class ShowWorks extends StatefulWidget {
  final userId;
  const ShowWorks({super.key, required this.userId});

  @override
  State<ShowWorks> createState() => _ShowWorksState();
}

class _ShowWorksState extends State<ShowWorks> {
  bool hasExperience = false;

  @override
  void initState() {
    super.initState();
    checkExperience();
  }

  void checkExperience() {
    FirebaseFirestore.instance
        .collection('condidat')
        .doc(widget.userId)
        .collection('myWork')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        hasExperience = querySnapshot.docs.isNotEmpty;
      });
    }).catchError((error) {
      // Handle any potential errors
           if (!mounted) return;
      showSnackBar(context, "Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0.7,
            backgroundColor: whiteColor,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: blackColor,
              ),
            ),
            title: const Text(
              "Work Experienxce",
              style: TextStyle(
                  color: blackColor, fontWeight: FontWeight.w700, fontSize: 22),
            ),
          ),
          body: hasExperience
              ? widget.userId == FirebaseAuth.instance.currentUser!.uid
                  ? SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('condidat')
                                    .doc(widget.userId)
                                    .collection('myWork')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                            color: blackColor));
                                  }

                                  return ListView(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      if (snapshot.hasData) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data['titleWork'],
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data['compagnyname'],
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      DateFormat('MMMM d,' 'y')
                                                          .format(
                                                              data['startDate']
                                                                  .toDate()),
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "-",
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      DateFormat('MMMM d,' 'y')
                                                          .format(
                                                              data['endDate']
                                                                  .toDate()),
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                InkResponse(
                                                    onTap: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'condidat')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection('myWork')
                                                          .doc(data['workid'])
                                                          .delete();

                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color:
                                                          Colors.red.shade300,
                                                    ))
                                              ],
                                            )
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }).toList(),
                                  );
                                },
                              ),
                            ),

                            // Spacer(),
                            widget.userId ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WorkExperience()));
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        blackColor),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets.all(
                                                            12)),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                "Add Experience",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: whiteColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('condidat')
                                    .doc(widget.userId)
                                    .collection('myWork')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                            color: blackColor));
                                  }

                                  return ListView(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      if (snapshot.hasData) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data['titleWork'],
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data['compagnyname'],
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      DateFormat('MMMM d,' 'y')
                                                          .format(
                                                              data['startDate']
                                                                  .toDate()),
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "-",
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      DateFormat('MMMM d,' 'y')
                                                          .format(
                                                              data['endDate']
                                                                  .toDate()),
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                            widget.userId ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Column(
                                                    children: [
                                                      InkResponse(
                                                          onTap: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'condidat')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    'myWork')
                                                                .doc(data[
                                                                    'workid'])
                                                                .delete();

                                                            setState(() {});
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors
                                                                .red.shade300,
                                                          ))
                                                    ],
                                                  )
                                                : SizedBox(
                                                    height: 1,
                                                  )
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }).toList(),
                                  );
                                },
                              ),
                            ),

                            // Spacer(),
                            widget.userId ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WorkExperience()));
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        blackColor),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets.all(
                                                            12)),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                "Add Experience",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: whiteColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  )
                          ],
                        ),
                      ),
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Tell hiring managers about all your accomplishement and responsibilities at previous jobs and interships',
                          style: TextStyle(fontSize: 19, color: greyColor),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SvgPicture.asset(
                            "assets/icons/experience.svg",
                            height: 180,
                            color: const Color.fromARGB(255, 232, 232, 232),
                          ),
                        ),
                      ),
                      widget.userId == FirebaseAuth.instance.currentUser!.uid
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WorkExperience()));
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    blackColor),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(12)),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Add Experience",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: whiteColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 1,
                            )
                    ],
                  ),
                )),
    );
  }
}
