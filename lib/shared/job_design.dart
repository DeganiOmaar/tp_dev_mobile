import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';


class JobDesign extends StatefulWidget {
  final Map data;
  const JobDesign({super.key, required this.data});

  @override
  State<JobDesign> createState() => _JobDesignState();
}

class _JobDesignState extends State<JobDesign> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        widget.data['compagnyImg'],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['compagnyname'],
                          style: const TextStyle(
                              fontSize: 17,
                              color: greyColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            widget.data['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          // 'remote',
                          widget.data['type'],
                          style: const TextStyle(color: greyColor, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.data['salary'] + " dt per month",
                          // '${widget.data['applicants']}    ${widget.data['applicants'].length >1 ? 'applicant' : 'applicants'}',
                          style: const TextStyle(color: greyColor, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    widget.data['applicants'].length > 0
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.green.shade400),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 3, left: 7, right: 7, bottom: 3),
                              child: Text(
                                widget.data['applicants'].length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                    const SizedBox(height: 45),
                    InkResponse(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('jobs')
                            .doc(widget.data['postId'])
                            .delete();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red.shade400,
                      ),
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
    );
  }
}
