import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:painlab_app/screens/loading_screen.dart';
import 'package:painlab_app/services/workflow_manager.dart';

void main() {
  runApp(const PainLabApp());
}

class PainLabApp extends StatefulWidget {
  const PainLabApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PainLabAppState();
}

class _PainLabAppState extends State<PainLabApp> {
  Future? _loadingFuture;

  @override
  void initState() {
    _loadingFuture = WorkflowManager().loadWorkflow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(
          primaryColor: Color(0xFF3070B3),
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              fontFamily: "HelveticaNeue",
            ),
          ),
        ),
        home: FutureBuilder(
          future: _loadingFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return WorkflowManager().first;
            } else {
              return const LoadingScreen();
            }
          },
        ));
  }
}
