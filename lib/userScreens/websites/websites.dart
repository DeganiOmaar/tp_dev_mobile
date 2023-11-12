import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';
import 'package:tp_dev_mobile/userScreens/websites/add_websites.dart';

class Websites extends StatefulWidget {
  final userId;
  const Websites({super.key, required this.userId});

  @override
  State<Websites> createState() => _WebsitesState();
}

class _WebsitesState extends State<Websites> {
  bool hasRelatedWebsites = false;

  @override
  void initState() {
    super.initState();
    checkRelatedWebsites();
  }

  void checkRelatedWebsites() {
    FirebaseFirestore.instance
        .collection('condidat')
        .doc(widget.userId)
        .collection('relatedWebsites')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        hasRelatedWebsites = querySnapshot.docs.isNotEmpty;
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
          centerTitle: true,
          title: const Text(
            "Websites",
            style: TextStyle(
                color: blackColor, fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            hasRelatedWebsites
                ? widget.userId == FirebaseAuth.instance.currentUser!.uid
                    ? Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('condidat')
                              .doc(widget.userId)
                              .collection('relatedWebsites')
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
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          'More Informations',
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: blackColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.linkedin,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['linkedin'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.github,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['github'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.facebook,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['facebook'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2.0,
                                                    right: 2,
                                                    top: 5,
                                                    bottom: 4),
                                                child: FaIcon(
                                                  FontAwesomeIcons.link,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['website'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ]),
                                );
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
                              .collection('relatedWebsites')
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
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          'More Informations',
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: blackColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.linkedin,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['linkedin'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.github,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['github'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.facebook,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['facebook'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2.0,
                                                    right: 2,
                                                    top: 5,
                                                    bottom: 4),
                                                child: FaIcon(
                                                  FontAwesomeIcons.link,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['website'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ]),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      )
                    
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "More Informations",
                            style: TextStyle(
                                fontSize: 24,
                                color: blackColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.linkedin,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Text(
                                  "Not answered",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.github,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Text(
                                  "Not answered",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.facebook,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Text(
                                  "Not answered",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 2.0, right: 2, top: 5, bottom: 4),
                                  child: FaIcon(
                                    FontAwesomeIcons.link,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Text(
                                  "Not answered",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              )
                            ],
                          ),
                        ]),
                  ),
            widget.userId == FirebaseAuth.instance.currentUser!.uid
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                              const AddWebsites()));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(blackColor),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(12)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  hasRelatedWebsites ? "Edit" : "Add Websites",
                                  style: const TextStyle(
                                      fontSize: 19, color: whiteColor),
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
                : const SizedBox(
                    height: 1,
                  )
          ],
        ),
      ),
    );
  }
}
