import 'package:cloud_firestore/cloud_firestore.dart';

class JobsData {
  final String compagnyname;
  final String compagnyImg;
  final String title;
  final String salary;
  final String type;
  final String description;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final List applicants;

  JobsData({
    required this.compagnyname,
    required this.compagnyImg,
    required this.title,
    required this.salary,
    required this.type,
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.applicants,
  });

  Map<String, dynamic> convert2Map() {
    return {
      'compagnyname': compagnyname,
      'compagnyImg': compagnyImg,
      'title': title,
      'salary': salary,
      'type': type,
      'description': description,
      'uid': uid,
      'postId': postId,
      'datePublished': datePublished,
      'applicants': applicants,
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return JobsData(
      compagnyname: snapshot["compagnyname"],
      compagnyImg: snapshot["compagnyImg"],
      title: snapshot["title"],
      salary: snapshot["salary"],
      type: snapshot["type"],
      description: snapshot["description"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      applicants: snapshot["applicants"],
    );
  }
}
