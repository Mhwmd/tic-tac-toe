import 'package:tic_tac_toe/tic_tac_toe.dart';

Board copyBoard(Board board) => board.map(BoardRow.from).toList();

Board transposeBoard(Board board) => zip(board).toList();

Board occupyPosition(Board board, Position position, Player player) {
  var newBoard = copyBoard(board);
  newBoard[position.x][position.y] = player;
  return newBoard;
}

bool positionOccupied(Board board, Position position, Player player) => board[position.x][position.y] == player;

bool positionUnoccupied(Board board, Position position) => positionOccupied(board, position, Player.none);

bool occupiedByFirstPlayer(Board board, Position position) => positionOccupied(board, position, Player.first);

bool occupiedBySecondPlayer(Board board, Position position) => positionOccupied(board, position, Player.second);

Board genMove(Game game, Position position) => occupyPosition(game.board, position, game.turn);
