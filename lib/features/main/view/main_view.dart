import 'package:flutter/material.dart';
import 'package:sanad/features/home/view/home_screen.dart';

// الشاشة الرئيسية اللي هتحوي كل البوتوم ناف والشاشات
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
     const HomeScreen(),
     const MapScreen(),
     const ChatScreen(),
    const AccountScreen(),
    
    
   
  ];

  final List<IconData> icons = [
      Icons.home_outlined,
       Icons.map_outlined,
         Icons.chat_bubble_outline,
    Icons.person,
  
   
  
  ];

  final List<String> labels = [
      "الرئيسية",
       "الخريطة",
         "محادثاتي",
    "حسابي",
  
   
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
            )
          ],
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

// =====================
// الشاشات المختلفة
// =====================

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حسابي")),
      body: const Center(child: Text("هذه شاشة حسابي")),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("محادثاتي")),
      body: const Center(child: Text("هذه شاشة المحادثات")),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الخريطة")),
      body: const Center(child: Text("هذه شاشة الخريطة")),
    );
  }
}

