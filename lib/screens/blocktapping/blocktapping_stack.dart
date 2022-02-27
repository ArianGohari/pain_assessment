import 'package:flutter/cupertino.dart';
import 'package:painlab_app/screens/blocktapping/block.dart';
import 'package:painlab_app/screens/blocktapping/blocktapping_screen.dart';

class BlocktappingStack extends StatelessWidget {
  final bool demo;
  final Size screenSize;
  final Mode mode;
  final List<int> selected;
  final List<int> input;

  double? width;
  double? height;
  double? blockWidth;
  double? blockHeight;
  List<List<double>>? positions;

  BlocktappingStack({
    Key? key,
    required this.demo,
    required this.mode,
    required this.selected,
    required this.screenSize,
    required this.input,
  }) : super(key: key) {
    width = (8.4 * screenSize.width + screenSize.width) / 13.2;
    height = (5.8 * 0.88 * screenSize.width + 0.88 * screenSize.width) / 13.2;
    blockWidth = screenSize.width / 13.2;
    blockHeight = 0.88 * blockWidth!;

    positions = [
      [0, 0],
      [4 * blockWidth!, 0.8 * blockHeight!],
      [0, 4.8 * blockHeight!],
      [5.8 * blockWidth!, 2.6 * blockHeight!],
      [1.6 * blockWidth!, 2.9 * blockHeight!],
      [7.6 * blockWidth!, 1.2 * blockHeight!],
      [3.2 * blockWidth!, 5.4 * blockHeight!],
      [8.4 * blockWidth!, 5.4 * blockHeight!],
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> blocks = [];
    for(int i = 0; i < positions!.length; i++) {
      List<double> position = positions![i];
      blocks.add(Block(
        demo: demo,
        mode: mode,
        i: i,
        x: position[0],
        y: position[1],
        width: blockWidth!,
        height: blockHeight!,
        selected: selected.contains(i),
        input: input,
      ));
    }

    return SizedBox(
      width: width!,
      height: height!,
      child: Stack(
        children: blocks,
      ),
    );
  }
}