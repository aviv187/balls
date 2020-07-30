import 'package:flutter/material.dart';

List<Function> makeBoardFunctions = [
  board2,
  board3,
  board4,
  board5,
  board6,
  board7,
  board8,
];

void board2({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  enters
      .add([Offset(witdh * 1 / 3, height / 7), Offset(witdh / 2, height / 2)]);
  enters
      .add([Offset(witdh * 2 / 3, height / 7), Offset(witdh / 2, height / 2)]);

  crosses.add([
    [Offset(witdh / 2, height / 2), Offset(witdh * 1 / 8, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 1 / 4, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 3 / 8, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 5 / 8, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 3 / 4, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 7 / 8, height * 6 / 7)],
  ]);
}

void board3({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  enters
      .add([Offset(witdh * 1 / 5, height / 7), Offset(witdh / 3, height / 3)]);
  enters
      .add([Offset(witdh * 2 / 5, height / 7), Offset(witdh / 3, height / 3)]);
  enters.add(
      [Offset(witdh * 4 / 5, height / 7), Offset(witdh * 7 / 12, height / 2)]);

  crosses.add([
    [Offset(witdh / 3, height / 3), Offset(witdh * 1 / 8, height * 6 / 7)],
    [Offset(witdh / 3, height / 3), Offset(witdh * 1 / 4, height * 6 / 7)],
    [Offset(witdh / 3, height / 3), Offset(witdh * 7 / 12, height / 2)],
  ]);
  crosses.add([
    [Offset(witdh * 7 / 12, height / 2), Offset(witdh * 1 / 4, height * 6 / 7)],
    [Offset(witdh * 7 / 12, height / 2), Offset(witdh * 3 / 8, height * 6 / 7)],
    [Offset(witdh * 7 / 12, height / 2), Offset(witdh * 7 / 8, height * 6 / 7)],
  ]);
}

void board4({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  enters.add([
    Offset(witdh * 1 / 7, height / 7),
    Offset(witdh * 3 / 10, height * 9 / 16)
  ]);
  enters.add(
      [Offset(witdh * 2 / 5, height / 7), Offset(witdh / 2, height * 3 / 8)]);
  enters.add(
      [Offset(witdh * 3 / 5, height / 7), Offset(witdh / 2, height * 3 / 8)]);
  enters.add([
    Offset(witdh * 6 / 7, height / 7),
    Offset(witdh * 7 / 10, height * 9 / 16)
  ]);

  crosses.add([
    [
      Offset(witdh / 2, height * 3 / 8),
      Offset(witdh * 3 / 10, height * 9 / 16)
    ],
    [Offset(witdh / 2, height * 3 / 8), Offset(witdh / 2, height * 6 / 7)],
    [
      Offset(witdh / 2, height * 3 / 8),
      Offset(witdh * 7 / 10, height * 9 / 16)
    ],
  ]);
  crosses.add([
    [
      Offset(witdh * 3 / 10, height * 9 / 16),
      Offset(witdh / 8, height * 6 / 7)
    ],
    [
      Offset(witdh * 3 / 10, height * 9 / 16),
      Offset(witdh / 4, height * 6 / 7)
    ],
    [
      Offset(witdh * 3 / 10, height * 9 / 16),
      Offset(witdh * 3 / 8, height * 6 / 7)
    ],
    [
      Offset(witdh * 3 / 10, height * 9 / 16),
      Offset(witdh / 2, height * 6 / 7)
    ],
  ]);
  crosses.add([
    [
      Offset(witdh * 7 / 10, height * 9 / 16),
      Offset(witdh / 2, height * 6 / 7)
    ],
    [
      Offset(witdh * 7 / 10, height * 9 / 16),
      Offset(witdh * 5 / 8, height * 6 / 7)
    ],
    [
      Offset(witdh * 7 / 10, height * 9 / 16),
      Offset(witdh * 3 / 4, height * 6 / 7)
    ],
    [
      Offset(witdh * 7 / 10, height * 9 / 16),
      Offset(witdh * 7 / 8, height * 6 / 7)
    ],
  ]);
}

void board5({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  enters
      .add([Offset(witdh * 1 / 6, height / 7), Offset(witdh / 4, height / 2)]);
  enters
      .add([Offset(witdh * 2 / 6, height / 7), Offset(witdh / 4, height / 2)]);
  enters.add(
      [Offset(witdh * 3 / 6, height / 7), Offset(witdh * 7 / 12, height / 3)]);
  enters.add(
      [Offset(witdh * 4 / 6, height / 7), Offset(witdh * 7 / 12, height / 3)]);
  enters.add([
    Offset(witdh * 5 / 6, height / 7),
    Offset(witdh * 7 / 12, height * 3 / 5)
  ]);

  crosses.add([
    [Offset(witdh * 7 / 12, height / 3), Offset(witdh / 4, height / 2)],
    [
      Offset(witdh * 7 / 12, height / 3),
      Offset(witdh * 7 / 12, height * 3 / 5)
    ],
  ]);
  crosses.add([
    [Offset(witdh / 4, height / 2), Offset(witdh * 1 / 8, height * 6 / 7)],
    [Offset(witdh / 4, height / 2), Offset(witdh * 7 / 12, height * 3 / 5)],
  ]);
  crosses.add([
    [
      Offset(witdh * 7 / 12, height * 3 / 5),
      Offset(witdh * 1 / 8, height * 6 / 7)
    ],
    [
      Offset(witdh * 7 / 12, height * 3 / 5),
      Offset(witdh * 3 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 7 / 12, height * 3 / 5),
      Offset(witdh * 5 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 7 / 12, height * 3 / 5),
      Offset(witdh * 6 / 7, height * 6 / 7)
    ],
  ]);
}

void board6({
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

void board7({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  enters.add(
      [Offset(witdh * 1 / 8, height / 7), Offset(witdh * 3 / 16, height / 3)]);
  enters.add(
      [Offset(witdh * 2 / 8, height / 7), Offset(witdh * 3 / 16, height / 3)]);
  enters.add(
      [Offset(witdh * 3 / 8, height / 7), Offset(witdh * 3 / 16, height / 3)]);
  enters
      .add([Offset(witdh * 4 / 8, height / 7), Offset(witdh / 2, height / 2)]);
  enters.add(
      [Offset(witdh * 5 / 8, height / 7), Offset(witdh * 13 / 16, height / 3)]);
  enters.add(
      [Offset(witdh * 6 / 8, height / 7), Offset(witdh * 13 / 16, height / 3)]);
  enters.add(
      [Offset(witdh * 7 / 8, height / 7), Offset(witdh * 13 / 16, height / 3)]);

  crosses.add([
    [Offset(witdh / 2, height / 2), Offset(witdh * 5 / 16, height * 2 / 3)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 3 / 8, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh / 2, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 5 / 8, height * 6 / 7)],
    [Offset(witdh / 2, height / 2), Offset(witdh * 11 / 16, height * 2 / 3)],
  ]);
  crosses.add([
    [Offset(witdh * 3 / 16, height / 3), Offset(witdh * 1 / 8, height * 6 / 7)],
    [
      Offset(witdh * 3 / 16, height / 3),
      Offset(witdh * 5 / 16, height * 2 / 3)
    ],
    [Offset(witdh * 3 / 16, height / 3), Offset(witdh / 2, height / 2)],
  ]);
  crosses.add([
    [Offset(witdh * 13 / 16, height / 3), Offset(witdh / 2, height / 2)],
    [
      Offset(witdh * 13 / 16, height / 3),
      Offset(witdh * 11 / 16, height * 2 / 3)
    ],
    [
      Offset(witdh * 13 / 16, height / 3),
      Offset(witdh * 7 / 8, height * 6 / 7)
    ],
  ]);
  crosses.add([
    [Offset(witdh * 5 / 16, height * 2 / 3), Offset(witdh / 8, height * 6 / 7)],
    [Offset(witdh * 5 / 16, height * 2 / 3), Offset(witdh / 4, height * 6 / 7)],
    [
      Offset(witdh * 5 / 16, height * 2 / 3),
      Offset(witdh * 3 / 8, height * 6 / 7)
    ],
  ]);
  crosses.add([
    [
      Offset(witdh * 11 / 16, height * 2 / 3),
      Offset(witdh * 5 / 8, height * 6 / 7)
    ],
    [
      Offset(witdh * 11 / 16, height * 2 / 3),
      Offset(witdh * 3 / 4, height * 6 / 7)
    ],
    [
      Offset(witdh * 11 / 16, height * 2 / 3),
      Offset(witdh * 7 / 8, height * 6 / 7)
    ],
  ]);
}

void board8({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  enters.add([
    Offset(witdh * 1 / 9, height / 7),
    Offset(witdh * 2 / 9, height * 5 / 12)
  ]);
  enters.add([
    Offset(witdh * 2 / 9, height / 7),
    Offset(witdh * 2 / 9, height * 5 / 12)
  ]);
  enters.add(
      [Offset(witdh * 3 / 9, height / 7), Offset(witdh * 7 / 18, height / 4)]);
  enters.add(
      [Offset(witdh * 4 / 9, height / 7), Offset(witdh * 7 / 18, height / 4)]);
  enters.add([
    Offset(witdh * 5 / 9, height / 7),
    Offset(witdh * 11 / 18, height * 7 / 10)
  ]);
  enters.add([
    Offset(witdh * 6 / 9, height / 7),
    Offset(witdh * 11 / 18, height * 7 / 10)
  ]);
  enters.add([
    Offset(witdh * 7 / 9, height / 7),
    Offset(witdh * 15 / 18, height * 5 / 12)
  ]);
  enters.add([
    Offset(witdh * 8 / 9, height / 7),
    Offset(witdh * 15 / 18, height * 5 / 12)
  ]);

  crosses.add([
    [
      Offset(witdh * 7 / 18, height / 4),
      Offset(witdh * 2 / 9, height * 5 / 12)
    ],
    [
      Offset(witdh * 7 / 18, height / 4),
      Offset(witdh * 11 / 18, height * 7 / 10)
    ],
  ]);
  crosses.add([
    [
      Offset(witdh * 2 / 9, height * 5 / 12),
      Offset(witdh * 1 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 2 / 9, height * 5 / 12),
      Offset(witdh * 2 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 2 / 9, height * 5 / 12),
      Offset(witdh * 11 / 18, height * 7 / 10)
    ],
  ]);
  crosses.add([
    [
      Offset(witdh * 15 / 18, height * 5 / 12),
      Offset(witdh * 11 / 18, height * 7 / 10)
    ],
    [
      Offset(witdh * 15 / 18, height * 5 / 12),
      Offset(witdh * 3 / 4, height * 6 / 7)
    ]
  ]);
  crosses.add([
    [
      Offset(witdh * 11 / 18, height * 7 / 10),
      Offset(witdh * 2 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 11 / 18, height * 7 / 10),
      Offset(witdh * 3 / 7, height * 6 / 7)
    ],
    [
      Offset(witdh * 11 / 18, height * 7 / 10),
      Offset(witdh * 3 / 4, height * 6 / 7)
    ]
  ]);
}
