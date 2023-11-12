
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/screen/pdf_api.dart';
import 'package:tp_dev_mobile/screen/pdfviewer.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';


class Resume extends StatefulWidget {
  final userId;
  const Resume({super.key, required this.userId});

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  PlatformFile? pickedFile;

  Future uploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });

    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(pickedFile!.name);
    ref.putFile(file);

    return pickedFile!.name;
  }

  bool hasRelatedResume = false;

  void checkResume() {
    FirebaseFirestore.instance
        .collection('condidat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('resume')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        hasRelatedResume = querySnapshot.docs.isNotEmpty;
      });
    }).catchError((error) {
      // Handle any potential errors
    });
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)));

  @override
  void initState() {
    super.initState();
    checkResume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            )),
        centerTitle: true,
        title: const Text(
          "Resume Options",
          style: TextStyle(
              color: blackColor, fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Uploading your resume is easy!",
                  style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Upload a file (PDF, Word, Text)",
                  style: TextStyle(color: greyColor, fontSize: 18),
                ),
              ],
            ),
            widget.userId == FirebaseAuth.instance.currentUser!.uid
                ? hasRelatedResume
                    ? const SizedBox(
                        height: 220,
                      )
                    : const SizedBox(
                        width: 1,
                      )
                : const SizedBox(
                    height: 220,
                  ),
            widget.userId == FirebaseAuth.instance.currentUser!.uid
                ? hasRelatedResume
                    ? Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('condidat')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('resume')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: blackColor,
                              );
                            }
                            return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                if (snapshot.hasData) {
                                  return Row(
                                    children: [
                                      Text(
                                        data['resumeName'],
                                        style: const TextStyle(
                                            color: blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      const Spacer(),
                                      InkResponse(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('condidat')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection('resume')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .delete();
                                          if (!mounted) return;
                                          showSnackBar(
                                              context, 'Resume Deleted');
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade400,
                                        ),
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
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: SvgPicture.asset(
                            "assets/icons/resume.svg",
                            height: 180,
                            color: const Color.fromARGB(255, 232, 232, 232),
                          ),
                        ),
                      )
                : Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('condidat')
                          .doc(widget.userId)
                          .collection('resume')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: blackColor,
                          );
                        }
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  Text(
                                    data['resumeName'],
                                    style: const TextStyle(
                                        color: blackColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        decoration: TextDecoration.underline),
                                  ),
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
            widget.userId == FirebaseAuth.instance.currentUser!.uid
                ? hasRelatedResume
                    ? const Spacer()
                    : const SizedBox(
                        height: 1,
                      )
                : const Spacer(),
            widget.userId == FirebaseAuth.instance.currentUser!.uid
                ? hasRelatedResume
                    ? const SizedBox(
                        height: 130,
                      )
                    : const SizedBox(
                        height: 1,
                      )
                : const SizedBox(
                    height: 125,
                  ),
            widget.userId == FirebaseAuth.instance.currentUser!.uid
                ? hasRelatedResume
                    ? Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('condidat')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('resume')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: blackColor,
                              );
                            }
                            return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () async {
                                                final url = data['resumeName'];
                                                final file =
                                                    await PDFApi.loadFirebase(
                                                        url);
                                                if (file == null) return;
                                                if (!mounted) return;
                                                openPDF(context, file);
                                              },
                                              icon: const Icon(
                                                Icons.phone_android_rounded,
                                                color: whiteColor,
                                                size: 22.0,
                                              ),
                                              label: const Text(
                                                "View Resume",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: whiteColor),
                                              ),
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
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
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
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    String resumeUrl = await uploadFile();
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('condidat')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('resume')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set({
                                        'resumeName': resumeUrl,
                                      });
                                      if (!mounted) return;
                                      showSnackBar(context, 'Resume Uploaded');
                                    } catch (e) {
                                      if (!mounted) return;
                                      showSnackBar(context, ' Failed');
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.phone_android_rounded,
                                    color: whiteColor,
                                    size: 22.0,
                                  ),
                                  label: const Text(
                                    "Upload File",
                                    style: TextStyle(
                                        fontSize: 18, color: whiteColor),
                                  ),
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
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                : Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('condidat')
                          .doc(widget.userId)
                          .collection('resume')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: blackColor,
                          );
                        }
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            final url = data['resumeName'];
                                            final file =
                                                await PDFApi.loadFirebase(url);
                                            if (file == null) return;
                                            if (!mounted) return;
                                            openPDF(context, file);
                                          },
                                          icon: const Icon(
                                            Icons.phone_android_rounded,
                                            color: whiteColor,
                                            size: 22.0,
                                          ),
                                          label: const Text(
                                            "View Resume",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: whiteColor),
                                          ),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
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
          ],
        ),
      ),
    );
  }
}
