import 'package:flutter/cupertino.dart';
import 'package:painlab_app/screens/blocktapping/block.dart';
import 'package:painlab_app/screens/blocktapping/blocktapping_screen.dart';

class BlocktappingStack extends StatelessWidget {
  final bool demo;
  final Size screenSize;
  final Mode mode;
  final List<int> selected;
  final List<int> input;

  final double width;
  final double height;
  final double blockWidth;
  final double blockHeight;
  final List<List<double>> positions;

  BlocktappingStack({
    Key? key,
    required this.demo,
    required this.mode,
    required this.selected,
    required this.screenSize,
    required this.input,
  })  : width = (8.4 * screenSize.width + screenSize.width) / 13.2,
        height = (5.8 * 0.88 * screenSize.width + 0.88 * screenSize.width) / 13.2,
        blockWidth = screenSize.width / 13.2,
        blockHeight = 0.88 * screenSize.width / 13.2,
        positions = [
          [0, 0],
          [4 * screenSize.width / 13.2, 0.8 * 0.88 * screenSize.width / 13.2],
          [0, 4.8 * 0.88 * screenSize.width / 13.2],
          [5.8 * screenSize.width / 13.2, 2.6 * 0.88 * screenSize.width / 13.2],
          [1.6 * screenSize.width / 13.2, 2.9 * 0.88 * screenSize.width / 13.2],
          [7.6 * screenSize.width / 13.2, 1.2 * 0.88 * screenSize.width / 13.2],
          [3.2 * screenSize.width / 13.2, 5.4 * 0.88 * screenSize.width / 13.2],
          [8.4 * screenSize.width / 13.2, 5.4 * 0.88 * screenSize.width / 13.2],
        ],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> blocks = [];
    for (int i = 0; i < positions.length; i++) {
      List<double> position = positions[i];
      blocks.add(Block(
        demo: demo,
        mode: mode,
        i: i,
        x: position[0],
        y: position[1],
        width: blockWidth,
        height: blockHeight,
        selected: selected.contains(i),
        input: input,
      ));
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: blocks,
      ),
    );
  }
}
