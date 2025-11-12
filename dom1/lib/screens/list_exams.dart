import 'package:flutter/material.dart';
import '../models/exams_data.dart';
import '../widgets/exam_card.dart';
import '../models/exam.dart';

class ListScreen extends StatelessWidget{

  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Exam> sorted = [...exams]..sort((a,b)=>a.date.compareTo(b.date));

    const String index="221021";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Распоред за испити - ${index}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, i) {
                final exam = sorted[i];
                return ExamCard(exam: exam);
              },
            ),
          ),
          // Беџ за вкупен број испити
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.center,
              child: Chip(
                backgroundColor: Colors.blue.shade100,
                label: Text("Вкупно испити: ${sorted.length}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

