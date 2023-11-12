import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';


class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        title: const Text(
          "Notifications",
          style: TextStyle(
              color: blackColor, fontWeight: FontWeight.w700, fontSize: 24),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "You don't have any notifications",
              style: TextStyle(fontSize: 17, color: blackColor),
            ),
            // SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    ));
  }
}
