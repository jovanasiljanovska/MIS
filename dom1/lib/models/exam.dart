class Exam{
  String name;
  DateTime date;
  List<String> classrooms;

  Exam({
    required this.name,
    required this.date,
    required this.classrooms,
});

  bool get isPast => date.isBefore(DateTime.now());




}