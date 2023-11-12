import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class Skills extends StatefulWidget {
  final userId;
  const Skills({super.key, required this.userId});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  bool hasSkills = false;

  @override
  void initState() {
    super.initState();
    checkSkills();
  }

  void checkSkills() {
    FirebaseFirestore.instance
        .collection('condidat')
        .doc(widget.userId)
        .collection('skills')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        hasSkills = querySnapshot.docs.isNotEmpty;
      });
    }).catchError((error) {
      // Handle any potential errors
      if (!mounted) return;
      showSnackBar(context, "Error: $error");
    });
  }

  TextEditingController skillsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: false,
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
              )),
          centerTitle: true,
          title: const Text(
            "Skills",
            style: TextStyle(
                color: blackColor, fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        body: Stack(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.userId == FirebaseAuth.instance.currentUser!.uid
                        ? const SizedBox(
                            height: 30,
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                    widget.userId == FirebaseAuth.instance.currentUser!.uid
                        ? const Text(
                            "Enter Skills",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: blackColor),
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    widget.userId == FirebaseAuth.instance.currentUser!.uid
                        ? TextField(
                            controller: skillsController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: greyColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: InkResponse(
                                          onTap: () async {
                                            if (skillsController
                                                .text.isNotEmpty) {
                                              String newSkillsId =
                                                  const Uuid().v1();

                                              await FirebaseFirestore.instance
                                                  .collection('condidat')
                                                  .doc(widget.userId)
                                                  .collection('skills')
                                                  .doc(newSkillsId)
                                                  .set({
                                                'skills': skillsController.text,
                                                'skillsId': newSkillsId,
                                                "uid": FirebaseAuth
                                                    .instance.currentUser!.uid,
                                              });

                                              skillsController.clear();
                                              setState(() {});
                                            } else {
                                              showSnackBar(
                                                  context, "Add a valid Skill");
                                            }
                                          },
                                          child: const Text(
                                            "+Add",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 28, 107, 191)),
                                          ),
                                        )),
                                  ],
                                )),
                          )
                        : const Text(
                            'All Skills For this Profile',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: blackColor),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    hasSkills
                        ? widget.userId ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Flexible(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('condidat')
                                      .doc(widget.userId)
                                      .collection('skills')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: blackColor,
                                        ),
                                      );
                                    }

                                    return ListView(
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    data['skills'],
                                                    style: const TextStyle(
                                                        fontSize: 17.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: blackColor),
                                                  ),
                                                  const Spacer(),
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
                                                          .collection('skills')
                                                          .doc(data['skillsId'])
                                                          .delete();

                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color:
                                                          Colors.red.shade400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(
                                                thickness: 1,
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
                              )
                            : Flexible(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('condidat')
                                      .doc(widget.userId)
                                      .collection('skills')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: blackColor,
                                        ),
                                      );
                                    }

                                    return ListView(
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    data['skills'],
                                                    style: const TextStyle(
                                                        fontSize: 17.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: blackColor),
                                                  ),
                                                  const Spacer(),
                                                  widget.userId ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                      ? InkResponse(
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
                                                                    'skills')
                                                                .doc(data[
                                                                    'skillsId'])
                                                                .delete();

                                                            setState(() {});
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors
                                                                .red.shade400,
                                                          ),
                                                        )
                                                      : const SizedBox(
                                                          height: 2,
                                                        )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(
                                                thickness: 1,
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
                              )
                        : const SizedBox(
                            height: 1,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
