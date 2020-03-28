import 'package:flutter/material.dart';
import '../models/card_color_model.dart';

class CardColor {
  static const baseColors = <Color>[
    Color.fromRGBO(60, 61, 63, 1.0), //Black
    Color.fromRGBO(219, 157, 80, 1.0), //Orange
//    Color.fromRGBO(96, 200, 227, 1.0), //Cyan
    Color.fromRGBO(222, 88, 116, 1.0), //Salmon
//    Color.fromRGBO(128, 182, 234, 1.0), //LightCyan
//    Color.fromRGBO(114, 71, 200, 1.0), //Purple
    Color.fromRGBO(106, 188, 121, 1.0), //Green
    Color.fromRGBO(61, 132, 223, 1.0), //LightBlue
//    Color.fromRGBO(229, 92, 131, 1.0), //Pink
  ];

  static List<AccountColorModel> accountColors =
      new List<AccountColorModel>.generate(
          baseColors.length,
          (int index) =>
              AccountColorModel(isSelected: false, accountColor: index));
}
