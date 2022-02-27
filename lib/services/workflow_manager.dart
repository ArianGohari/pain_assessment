import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:painlab_app/model/blocktapping_task.dart';
import 'package:painlab_app/model/multiple_choice_task.dart';
import 'package:painlab_app/model/section.dart';
import 'package:painlab_app/screens/blocktapping/blocktapping_screen.dart';
import 'package:painlab_app/screens/instruction/ending_screen.dart';
import 'package:painlab_app/screens/instruction/initial_screen.dart';
import 'package:painlab_app/screens/instruction/instruction_screen.dart';
import 'package:painlab_app/screens/multiple_choice/multiple_choice_screen.dart';
import 'package:painlab_app/screens/multiple_choice/range_choice_screen.dart';
import 'package:painlab_app/services/csv_writer.dart';

class WorkflowManager {
  static final WorkflowManager _instance = WorkflowManager._internal();
  factory WorkflowManager() => _instance;
  WorkflowManager._internal();

  static final Logger logger = Logger();
  Set<Section<MultipleChoiceTask>> _questionnaire = {};
  Set<Section<BlocktappingTask>> _blocktapping = {};
  final Set<Widget> _workflow = {};
  int _index = 0;
  String? _patientCode;

  Future _loadQuestionnaire() async {
    String questionnaireEncoded = await rootBundle.loadString("assets/json/questionnaire.json");
    Map<String, dynamic> questionnaireJson = await jsonDecode(questionnaireEncoded);
    Set<Section<MultipleChoiceTask>> questionnaire = {};

    for(Map<String, dynamic> sectionJson in questionnaireJson["sections"]) {
      List<MultipleChoiceTask> tasks = [];

      for(Map<String, dynamic> questionJson in sectionJson["questions"]) {
        List<Choice> choices = [];
        List<dynamic> titles = questionJson["choices"];

        for(int i = 0; i < titles.length; i++) {
          String title = titles[i];
          int points = questionJson["points"][i];
          choices.add(Choice(title: title, points: points));
        }

        tasks.add(MultipleChoiceTask(
          id: questionJson["id"],
          title: questionJson["title"],
          topic: questionJson.containsKey("topic") ? questionJson["topic"] : null,
          optional: questionJson.containsKey("optional") ? questionJson["optional"] : null,
          choices: choices,
        ));
      }

      questionnaire.add(
        Section<MultipleChoiceTask>(
          title: sectionJson["title"],
          subtitle: null,
          tasks: tasks,
        )
      );
    }

    _questionnaire = questionnaire;
  }

  Future _loadBlocktapping() async {
    String blocktappingEncoded = await rootBundle.loadString("assets/json/blocktapping.json");
    Map<String, dynamic> blocktappingJson = await jsonDecode(blocktappingEncoded);
    List<dynamic> levelsJson = blocktappingJson["levels"] as List<dynamic>;
    Set<Section<BlocktappingTask>> blocktapping = {};

    for(int i = 0; i < levelsJson.length; i++) {
      int level = i + 1;
      Map<String, dynamic> levelJson = levelsJson[i];

      List<int> seq1 = (levelJson["seq1"] as List).map((e) => e as int).toList();
      List<int> seq2 = (levelJson["seq2"] as List).map((e) => e as int).toList();

      blocktapping.add(
        Section(
          title: "Konzentrationsaufgabe",
          subtitle: "Level $level",
          tasks: [
            BlocktappingTask(
              title: "Level $level - Aufgabe 1",
              sequence: seq1,
            ),
            BlocktappingTask(
              title: "Level $level - Aufgabe 2",
              sequence: seq2,
            ),
          ],
        ),
      );
    }

    _blocktapping = blocktapping;
  }


  Section<BlocktappingTask> _blocktappingDemoSection() {
    return Section<BlocktappingTask>(
      title: "Beispiele",
      subtitle: "",
      tasks: <BlocktappingTask>[
        BlocktappingTask(
          title: "Beispiel 1",
          sequence: [1, 5],
        ),
        BlocktappingTask(
          title: "Beispiel 2",
          sequence: [3, 5, 6],
        ),
      ],
    );
  }

  List<Widget> _blocktappingDemo() {
    Section<BlocktappingTask> section = _blocktappingDemoSection();
    return <Widget>[
      BlocktappingScreen(
        demo: true,
        section: section,
        task: section.tasks[0],
      ),
      BlocktappingScreen(
        demo: true,
        section: section,
        task: section.tasks[1],
      ),
    ];
  }

