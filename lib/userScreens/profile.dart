import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/screen/login.dart';
import 'package:tp_dev_mobile/shared/profilecard.dart';
import 'package:tp_dev_mobile/userScreens/resume/resume.dart';
import 'package:tp_dev_mobile/userScreens/skills/skills.dart';
import 'package:tp_dev_mobile/userScreens/websites/websites.dart';
import 'package:tp_dev_mobile/userScreens/work_experience/show_works.dart';

class Profile extends StatefulWidget {
  final profileUid;
  const Profile({super.key, required this.profileUid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map profileData = {};
  bool isLoodingProfilePage = true;

  getData() async {
    setState(() {
      isLoodingProfilePage = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('condidat')
          .doc(widget.profileUid)
          .get();

      profileData = snapshot.data()!;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoodingProfilePage = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    final credential = FirebaseAuth.instance.currentUser;

    return isLoodingProfilePage
        ? const Scaffold(
            backgroundColor: whiteColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              leading:
                  widget.profileUid == FirebaseAuth.instance.currentUser!.uid
                      ? const Icon(
                          Icons.arrow_back,
                          color: blackColor,
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: blackColor,
                          )),
              elevation: 0.7,
              backgroundColor: whiteColor,
              title: const Text(
                "Profile",
                style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
            ),
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 225, 225, 225),
                          radius: 55,
                          backgroundImage: NetworkImage(
                            profileData['profileImg'],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profileData['name'],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          color: greyColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          profileData['email'],
                          // UserData["email"],
                          style: const TextStyle(fontSize: 18, color: greyColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    ProfileCard(
                        title: "Work Experience",
                        icon: Icons.work_outline_outlined,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowWorks(
                                        userId: widget.profileUid,
                                      )));
                        }),
                    ProfileCard(
                        title: "Skills",
                        icon: Icons.light_mode_outlined,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Skills(
                                        userId: widget.profileUid,
                                      )));
                        }),
                    ProfileCard(
                        title: "Resume",
                        icon: Icons.format_list_bulleted_sharp,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Resume(
                                        userId: widget.profileUid,
                                      )));
                        }),
                    ProfileCard(
                        title: "Websites",
                        icon: Icons.insert_link_rounded,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Websites(
                                        userId: widget.profileUid,
                                      )));
                        }),
                    widget.profileUid == FirebaseAuth.instance.currentUser!.uid
                        ? ProfileCard(
                            title: "Dark Mode",
                            icon: Icons.light_mode_outlined,
                            onPressed: () {})
                        : const SizedBox(
                            height: 1,
                          ),
                    widget.profileUid == FirebaseAuth.instance.currentUser!.uid
                        ? ProfileCard(
                            title: "Help Support",
                            icon: Icons.help_center_outlined,
                            onPressed: () {})
                        : const SizedBox(
                            height: 1,
                          ),
                    widget.profileUid == FirebaseAuth.instance.currentUser!.uid
                        ? ProfileCard(
                            title: "Log out",
                            icon: Icons.logout,
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if(!mounted)return;
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Login()), (route) => false);
                            })
                        : const SizedBox(
                            height: 1,
                          ),
                    widget.profileUid == FirebaseAuth.instance.currentUser!.uid
                        ? InkWell(
                            onTap: () {
                              credential!.delete();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 28,
                                        color: Colors.red.shade400,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Delete Account',
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.red.shade400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 1,
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}
