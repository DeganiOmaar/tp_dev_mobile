import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/compagnyScreens/applicants.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/screen/login.dart';
import 'package:tp_dev_mobile/shared/job_design.dart';

class ProfileCompagny extends StatefulWidget {
  const ProfileCompagny({super.key});

  @override
  State<ProfileCompagny> createState() => _ProfileCompagnyState();
}

class _ProfileCompagnyState extends State<ProfileCompagny> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.8,
          backgroundColor: whiteColor,
          title: const Text(
            "Profile",
            style: TextStyle(
                color: blackColor, fontWeight: FontWeight.w700, fontSize: 24),
          ),
          actions: [
            InkResponse(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if(!mounted)return;
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Login()), (route) => false);
                },
                child: const Icon(
                  Icons.logout,
                  color: blackColor,
                )),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .where("uid",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: blackColor));
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      if (snapshot.hasData) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Applicant(data: data)));
                            },
                            child: JobDesign(data: data));
                      } else {
                        return Container();
                      }
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