  Future<Set<Widget>> loadWorkflow() async {
    log("before _loadQuestionnaire");
    await _loadQuestionnaire();
    log("before _loadBlocktapping");
    await _loadBlocktapping();
    log("after");

    List<Widget> multipleChoiceScreens = _questionnaire.map((section) {
      final List indices = Iterable<int>.generate(section.tasks.length).toList();
      return indices.map((i) {
        if(section.tasks[i].choices.length <= 5) {
          return MultipleChoiceScreen(
            backEnabled: true,
            title: "${section.title} ${i+1}/${section.tasks.length}",
            task: section.tasks[i],
          );
        }

        else {
          return RangeChoiceScreen(
            backEnabled: true,
            title: "${section.title} ${i+1}/${section.tasks.length}",
            task: section.tasks[i],
          );
        }
      });
    }).expand((widget) => widget).toList();

    List<Widget> blocktappingScreens = _blocktapping.map((section){
      return section.tasks.map((task) {
        return BlocktappingScreen(
          section: section,
          task: task,
        );
      });
    }).expand((widget) => widget).toList();

    List<Widget> blocktappingDemo = _blocktappingDemo();

    _workflow.clear();

    _workflow.addAll([
      InitialScreen(),
      const InstructionScreen(
        backEnabled: false,
        title: "Begrüßung",
        subtitle: "Vielen Dank für Ihre Studienteilnahme.",
        instruction: "Im Folgenden bitten wir Sie, zunächst Fragen zu Schmerz, Stimmung und anderen möglichen Beschwerden zu beantworten (Dauer wenige Minuten).\nIm Anschluss bitten wir Sie, eine kurze spielerische Konzentrationsaufgabe zu bearbeiten. Wenden Sie sich bei Fragen jederzeit gerne an unser Personal.",
      ),
      const InstructionScreen(
        backEnabled: true,
        title: "Fragebogen - Anleitung",
        subtitle: "Fragebogen:",
        instruction: "Bitte kreuzen Sie zu jeder Frage oder Aussage ein Kästchen an.",
      ),
      ...multipleChoiceScreens,
      const InstructionScreen(
        backEnabled: true,
        title: "Konzentrationsaufgabe - Anleitung",
        subtitle: "Konzentrationsaufgabe:",
        instruction: "In der folgenden Aufgabe sehen Sie 8 Quadrate. Von diesen 8 Quadraten werden einzelne nacheinander blau aufleuchten. Ihre Aufgabe wird es sein, die Quadrate in der umgekehrten Reihenfolge (rückwärts) anzutippen.\n\nIm Folgenden sehen Sie zwei Beispiele und deren korrekte Bearbeitung. Danach bitten wir Sie, die Aufgaben zu bearbeiten! Hierbei werden die Aufgaben immer länger und schwieriger. Viel Erfolg!",
      ),
      const InstructionScreen(
        title: "Beispiel",
        subtitle: "Beispiel 1",
        instruction: "Nun folgt das erste Beispiel.",
        backEnabled: true,
      ),
      blocktappingDemo[0],
      const InstructionScreen(
        title: "Beispiele",
        subtitle: "Beispiel 2",
        instruction: "Nun folgt das zweite Beispiel.",
        backEnabled: true,
      ),
      blocktappingDemo[1],
      const InstructionScreen(
        title: "Konzentrationsaufgabe",
        subtitle: "Los geht's.",
        instruction: "Jetzt sind Sie dran!",
        backEnabled: true,
      ),
      ...blocktappingScreens,
      const EndingScreen(
        title: "Abschluss",
        subtitle: "Vielen Dank!",
        instruction: "Die Untersuchung ist jetzt beendet. Das haben Sie ausgezeichnet gemacht. Bitte geben Sie das iPad bei unserem Personal ab.",
      ),
    ]);

    logger.i("workflow is set: $_workflow");
    return _workflow;
  }

  void export() => CsvWriter.export(
    patientCode: _patientCode ?? "NULL",
    questionnaire: _questionnaire,
    blocktapping: _blocktapping,
  );

  Widget get(int index) {
    return _workflow.elementAt(index);
  }

  Widget get first  {
    return _workflow.first;
  }

  Widget get next {
    _index++;
    return _workflow.elementAt(_index);
  }

  Widget get previous {
    _index--;
    return _workflow.elementAt(_index);
  }

  Widget get last {
    return _workflow.last;
  }

  int get page => _index + 1;
  int get pages => _workflow.length;

  bool get end => _index >= _workflow.length-1;

  set patientCode(String patientCode) => _patientCode = patientCode;
}