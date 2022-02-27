abstract class Task {
  final String title;
  int? result;

  Task({required this.title});

  String toCsv();
}