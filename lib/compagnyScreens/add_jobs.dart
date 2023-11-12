import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/firebase/firestore.dart';
import 'package:tp_dev_mobile/provider/provider.dart';
import 'package:tp_dev_mobile/shared/emptytfield.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';

class AddJobsCompagny extends StatefulWidget {
  const AddJobsCompagny({super.key});

  @override
  State<AddJobsCompagny> createState() => _AddJobsCompagnyState();
}

final titleController = TextEditingController();
final typeController = TextEditingController();
final salaryController = TextEditingController();
final descriptionController = TextEditingController();

bool isPosting = true;

class _AddJobsCompagnyState extends State<AddJobsCompagny> {
  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;
    return allDataFromDB == null
        ? const Center(
            child: CircularProgressIndicator(
              color: blackColor,
            ),
          )
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: whiteColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: whiteColor,
                title: const Text(
                  "Job Informations",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EmptyTextField(
                        title: "Title",
                        controller: titleController,
                      ),
                      EmptyTextField(
                        title: "Type",
                        controller: typeController,
                      ),
                      EmptyTextField(
                        title: "Salary per month",
                        controller: salaryController,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirestoreMethods().uploadJob(
                                      compagnyname: allDataFromDB.name,
                                      title: titleController.text,
                                      salary: salaryController.text,
                                      type: typeController.text,
                                      description: descriptionController.text,
                                      context: context,
                                      compagnyImg: allDataFromDB.profileImg);
                                  if (!mounted) return;
                                  showSnackBar(
                                      context, "Job Uploaded Succeflly 👌");

                                  titleController.clear();
                                  salaryController.clear();
                                  typeController.clear();
                                  descriptionController.clear();
                                } catch (e) {
                                  showSnackBar(context, "Not uploaded 😒");
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
                                "Add Job",
                                style:
                                    TextStyle(fontSize: 19, color: whiteColor),
                              ),
                            ),
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
