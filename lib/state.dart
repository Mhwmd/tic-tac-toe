import 'package:equatable/equatable.dart';
import 'package:tic_tac_toe/player.dart';

abstract class State extends Equatable {
  const State();

  State copy();

  @override
  List<Object> get props => [];
}

class Running extends State {
  const Running();

  @override
  State copy() => Running();

  @override
  String toString() => "Running {}";
}

class GameOver extends State {
  const GameOver(this.player);

  final Player player;

  @override
  State copy() => GameOver(player);

  @override
  List<Object> get props => [player];

  @override
  String toString() => "GameOver { player: $player }";
}
