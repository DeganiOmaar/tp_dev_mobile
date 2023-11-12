import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  const ProfileCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_circle_right_outlined,
              size: 28,
            )
          ],
        ),
      ),
    );
  }
}
