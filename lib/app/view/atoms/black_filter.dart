import 'package:flutter/material.dart';

class BlackFilter extends StatelessWidget {
  final color = Colors.black.withAlpha(25);

  BlackFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
