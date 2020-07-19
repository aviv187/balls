import 'package:flutter/material.dart';

void simpleBoard({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  enters.add(
      [Offset(witdh / 7, height / 7), Offset(witdh * 3 / 14, height * 3 / 7)]);
  enters.add([
    Offset(witdh * 2 / 7, height / 7),
    Offset(witdh * 3 / 14, height * 3 / 7)
  ]);
  enters.add([
    Offset(witdh * 3 / 7, height / 7),
    Offset(witdh * 7 / 14, height * 2 / 7)
  ]);
  enters.add([
    Offset(witdh * 4 / 7, height / 7),
    Offset(witdh * 7 / 14, height * 2 / 7)
  ]);
  enters.add([
    Offset(witdh * 5 / 7, height / 7),
    Offset(witdh * 11 / 14, height * 4 / 7)
  ]);
  enters.add([
    Offset(witdh * 6 / 7, height / 7),
    Offset(witdh * 11 / 14, height * 4 / 7)
  ]);

  crosses.add([
    [
      Offset(witdh * 7 / 14, height * 2 / 7),
      Offset(witdh * 3 / 14, height * 3 / 7)
    ],
    [
      Offset(witdh * 7 / 14, height * 2 / 7),
      Offset(witdh * 5 / 14, height * 5 / 7)
    ],
    [
      Offset(witdh * 7 / 14, height * 2 / 7),
      Offset(witdh * 11 / 14, height * 4 / 7)
    ],
  ]);

  crosses.add([
    [
      Offset(witdh * 3 / 14, height * 3 / 7),
      Offset(witdh * 1 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 3 / 14, height * 3 / 7),
      Offset(witdh * 2 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 3 / 14, height * 3 / 7),
      Offset(witdh * 5 / 14, height * 5 / 7)
    ],
  ]);

  crosses.add([
    [
      Offset(witdh * 11 / 14, height * 4 / 7),
      Offset(witdh * 5 / 14, height * 5 / 7)
    ],
    [
      Offset(witdh * 11 / 14, height * 4 / 7),
      Offset(witdh * 5 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 11 / 14, height * 4 / 7),
      Offset(witdh * 6 / 7, height * 6 / 7)
    ],
  ]);

  crosses.add([
    [
      Offset(witdh * 5 / 14, height * 5 / 7),
      Offset(witdh * 2 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 5 / 14, height * 5 / 7),
      Offset(witdh * 3 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 5 / 14, height * 5 / 7),
      Offset(witdh * 5 / 7, height * 6 / 7)
    ],
  ]);
}
