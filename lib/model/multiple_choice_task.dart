import 'package:painlab_app/model/task.dart';

class MultipleChoiceTask extends Task {
  final String id;
  final String? topic;
  final String? optional;
  final List<Choice> choices;

  MultipleChoiceTask({
    required this.id,
    required this.topic,
    required this.optional,
    required String title,
    required this.choices,
  }) : super(title: title);

  void select(int index) {
    if(index > choices.length) throw IndexError(index, choices);

    result = choices[index].points;
  }

  void unselect(int index) {
    if(index > choices.length) throw IndexError(index, choices);
    if(result == choices[index].points) result = null;

  }

  @override
  String toCsv() {
    // TODO: implement toCsv
    throw UnimplementedError();
  }

  @override
  String toString() {
    // TODO: implement toString
    return {
      "id": id,
      "topic:": topic,
      "optional": optional,
      "title": title,
      "choices": choices,
    }.toString();
  }

}

class Choice {
  final String title;
  final int points;

  Choice({required this.title, required this.points});

  @override
  String toString() {
    return {
      "title": title,
      "points": points,
    }.toString();
  }
}