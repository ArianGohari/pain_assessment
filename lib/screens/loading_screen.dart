import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: material.Material(
        child: Center(
          child: Text("Loading..."),
        ),
      ),
    );
  }

}