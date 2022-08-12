import 'package:tic_tac_toe/player.dart';

abstract class State {
  const State();

  State copy();
}

class Running extends State {
  const Running();

  @override
  String toString() => "Running {}";

  @override
  State copy() => Running();
}

class GameOver extends State {
  const GameOver(this.player);

  final Player player;

  @override
  String toString() => "GameOver { player: $player }";

  @override
  State copy() => GameOver(player);
}
