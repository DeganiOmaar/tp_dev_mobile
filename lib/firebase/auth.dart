import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp_dev_mobile/firebase/storage.dart';
import 'package:tp_dev_mobile/model/user.dart';

class AuthMethods {
  register({
    required email,
    required password,
    required context,
    required name,
    required selectedRole,
    required imgName,
    required imgPath,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String urlImage = await getImgURL(imgName: imgName, imgPath: imgPath);

      // firestore (database)
      CollectionReference users =
          FirebaseFirestore.instance.collection('condidat');

      UserData condidats = UserData(
        name: name,
        selectedRole: selectedRole,
        email: email,
        password: password,
        profileImg: urlImage,
        uid: credential.user!.uid,
      );

      users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(condidats.convert2Map())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  // functoin to get user details from Firestore (Database)
  Future<UserData> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('condidat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserData.convertSnap2Model(snap);
  }

  signIn({required email, required password, required context}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
