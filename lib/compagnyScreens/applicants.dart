import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/userScreens/profile.dart';

class Applicant extends StatefulWidget {
  final Map data;
  const Applicant({super.key, required this.data});

  @override
  State<Applicant> createState() => _ApplicantState();
}

class _ApplicantState extends State<Applicant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Job Applicants",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Click to see Applicant Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('jobs')
                      .doc(widget.data['postId'])
                      .collection('appliedPeople')
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

                    return GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 3.5,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    InkResponse(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Profile(
                                                      profileUid: data['uid'],
                                                    )));
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(
                                              data['profileImg'],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            data['name'],
                                            // "Degani Omar",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            data['email'],
                                            // 'deganiomar2001@gmail.com',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
