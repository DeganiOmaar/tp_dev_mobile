import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp_dev_mobile/model/job.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploadJob({
    required compagnyImg,
    required compagnyname,
    required title,
    required salary,
    required type,
    required description,
    required context,
  }) async {
    try {
      // firestore (database)
      CollectionReference users = FirebaseFirestore.instance.collection('jobs');

      String newId = const Uuid().v1();

      JobsData work = JobsData(
          compagnyImg: compagnyImg,
          compagnyname: compagnyname,
          title: title,
          salary: salary,
          type: type,
          description: description,
          uid: FirebaseAuth.instance.currentUser!.uid,
          postId: newId,
          datePublished: DateTime.now(),
          applicants: []);

      users
          .doc(newId)
          .set(work.convert2Map())
          .then((value) => print("job Added"))
          .catchError((error) => print("Failed to add job: $error"));
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}
