import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:painlab_app/model/multiple_choice_task.dart';
import 'package:painlab_app/screens/components/custom_button.dart';
import 'package:painlab_app/services/workflow_manager.dart';

class RangeChoiceScreen extends StatefulWidget {
  final bool backEnabled;
  final String title;
  final MultipleChoiceTask task;

  const RangeChoiceScreen({
    Key? key,
    required this.backEnabled,
    required this.title,
    required this.task,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RangeChoiceScreenState();
}

class _RangeChoiceScreenState extends State<RangeChoiceScreen> {
  List<bool> _values = [];
  bool noSelection = false;

  bool _checkboxValue(int index) {
    bool ret = true;

    for (int i = 0; i < _values.length; i++) {
      if (i == index) {
        ret &= _values[i];
      } else {
        ret &= !_values[i];
      }
    }

    return ret;
  }

  Widget _choice<T>(Choice choice, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.5,
          child: material.Checkbox(
            activeColor: CupertinoTheme.of(context).primaryColor,
            value: _checkboxValue(index),
            onChanged: (_) => setState(
                  () {
                for (int i = 0; i < _values.length; i++) {
                  if (i != index) _values[i] = false;
                }
                _values[index] = !_values[index];
              },
            ),
          ),
        ),
        Text(
          choice.points.toString(),
          style: const TextStyle(fontFamily: "HelveticaNeue", fontSize: 24),
        )
      ],
    );
  }

  void select() {
    for(int i = 0; i < _values.length; i++) {
      if(_values[i]) {
        widget.task.select(i);
      } else {
        widget.task.unselect(i);
      }
    }
  }

  void next() {
    bool check = false;
    for (bool value in _values) {
      check |= value;
    }

    if(!check && !noSelection) {
      setState(() => noSelection = true);
    }

    else {
      // select choice
      select();

      // get next page
      Widget next = WorkflowManager().end
          ? WorkflowManager().last
          : WorkflowManager().next;

      // export (overwrite) csv
      WorkflowManager().export();

      // push next page
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => next,
        transitionDuration: Duration.zero,
      ));
    }
  }

  void back() {
    // select choice (save for later)
    select();

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => WorkflowManager().previous,
      transitionDuration: Duration.zero,
    ));
  }

  @override
  void initState() {
    _values = widget.task.choices.map((_) => false).toList();

    if(widget.task.result != null) {
      for(int i = 0; i < widget.task.choices.length; i++) {
        if(widget.task.choices[i].points == widget.task.result) {
          _values[i] = true;
          break;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.title,
          style: const TextStyle(fontFamily: "HelveticaNeue"),
        ),
      ),
      child: material.Material(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 64),
                    if(widget.task.topic != null) Text(
                      widget.task.topic!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: "HelveticaNeue",
                          fontSize: 25),
                    ),
                    if(widget.task.topic != null) const SizedBox(height: 4),
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "HelveticaNeue",
                          fontSize: 28),
                    ),
                    if(widget.task.optional != null)  Text(
                      widget.task.optional!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "HelveticaNeue",
                        fontStyle: FontStyle.italic,
                        fontSize: 28,
                      ),
                    ),
                    if(widget.task.topic != null) const SizedBox(height: 32),
                    const SizedBox(
                      height: 128,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for(Choice choice in widget.task.choices)
                          if(choice.title.isNotEmpty)
                            SizedBox(
                              width: 120,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(choice.title.toString(),
                                  style: const TextStyle(fontFamily: "HelveticaNeue", fontSize: 22),
                                ),
                              ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < widget.task.choices.length; i++)
                            _choice(widget.task.choices[i], i),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32,),
                    if(noSelection)
                      const Text(
                        "Bitte wählen Sie eine Antwort aus",
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                          fontWeight: FontWeight.w700,
                          fontFamily: "HelveticaNeue",
                          fontSize: 24,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(widget.backEnabled)
                    CustomButton(
                      text: 'Zurück',
                      onPressed: back,
                    ),
                  if(widget.backEnabled)
                    const SizedBox(width: 16,),
                  CustomButton(
                    text: 'Weiter',
                    onPressed: next,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
