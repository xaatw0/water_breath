import 'package:flutter/material.dart';

import '../../functions.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    required this.onSetting,
    required this.onBack,
    Key? key,
  }) : super(key: key);

  static const sizeIcon = 64.0;

  final Function onSetting;
  final Function onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            onBack();
          },
          icon: Icon(
            Icons.arrow_back,
            size: sizeIcon,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            onSetting();
          },
          icon: Icon(
            Icons.settings,
            size: sizeIcon,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
