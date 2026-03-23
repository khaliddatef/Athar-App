import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int currentIndex = 3;

  final List<IconData> icons = [
    Icons.person,
    Icons.chat_bubble_outline,
    Icons.map_outlined,
    Icons.home_outlined,
  ];

  final List<String> labels = ["حسابي", "محادثاتي", "الخريطة", "الرئيسية"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          icons.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                currentIndex = index;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[index],
                  color: currentIndex == index ? Colors.green : Colors.grey,
                ),

                const SizedBox(height: 4),

                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: currentIndex == index ? Colors.green : Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                // indicator
                Container(
                  height: 3,
                  width: 20,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.green
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
