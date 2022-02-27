import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:painlab_app/screens/blocktapping/blocktapping_screen.dart';

class Block extends StatefulWidget {
  final bool demo;
  final Mode mode;
  final int i;
  final double x;
  final double y;
  final double width;
  final double height;
  final bool selected;
  final List<int> input;


  const Block({
    Key? key,
    required this.demo,
    required this.mode,
    required this.i,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.selected,
    required this.input,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlockState();
}

class _BlockState extends State<Block> {
  static const Color gray = Color(0xFFE6E6E6);
  static const Color blue = Color(0xFF3070B3);
  bool _tap = false;
  DateTime? _tapDateTime;

  void onTapDown(_) {
    if(!widget.demo) {
      widget.input.add(widget.i+1);
      Logger().i("input: ${widget.input}");
      setState(() {
        _tap = true;
        _tapDateTime = DateTime.now();
      });

      Future? timer;
      if(timer != null) {
        timer.ignore();
      }

      timer = Future.delayed(const Duration(milliseconds: 500), (){
        setState(() {
          if(!_tap) {
            _tapDateTime = null;
          }
        });
      });
    }
  }

  void onTapUp(_) => setState(() => _tap = false);

  void onTapCancel() => setState(() => _tap = false);



  Color _tapModeColor() {
    if(_tapDateTime != null) log("_tapDateTime difference: ${DateTime.now().difference(_tapDateTime!).inMilliseconds}ms");
    if((_tapDateTime != null && DateTime.now().difference(_tapDateTime!).inMilliseconds < 500) || _tap)  {
      return blue;
    }

    else {
      return gray;
    }
  }

  Color _color() {
    switch(widget.mode) {
      case Mode.initial:
      case Mode.idle:
        return gray;
      case Mode.play:
      case Mode.demo:
        return widget.selected ? blue : gray;
      case Mode.tap:
        return _tapModeColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.x,
      top: widget.y,
      width: widget.width > 80 ? widget.width : 80,
      height: widget.height > 100 ? widget.height : 100,
      child: SizedBox(
        width: widget.width > 80 ? widget.width : 80,
        height: widget.height > 100 ? widget.height : 100,
        child: Stack(
          children: [
            GestureDetector(
              onTapDown: widget.mode == Mode.tap ? onTapDown : null,
              onTapUp: widget.mode == Mode.tap ? onTapUp : null,
              onTapCancel: widget.mode == Mode.tap ? onTapCancel : null,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF3070B3),
                    width: 3,
                  ),
                  color: _color(),
                ),
              ),
            ),
            if(widget.mode == Mode.demo && widget.selected)
              Positioned(
                left: 5,
                top: 5,
                width: 70,
                child: Image.asset("assets/img/finger.png"),
              )
          ],
        ),
      )
    );
  }
}