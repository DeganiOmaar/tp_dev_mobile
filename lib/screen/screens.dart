import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_dev_mobile/compagnyScreens/add_jobs.dart';
import 'package:tp_dev_mobile/compagnyScreens/compagnyprofile.dart';
import 'package:tp_dev_mobile/compagnyScreens/notif_compagny.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/provider/provider.dart';
import 'package:tp_dev_mobile/screen/home.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';
import 'package:tp_dev_mobile/userScreens/myjobs.dart';
import 'package:tp_dev_mobile/userScreens/notif.dart';
import 'package:tp_dev_mobile/userScreens/profile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // To get data from DB using provider
  getDataFromDB() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  Map UserData = {};
  bool isfinding = true;

  getData() async {
    setState(() {
      isfinding = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('condidat')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      UserData = snapshot.data()!;
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, e.toString());
    }
    // setState(() {
    //   isfinding = false;
    // }
    
    // );
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB();
    getData();
  }

  final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;
    return allDataFromDB == null
        ? const Scaffold(
            backgroundColor: whiteColor,
            body: Center(
              child: CircularProgressIndicator(
                color: blackColor,
              ),
            ),
          )
        : Scaffold(
            bottomNavigationBar: CupertinoTabBar(
                backgroundColor: blackColor,
                onTap: (index) {
                  // navigate to the tabed page
                  _pageController.jumpToPage(index);
                  setState(() {
                    currentPage = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.home_outlined,
                          color: currentPage == 0 ? Colors.white : Colors.grey,
                        ),
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: UserData['selectedRole'] == 'User'
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.bookmark_outline,
                                color: currentPage == 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add_circle_outline_outlined,
                                color: currentPage == 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: currentPage == 2 ? Colors.white : Colors.grey,
                        ),
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person_2_outlined,
                          color: currentPage == 3 ? Colors.white : Colors.grey,
                        ),
                      ),
                      label: ""),
                ]),
            body: PageView(
              onPageChanged: (index) {},
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Home(
                  visiteur: UserData['selectedRole'],
                ),
                UserData['selectedRole'] == 'User'
                    ? const MyJobs()
                    : const AddJobsCompagny(),
                UserData['selectedRole'] == 'User'
                    ? const Notifications()
                    : const NotificationsCompagny(),
                UserData['selectedRole'] == 'User'
                    ? Profile(
                        profileUid: FirebaseAuth.instance.currentUser!.uid,
                      )
                    : const ProfileCompagny(),
              ],
            ),
          );
  }
}
