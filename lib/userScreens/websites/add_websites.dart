import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/shared/emptytfield.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class AddWebsites extends StatefulWidget {
  const AddWebsites({super.key});

  @override
  State<AddWebsites> createState() => _AddWebsitesState();
}

final linkedinController = TextEditingController();
final githubController = TextEditingController();
final facebookController = TextEditingController();
final websiteController = TextEditingController();

class _AddWebsitesState extends State<AddWebsites> {
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
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    EmptyTextField(
                      title: 'Linkedin Profile URL',
                      controller: linkedinController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EmptyTextField(
                      title: "Github Profile URL",
                      controller: githubController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EmptyTextField(
                      title: "Facebook Profile URL",
                      controller: facebookController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EmptyTextField(
                      title: "Website URL",
                      controller: websiteController,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (linkedinController.text.isNotEmpty &&
                                  facebookController.text.isNotEmpty &&
                                  githubController.text.isNotEmpty &&
                                  websiteController.text.isNotEmpty) {
                                String newRelatedWebsites = const Uuid().v1();

                                await FirebaseFirestore.instance
                                    .collection('condidat')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('relatedWebsites')
                                    .doc(newRelatedWebsites)
                                    .set({
                                  'linkedin': linkedinController.text,
                                  'facebook': facebookController.text,
                                  'github': githubController.text,
                                  'website': websiteController.text,
                                  'relatedWebsitesId': newRelatedWebsites,
                                  "uid": FirebaseAuth.instance.currentUser!.uid,
                                });

                                linkedinController.clear();
                                facebookController.clear();
                                githubController.clear();
                                websiteController.clear();
                                if (!mounted) return;
                                showSnackBar(context, "Added");
                              } else {
                                showSnackBar(
                                    context, "Add a valid websiteLink");
                              }
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
                            child: const Text(
                              "Save",
                              style: TextStyle(fontSize: 19, color: whiteColor),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
