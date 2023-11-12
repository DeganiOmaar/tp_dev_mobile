import 'package:flutter/material.dart';

class TField extends StatelessWidget {
  final String title;
  final String hinttext;
  final IconData icon;
  final bool isPassword;
  final TextEditingController myController;
  final String? Function(String?)? validator;
  const TField(
      {super.key,
      required this.title,
      required this.hinttext,
      required this.icon,
      required this.isPassword,
      required this.myController,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          controller: myController,
          obscureText: isPassword,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 0.7,
                color: Color.fromARGB(255, 189, 189, 189),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 1.2,
                color: Color.fromARGB(255, 189, 189, 189),
              ),
            ),
            suffixIcon: Icon(
              icon,
              color: Colors.grey[400],
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
