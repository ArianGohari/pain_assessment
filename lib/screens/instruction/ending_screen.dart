import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:painlab_app/screens/components/custom_button.dart';
import 'package:painlab_app/services/workflow_manager.dart';

class EndingScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String instruction;

  const EndingScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.instruction,
  }) : super(key: key);

  void _onClick() {
    WorkflowManager().export();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            title,
            style: const TextStyle(fontFamily: "HelveticaNeue"),),
        ),
        child: material.Material(
            color: CupertinoTheme
                .of(context)
                .scaffoldBackgroundColor,
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
                    CustomButton(
                      text: 'Beenden',
                      onPressed: _onClick,
                    ),
                  ],
                )
            )
        )
    );
  }
}