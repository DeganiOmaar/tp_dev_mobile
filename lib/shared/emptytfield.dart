import 'package:flutter/material.dart';
import 'package:tp_dev_mobile/constant.dart';

class EmptyTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  const EmptyTextField(
      {super.key, required this.title, required this.controller});

  @override
  State<EmptyTextField> createState() => _EmptyTextFieldState();
}

class _EmptyTextFieldState extends State<EmptyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
                color: blackColor, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: greyColor),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
