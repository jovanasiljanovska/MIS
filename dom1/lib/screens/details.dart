import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;
  const ExamDetailScreen({super.key, required this.exam});

  String timeRemainingLabel() {
    final now = DateTime.now();
    Duration diff = exam.date.difference(now);

    if (diff.isNegative) {
      // Веќе поминат
      diff = now.difference(exam.date);
      final days = diff.inDays;
      final hours = diff.inHours % 24;
      return "Поминат пред: $days дена, $hours часа";
    } else {
      final days = diff.inDays;
      final hours = diff.inHours % 24;
      return "$days дена, $hours часа";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exam.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 8),
                Text("${exam.date}",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.meeting_room),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Простории: ${exam.classrooms.join(", ")}",
                      style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.timer),
                const SizedBox(width: 8),
                Text("Преостанато време: ${timeRemainingLabel()}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
