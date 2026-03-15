import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage("assets/images/image_face.png"),
        ),

        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "مرحباً أحمد",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("متطوع", style: TextStyle(color: Colors.grey)),
          ],
        ),
        const Spacer(),

        const Icon(Icons.notifications_none),
      ],
    );
  }
}
