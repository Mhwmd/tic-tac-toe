import 'package:tic_tac_toe/tic_tac_toe.dart';

Board copyBoard(Board board) => board.map(BoardRow.from).toList();

Board transposeBoard(Board board) => zip(board).toList();

Board occupyPosition(Board board, Position position, Player player) {
  var newBoard = copyBoard(board);
  newBoard[position.x][position.y] = player;
  return newBoard;
}

Board genMove(Game game, Position position) => occupyPosition(game.board, position, game.turn);
