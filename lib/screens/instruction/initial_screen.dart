import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:painlab_app/screens/components/custom_button.dart';
import 'package:painlab_app/services/workflow_manager.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  String _patientCode = "";

  void next() {
    Widget next = WorkflowManager().end
        ? WorkflowManager().last
        : WorkflowManager().next;

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => next,
      transitionDuration: Duration.zero,
    ));
  }

  void onTextChanged(String text) {
    setState(() => _patientCode = text.trim());
    WorkflowManager().patientCode = _patientCode;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            "Patientenerhebung: EEG bei Schmerz",
            style: TextStyle(fontFamily: "HelveticaNeue",),
          ),
        ),
        resizeToAvoidBottomInset: false,
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
                          const SizedBox(height: 32, width: double.maxFinite,),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/img/mri_neurologie.png",
                                width: 320,
                              ),
                              Image.asset(
                                "assets/img/tum.png",
                                width: 320,
                              ),
                            ],
                          ),
                          const SizedBox(height: 64, width: double.maxFinite,),
                          const Text(
                            "Patientencode:",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "HelveticaNeue",
                              fontSize: 36,
                            ),
                          ),
                          const SizedBox(height: 32,),
                          SizedBox(
                            height: 48,
                            child: CupertinoTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp("([A-Za-z0-9-_]+)")
                                ),
                              ],
                              onChanged: onTextChanged,
                              textCapitalization: TextCapitalization.characters,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: CupertinoColors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "HelveticaNeue",
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    CustomButton(
                      text: 'Starten',
                      onPressed: _patientCode.isEmpty ? null : () => next(),
                    ),
                  ],
                ),
            ),
        ),
    );
  }
}