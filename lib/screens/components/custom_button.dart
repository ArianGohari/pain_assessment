import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: "HelveticaNeue",
          fontSize: 24,
        ),
      ),
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(0),
      disabledColor: CupertinoTheme.of(context).primaryColor.withOpacity(0.4),
    );
  }

}