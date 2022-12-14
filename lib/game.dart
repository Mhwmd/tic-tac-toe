import 'package:equatable/equatable.dart';

import 'tic_tac_toe.dart';

class Game extends Equatable {
  final Board board;
  final State state;
  final Player turn;

  const Game({required this.board, required this.turn, required this.state});

  static Game get initialGame => const Game(
        board: [
          [Player.none, Player.none, Player.none],
          [Player.none, Player.none, Player.none],
          [Player.none, Player.none, Player.none],
        ],
        state: Running(),
        turn: Player.first,
      );

  Game copyWith({Board? board, Player? turn, State? state}) {
    return Game(
      board: board ?? copyBoard(this.board),
      state: state ?? this.state.copy(),
      turn: turn ?? this.turn,
    );
  }

  @override
  String toString() => "Game { board: $board, state: $state, turn: $turn }";

  @override
  List<Object> get props => [board, state, turn];
}
