import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:painlab_app/model/blocktapping_task.dart';
import 'package:painlab_app/model/section.dart';
import 'package:painlab_app/screens/blocktapping/blocktapping_stack.dart';
import 'package:painlab_app/screens/components/custom_button.dart';
import 'package:painlab_app/services/workflow_manager.dart';

class BlocktappingScreen extends StatefulWidget {
  final bool demo;
  final Section<BlocktappingTask> section;
  final BlocktappingTask task;
  final List<int> input = [];

  BlocktappingScreen({
    Key? key,
    this.demo = false,
    required this.section,
    required this.task,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocktappingScreenState();
}

class _BlocktappingScreenState extends State<BlocktappingScreen> with AfterLayoutMixin{
  Mode _mode = Mode.initial;
  List<int> _selected = [];

  void play() async {
    setState(() => _mode = Mode.play);
    await Future.delayed(const Duration(milliseconds: 1500));

    for(int element in widget.task.sequence) {

      setState(() => _selected = [element - 1]);
      await Future.delayed(const Duration(milliseconds: 1000));

      setState(() => _selected = []);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _mode = Mode.tap);
  }

  void demo() async {
    setState(() => _mode = Mode.play);
    await Future.delayed(const Duration(milliseconds: 2000));

    for(int element in widget.task.sequence) {

      setState(() => _selected = [element - 1]);
      await Future.delayed(const Duration(milliseconds: 1000));

      setState(() => _selected = []);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    setState(() => _mode = Mode.demo);
    await Future.delayed(const Duration(milliseconds: 1500));

    for(int element in widget.task.sequence.reversed) {

      setState(() => _selected = [element - 1]);
      await Future.delayed(const Duration(milliseconds: 1000));

      setState(() => _selected = []);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _mode = Mode.tap);
  }

  bool _evaluate() {
    widget.task.evaluate(widget.input);
    if(widget.section.tasks[1].result == null) {
      return true;
    }

    else {
      return (widget.section.tasks[0].result == 1 || widget.section.tasks[1].result == 1);
    }
  }

  void next() {
    // get next page
    Widget next = widget.demo || (_evaluate() && !WorkflowManager().end)
        ? WorkflowManager().next
        : WorkflowManager().last;

    // export (overwrite) csv
    if(!widget.demo) WorkflowManager().export();

    // push next page
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => next,
      transitionDuration: Duration.zero,
    ));
  }

  String headerText() {
    if(widget.demo || _mode == Mode.idle || _mode == Mode.demo) {
      return widget.task.title;
    }

    else if(_mode == Mode.initial) {
      return "Bitte starten Sie die Aufgabe.";
    }

    else if(_mode == Mode.play) {
      return "";
    }

    else {
      return "Bitte tippen Sie die Quadrate in umgekehrter Reihenfolge an.";
    }
  }

  String buttonText() {
    if(widget.demo || _mode == Mode.idle || _mode == Mode.tap || _mode == Mode.demo) {
      return "Weiter";
    }

    else {
      return "Starten";
    }
  }

  void back() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => WorkflowManager().previous,
      transitionDuration: Duration.zero,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: widget.demo
              ? Text(widget.section.title, style: const TextStyle(fontFamily: "HelveticaNeue"),)
              : Text(widget.task.title, style: const TextStyle(fontFamily: "HelveticaNeue"),),
        ),
        child: material.Material(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 64,
              right: 64,
              top: 96,
              bottom: 64,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  headerText(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "HelveticaNeue",
                      fontSize: 25,
                  ),
                ),
                BlocktappingStack(
                  demo: widget.demo,
                  mode: _mode,
                  selected: _selected,
                  screenSize: screenSize,
                  input: widget.input,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(widget.demo)
                      CustomButton(
                        text: 'Zurück',
                        onPressed: _mode == Mode.tap ? () => back() : null,
                      ),
                    if(widget.demo)
                      const SizedBox(width: 16,),
                    CustomButton(
                      text: buttonText(),
                      onPressed: _mode == Mode.play || _mode == Mode.demo
                          ? null
                          : _mode == Mode.initial
                          ? play
                          : next,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _mode = widget.demo ? Mode.demo : Mode.initial;
    if(_mode == Mode.demo) demo();
  }
}
enum Mode { idle, initial, play, tap, demo }
