import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String name;
  String? selectedRole;
  String email;
  String password;
  String profileImg;
  String uid;

  UserData(
      {required this.name,
      required this.selectedRole,
      required this.email,
      required this.password,
      required this.profileImg,
      required this.uid});

  Map<String, dynamic> convert2Map() {
    return {
      'name': name,
      'selectedRole': selectedRole,
      'email': email,
      'password': password,
      'profileImg': profileImg,
      'uid': uid,
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      name: snapshot["name"],
      selectedRole: snapshot["selectedRole"],
      email: snapshot["email"],
      password: snapshot["password"],
      profileImg: snapshot["profileImg"],
      uid: snapshot["uid"],
    );
  }
}
