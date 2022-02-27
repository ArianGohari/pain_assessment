import 'package:painlab_app/model/task.dart';

class Section<T extends Task> {
  final String title;
  final String? subtitle;
  final List<T> tasks;

  Section({required this.title, required this.subtitle, required this.tasks});
}