import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tp_dev_mobile/constant.dart';
import 'package:tp_dev_mobile/firebase/auth.dart';
import 'package:tp_dev_mobile/screen/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisable = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  // signIn() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await AuthMethods().signIn(
  //       email: emailController.text,
  //       password: passwordController.text,
  //       context: context);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(33.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 32, fontFamily: 'myFont'),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                "Login to your account now",
                style: TextStyle(color: greyColor, fontSize: 18),
              ),
              const SizedBox(
                height: 64,
              ),
              Container(
                decoration: BoxDecoration(
                    color: tFieldgreyColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: TextField(
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
                      hintText: "Enter Your Email : ",
                      hintStyle: TextStyle(color: greyColor, fontSize: 17),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              Container(
                decoration: BoxDecoration(
                    color: tFieldgreyColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: isVisable ? false : true,
                    style: const TextStyle(color: blackColor),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisable = !isVisable;
                          });
                        },
                        icon: isVisable
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        color: greyColor,
                      ),
                      hintText: "Enter Your Password : ",
                      hintStyle:
                          const TextStyle(color: greyColor, fontSize: 17),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot password?",
                        style: TextStyle(fontSize: 18, color: blackColor)),
                  ),
                ],
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
                        setState(() {
                          isLoading = true;
                        });
                        await AuthMethods().signIn(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blackColor),
                        padding: isLoading
                            ? MaterialStateProperty.all(const EdgeInsets.all(5))
                            : MaterialStateProperty.all(
                                const EdgeInsets.all(13)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign in",
                              style: TextStyle(fontSize: 19),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Or Sign Up with",
                    style: TextStyle(fontSize: 16, color: greyColor),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 27),
                    child: GestureDetector(
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
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 27),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                // color: Colors.purple,
                                color: const Color.fromARGB(255, 44, 130, 228),
                                width: 1)),
                        child: SvgPicture.asset(
                          "assets/icons/facebook.svg",
                          // color: Color.fromARGB(255, 121, 149, 228),
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 27),
                    child: GestureDetector(
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
                  ),
                ],
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
                              builder: (context) => const Register()),
                        );
                      },
                      child: const Text('sign up',
                          style: TextStyle(fontSize: 18, color: blackColor))),
                ],
              ),
            ]),
      ),
    )));
  }
}
