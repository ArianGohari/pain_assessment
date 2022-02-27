import 'package:collection/collection.dart';
import 'package:painlab_app/model/task.dart';

class BlocktappingTask extends Task {
  final List<int> sequence;

  BlocktappingTask({
    required String title,
    required this.sequence,
  }) : super(title: title);

  void evaluate(List<int> input) {
    print("input: $input");
    print("reversed_ ${input.reversed.toList()}");
    print("sequence: $sequence");
    result = const ListEquality().equals(
      input.reversed.toList(),
      sequence,
    ) ? 1 : 0;
  }


  @override
  String toCsv() {
    // TODO: implement toCsv
    throw UnimplementedError();
  }

}