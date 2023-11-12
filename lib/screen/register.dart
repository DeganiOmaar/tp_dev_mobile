// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/firebase/auth.dart';
import 'package:tp_dev_mobile/screen/login.dart';
import 'package:tp_dev_mobile/screen/screens.dart';
import 'package:tp_dev_mobile/shared/snackbar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isVisable = true;
  File? imgPath;
  String? imgName;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  String? selectedRole; // Default selected role is 'User'

  uploadImage2Screen(ImageSource source) async {
    Navigator.pop(context);
    final XFile? pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        if (!mounted) return;
        showSnackBar(context, 'NO img selected');
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, "Error => $e");
    }
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  clickOnRegister() async {
    if (_formKey.currentState!.validate() &&
        imgName != null &&
        imgPath != null) {
      setState(() {
        isLoading = true;
      });
      await AuthMethods().register(
          email: emailController.text,
          password: passwordController.text,
          context: context,
          name: nameController.text,
          selectedRole: selectedRole,
          imgName: imgName,
          imgPath: imgPath);
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserScreen()),
      );
    } else {
      showSnackBar(context, "ERROR");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello!',
                    style: TextStyle(fontSize: 32, fontFamily: 'myFont'),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    "Please fill in to sign up new account",
                    style: TextStyle(color: greyColor, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(125, 78, 91, 110),
                        ),
                        child: Stack(
                          children: [
                            imgPath == null
                                ? const CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 225, 225, 225),
                                    radius: 45,
                                    // backgroundImage: AssetImage("assets/img/avatar.png"),
                                    backgroundImage:
                                        AssetImage("assets/images/avatar.png"),
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      imgPath!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Positioned(
                              left: 56,
                              bottom: -10,
                              child: IconButton(
                                onPressed: () {
                                  // uploadImage2Screen();
                                  showmodel();
                                },
                                iconSize: 19,
                                icon: const Icon(Icons.add_a_photo),
                                color: const Color.fromARGB(255, 94, 115, 128),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: tFieldgreyColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: TextFormField(
                        validator: (value) {
                          return value!.isEmpty ? 'Can not be Empty ' : null;
                        },
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: blackColor),
                        decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Full Name",
                            suffixIcon: Icon(
                              Icons.person_2,
                              color: greyColor,
                            ),
                            hintStyle:
                                TextStyle(color: greyColor, fontSize: 17)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: tFieldgreyColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: TextFormField(
                        // we return "null" when something is valid
                        validator: (email) {
                          return email!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                              ? null
                              : "Enter a valid email";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        style: const TextStyle(color: blackColor),
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.email,
                            color: greyColor,
                          ),
                          hintText: "Enter Your Email :",
                          hintStyle: TextStyle(color: greyColor, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: tFieldgreyColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: TextFormField(
                        onChanged: (password) {},
// we return "null" when something is valid
                        validator: (value) {
                          return value!.length < 8
                              ? "Enter at least 8 characters"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: isVisable ? true : false,

                        style: const TextStyle(color: blackColor),
                        decoration: InputDecoration(
                          hintStyle:
                              const TextStyle(color: greyColor, fontSize: 17),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Enter Your Password :",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisable = !isVisable;
                              });
                            },
                            icon: isVisable
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: tFieldgreyColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: greyColor, fontSize: 17),
                        onChanged: (newValue) {
                          setState(() {
                            selectedRole = newValue!;
                          });
                        },
                        items: <String>['User', 'Compagny']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await clickOnRegister();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(blackColor),
                            padding: isLoading
                                ? MaterialStateProperty.all(
                                    const EdgeInsets.all(5))
                                : MaterialStateProperty.all(
                                    const EdgeInsets.all(13)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Register",
                                  style: TextStyle(fontSize: 19),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  // color: Colors.purple,
                                  color: const Color.fromARGB(255, 200, 67, 79),
                                  width: 1)),
                          child: SvgPicture.asset(
                            "assets/icons/google.svg",
                            color: const Color.fromARGB(255, 200, 67, 79),
                            height: 24,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  // color: Colors.purple,
                                  color:
                                      const Color.fromARGB(255, 44, 130, 228),
                                  width: 1)),
                          child: SvgPicture.asset(
                            "assets/icons/facebook.svg",
                            // color: Color.fromARGB(255, 121, 149, 228),
                            height: 24,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  // color: Colors.purple,
                                  color: const Color.fromARGB(255, 5, 5, 5),
                                  width: 1)),
                          child: SvgPicture.asset(
                            "assets/icons/apple.svg",
                            color: const Color.fromARGB(255, 7, 7, 7),
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do not have an account?",
                          style: TextStyle(fontSize: 18, color: greyColor)),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: const Text('sign in',
                              style:
                                  TextStyle(fontSize: 18, color: blackColor))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
