import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/shared/emptytfield.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class WorkExperience extends StatefulWidget {
  const WorkExperience({super.key});

  @override
  State<WorkExperience> createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperience> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isPicking = false;
  bool isPicking2 = false;
  final titleWorkController = TextEditingController();
  final companyController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
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
            "Work Experience",
            style: TextStyle(
                color: blackColor, fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    EmptyTextField(
                      title: "Title",
                      controller: titleWorkController,
                    ),
                    EmptyTextField(
                      title: "Company",
                      controller: companyController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start date",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: blackColor),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: () async {
                                DateTime? newStartDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (newStartDate == null) return;

                                setState(() {
                                  isPicking = true;
                                  startDate = newStartDate;
                                });
                              },
                              child: Container(
                                height: 48,
                                width: MediaQuery.sizeOf(context).width * 0.43,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: blackColor, width: 0.6),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                    child: isPicking
                                        ? Text(
                                            "${startDate.day}/${startDate.month}/${startDate.year}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : const Text("")),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "End date",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: blackColor),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: () async {
                                DateTime? newEndtDate = await showDatePicker(
                                    context: context,
                                    initialDate: endDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (newEndtDate == null) return;

                                setState(() {
                                  isPicking2 = true;
                                  endDate = newEndtDate;
                                });
                              },
                              child: Container(
                                height: 48,
                                width: MediaQuery.sizeOf(context).width * 0.43,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: blackColor, width: 0.6),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                    child: isPicking2
                                        ? Text(
                                            "${endDate.day}/${endDate.month}/${endDate.year}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : const Text("")),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: blackColor),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.6, // Border width
                                ),
                                borderRadius:
                                    BorderRadius.circular(15), // Border radius
                              ),
                              height: 150,
                              child: TextField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                              if (titleWorkController.text.isNotEmpty &&
                                  companyController.text.isNotEmpty &&
                                  descriptionController.text.isNotEmpty) {
                                String workId = const Uuid().v1();
                                await FirebaseFirestore.instance
                                    .collection('condidat')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('myWork')
                                    .doc(workId)
                                    .set({
                                  "titleWork": titleWorkController.text,
                                  "compagnyname": companyController.text,
                                  "startDate": startDate,
                                  "endDate": endDate,
                                  "description": descriptionController.text,
                                  "uid": FirebaseAuth.instance.currentUser!.uid,
                                  "workid": workId,
                                });

                                titleWorkController.clear();
                                companyController.clear();
                                descriptionController.clear();

                                if (!mounted) return;
                                showSnackBar(context, 'Experience uploded');
                              } else {
                                showSnackBar(context, 'Not Added');
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
