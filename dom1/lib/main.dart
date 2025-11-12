// lib/main.dart
import 'package:dom1/screens/details.dart';
import 'package:dom1/screens/list_exams.dart';
import 'package:flutter/material.dart';
import 'models/exam.dart';
import 'screens/list_exams.dart';

void main() {
  runApp(const ExamApp());
}

class ExamApp extends StatelessWidget {
  const ExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Распоред за испити",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) =>const ListScreen(),
        "/details": (context) {
        final exam = ModalRoute.of(context)!.settings.arguments as Exam;
        return ExamDetailScreen(exam: exam);
        },
      },
      debugShowCheckedModeBanner: false,
      home: const ListScreen(),
    );
  }
}
