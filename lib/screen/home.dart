import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/provider/provider.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';

class Home extends StatefulWidget {
  final visiteur;
  const Home({super.key, required this.visiteur});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _allResult = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var jobSnapshot in _allResult) {
        var title = jobSnapshot['title'].toString().toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(jobSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResult);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  getJobsStream() async {
    var data = await FirebaseFirestore.instance
        .collection('jobs')
        .orderBy('title')
        .get();

    setState(() {
      _allResult = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getJobsStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                allDataFromDB!.profileImg,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: CupertinoSearchTextField(
                controller: _searchController,
                prefixIcon: const Icon(
                  Icons.search,
                  color: whiteColor,
                ),
                style: const TextStyle(color: whiteColor),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
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
                      InkResponse(
                        onTap: () {
                          if (allDataFromDB.selectedRole == 'User') {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.8,
                                    child: Scaffold(
                                      appBar: AppBar(
                                        elevation: 0.6,
                                        backgroundColor: tFieldgreyColor,
                                        leading: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Icon(
                                            Icons.arrow_back,
                                            color: blackColor,
                                          ),
                                        ),
                                        title: const Text(
                                          "Job Details",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: blackColor),
                                        ),
                                        actions: const [
                                          Icon(
                                            Icons.share,
                                            color: blackColor,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          )
                                        ],
                                      ),
                                      body: SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Text(
                                                  _resultList[index]['title'],
                                                  // data['title'],
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'myFont'),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      _resultList[index]
                                                          ['compagnyname'],
                                                      // data['compagnyname'],
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${_resultList[index]['applicants'].length} ${_resultList[index]['applicants'].length > 1 ? 'applicants' : 'applicant'}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .green.shade400),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .work_history_outlined,
                                                        color: blackColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "Job Type : ${_resultList[index]['type']}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors
                                                                .red.shade300,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'posted ${DateFormat('yMd').format(_resultList[index]['datePublished'].toDate())}',
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: greyColor),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "About Job",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color:
                                                          Colors.blue.shade500),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0),
                                                  child: Text(
                                                    _resultList[index]
                                                        ['description'],
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: blackColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      bottomNavigationBar: BottomAppBar(
                                        color: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('jobs')
                                                        .doc(_resultList[index]
                                                            ['postId'])
                                                        .collection(
                                                            "appliedPeople")
                                                        .doc(allDataFromDB.uid)
                                                        .set({
                                                      'profileImg':
                                                          allDataFromDB
                                                              .profileImg,
                                                      'name':
                                                          allDataFromDB.name,
                                                      'email':
                                                          allDataFromDB.email,
                                                      'uid': allDataFromDB.uid,
                                                      'newAppliedId':
                                                          allDataFromDB.uid,
                                                    });
                                                    //add applicant with special uid
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('jobs')
                                                          .doc(
                                                              _resultList[index]
                                                                  ['postId'])
                                                          .update({
                                                        "applicants": FieldValue
                                                            .arrayUnion([
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                        ]),
                                                      });
                                                      if (!mounted) return;
                                                      showSnackBar(context,
                                                          " Applied Succefully ❤️");
                                                    } catch (e) {
                                                      if (!mounted) return;
                                                      showSnackBar(context,
                                                          " Already Applied 😒");
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.black),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                                const EdgeInsets
                                                                    .all(8)),
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8))),
                                                  ),
                                                  child: const Text(
                                                    "Aplly Now",
                                                    style:
                                                        TextStyle(fontSize: 19),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                _resultList[index]['compagnyImg'],
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _resultList[index]['compagnyname'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: greyColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    _resultList[index]['title'],
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  _resultList[index]['type'],
                                  style: const TextStyle(
                                      color: greyColor, fontSize: 13),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  _resultList[index]['salary'] +
                                      " dt per month",
                                  style: const TextStyle(
                                      color: greyColor, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (allDataFromDB.selectedRole == 'User') {
                                await FirebaseFirestore.instance
                                    .collection('condidat')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('SavedJobs')
                                    .doc(_resultList[index]['postId'])
                                    .set({
                                  'compagnyname': _resultList[index]
                                      ['compagnyname'],
                                  'title': _resultList[index]['title'],
                                  'type': _resultList[index]['type'],
                                  'salary': _resultList[index]['salary'],
                                  'datePublished': _resultList[index]
                                      ['datePublished'],
                                  'postId': _resultList[index]['postId'],
                                });
                                if (!mounted) return;
                                showSnackBar(context, 'Job Saved');
                                setState(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.bookmark_outline,
                              size: 28,
                              color: greyColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            DateFormat('Md').format(
                                _resultList[index]['datePublished'].toDate()),
                            style: const TextStyle(color: greyColor),
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
        },
      ),
    );
  }
}
