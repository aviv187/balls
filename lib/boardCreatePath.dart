import 'package:flutter/material.dart';

void simpleBoard({
  double height,
  double witdh,
  List<List<Offset>> enters,
  List<List<List<Offset>>> crosses,
}) {
  for (int i = 0; i < 6; i++) {
    enters.add([Offset(witdh * (i + 1) / 7, height / 7)]);
    if (i < 2) {
      enters[i].add(Offset(witdh * 3 / 14, height * 3 / 7));
    } else if (i < 4) {
      enters[i].add(Offset(witdh * 7 / 14, height * 2 / 7));
    } else if (i < 6) {
      enters[i].add(Offset(witdh * 11 / 14, height * 4 / 7));
    }
  }

  crosses.add([]);
  for (int i = 0; i < 3; i++) {
    crosses[0].add([Offset(witdh * 7 / 14, height * 2 / 7)]);
    switch (i) {
      case 0:
        crosses[0][0].add(Offset(witdh * 3 / 14, height * 3 / 7));
        break;
      case 1:
        crosses[0][1].add(Offset(witdh * 5 / 14, height * 5 / 7));
        break;
      case 2:
        crosses[0][2].add(Offset(witdh * 11 / 14, height * 4 / 7));
        break;
      default:
    }
  }
  crosses.add([]);
  for (int i = 0; i < 3; i++) {
    crosses[1].add([Offset(witdh * 3 / 14, height * 3 / 7)]);
    switch (i) {
      case 0:
        crosses[1][0].add(Offset(witdh * 1 / 7, height * 6 / 7));
        break;
      case 1:
        crosses[1][1].add(Offset(witdh * 2 / 7, height * 6 / 7));
        break;
      case 2:
        crosses[1][2].add(Offset(witdh * 5 / 14, height * 5 / 7));
        break;
      default:
    }
  }
  crosses.add([]);
  for (int i = 0; i < 3; i++) {
    crosses[2].add([Offset(witdh * 11 / 14, height * 4 / 7)]);
    switch (i) {
      case 0:
        crosses[2][0].add(Offset(witdh * 5 / 14, height * 5 / 7));
        break;
      case 1:
        crosses[2][1].add(Offset(witdh * 5 / 7, height * 6 / 7));
        break;
      case 2:
        crosses[2][2].add(Offset(witdh * 6 / 7, height * 6 / 7));
        break;
      default:
    }
  }
  crosses.add([]);
  for (int i = 0; i < 3; i++) {
    crosses[3].add([Offset(witdh * 5 / 14, height * 5 / 7)]);
    switch (i) {
      case 0:
        crosses[3][0].add(Offset(witdh * 2 / 7, height * 6 / 7));
        break;
      case 1:
        crosses[3][1].add(Offset(witdh * 3 / 7, height * 6 / 7));
        break;
      case 2:
        crosses[3][2].add(Offset(witdh * 5 / 7, height * 6 / 7));
        break;
      default:
    }
  }
}
