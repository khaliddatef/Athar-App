import 'package:flutter/material.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({super.key});

  // هنا نعمل قائمة من المهام
  final List<Map<String, String>> tasks = const [
    {"title": "منطقة كفر الدوار السكنية", "time": "AM 10:00"},
    {"title": "حي العمال - شارع 9", "time": "PM 2:30"},
    {"title": "شارع التحرير - مكتب البريد", "time": "PM 4:00"},
    // ممكن تضيفي أي عدد من المهام هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "مهام اليوم",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        // نستخدم ListView.builder داخل Container مع ارتفاع محدد
        SizedBox(
          height: 300, // ضبطي الارتفاع حسب الحاجة
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TaskCard(title: task["title"]!, time: task["time"]!),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String time;

  const TaskCard({super.key, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
          Text(time, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
