import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({super.key});

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.7,
          backgroundColor: whiteColor,
          title: const Text(
            "Saved Jobs",
            style: TextStyle(
                color: blackColor, fontWeight: FontWeight.w700, fontSize: 24),
          ),
        ),
        body: SizedBox(
          child: Column(
            children: [
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('condidat')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('SavedJobs')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: blackColor,
                        ),
                      );
                    }

                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        if (snapshot.hasData) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, left: 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.business_outlined,
                                                size: 34,
                                                color: greyColor,
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['compagnyname'],
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color: greyColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      data['title'],
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    data['type'],
                                                    style: const TextStyle(
                                                        color: greyColor,
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    "${data['salary']} dt Per Month ",
                                                    style: const TextStyle(
                                                        color: greyColor,
                                                        fontSize: 15),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('condidat')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection('SavedJobs')
                                                    .doc(data['postId'])
                                                    .delete();
                                                if (!mounted) return;
                                                showSnackBar(
                                                    context, 'Unsaved ');
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                size: 28,
                                                color: Colors.red.shade300,
                                              ),
                                            ),
                                            const SizedBox(height: 32),
                                            Text(
                                              DateFormat('Md').format(
                                                  data['datePublished']
                                                      .toDate()),
                                              style:
                                                  const TextStyle(color: greyColor),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Text("No Job Saved For Now ");
                        }
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
