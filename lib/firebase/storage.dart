import 'package:firebase_storage/firebase_storage.dart';

getImgURL({required imgName, required imgPath}) async {
  // Upload image to firebase storage
  final storageRef = FirebaseStorage.instance.ref("UserImages/$imgName");
  await storageRef.putFile(imgPath!);

// Get img url
  String url = await storageRef.getDownloadURL();

  return url;
}
