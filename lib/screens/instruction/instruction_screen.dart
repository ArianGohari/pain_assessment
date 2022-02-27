import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:painlab_app/screens/components/custom_button.dart';
import 'package:painlab_app/services/workflow_manager.dart';

class InstructionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String instruction;
  final bool backEnabled;

  const InstructionScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.instruction,
    required this.backEnabled,
  }) : super(key: key);

  void next(BuildContext context) {
    Widget next = WorkflowManager().end
        ? WorkflowManager().last
        : WorkflowManager().next;

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => next,
      transitionDuration: Duration.zero,
    ));
  }

  void back(BuildContext context) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => WorkflowManager().previous,
      transitionDuration: Duration.zero,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      key: key,
      navigationBar: CupertinoNavigationBar(
        middle: Text(title, style: const TextStyle(fontFamily: "HelveticaNeue"),),
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
                    const SizedBox(height: 96,),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "HelveticaNeue",
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(
                      width: double.maxFinite,
                      height: 24,
                    ),
                    Text(
                      instruction,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "HelveticaNeue",
                        height: 1.5,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(backEnabled)
                    CustomButton(
                      text: 'Zurück', 
                      onPressed: () => back(context),
                    ),
                  if(backEnabled)
                    const SizedBox(width: 16,),
                  CustomButton(
                    text: 'Weiter', 
                    onPressed: () => next(context),
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }

}