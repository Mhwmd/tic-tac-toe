import 'dart:convert';
import 'dart:io';

import 'package:tic_tac_toe/tic_tac_toe.dart';

const validInput = r"^(\d+) +(\d+)+$";

bool checkValidInput(String? input) {
  if (input == null) return false;
  return RegExp(validInput).hasMatch(input);
}

Position parseInput(String input) {
  RegExp regExp = RegExp(validInput);
  RegExpMatch match = regExp.firstMatch(input)!;
  int x = int.parse(match.group(1)!);
  int y = int.parse(match.group(2)!);
  return Position(x, y);
}

String playerToString(Player player) {
  switch (player) {
    case Player.none:
      return " ";
    case Player.first:
      return "X";
    case Player.second:
      return "O";
  }
}

void runGame(Game game) {
  renderGame(game);

  if (game.state is Running) {
    takeInput(game, (position) {
      runGame(changeTurn(checkGameOver(runMove(game, position))));
    });
  }
}

void renderGame(Game game) {
  String top = "-------------";
  StringBuffer stringBuffer = StringBuffer();
  stringBuffer.writeln("turn: ${playerToString(game.turn)}");
  stringBuffer.writeln(top);

  for (var element in game.board) {
    stringBuffer.writeln(
      "| ${playerToString(element[0])} | ${playerToString(element[1])} | ${playerToString(element[2])} |",
    );
  }
  stringBuffer.writeln(top);
  stringBuffer.writeln("state: ${game.state}");
  print(stringBuffer);

  if (game.state is! GameOver) return;

  GameOver state = game.state as GameOver;

  switch (state.player) {
    case Player.first:
    case Player.second:
      print("${playerToString(state.player)} is the winner!");
      break;
    case Player.none:
      print("its a draw :(!");
      break;
  }
  exit(0);
}

void takeInput(Game game, void Function(Position position) gameCallBack) {
  print("${playerToString(game.turn)}'s turn\n");
  String? text = stdin.readLineSync(encoding: utf8);

  if (!checkValidInput(text)) {
    print("Not valid input, please try again\n");
    takeInput(game, gameCallBack);
  }

  Position position = parseInput(text!);

  if (positionUnoccupied(game.board, position)) {
    gameCallBack(position);
  } else {
    print("Not valid input, please try again\n");
    takeInput(game, gameCallBack);
  }
}

void main() {
  Game game = Game.initialGame;
  runGame(game);
}
