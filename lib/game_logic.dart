import 'package:tic_tac_toe/extensions.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';

Board copyBoard(Board board) => board.map(BoardRow.from).toList();

Board transposeBoard(Board board) => zip(board).toList();

Iterable<Position> getBoardPositions(Board board) {
  return board
      .mapIndexed((rowIndex, row) => row.mapIndexed((colIndex, _) => Position(rowIndex, colIndex)))
      .expand((position) => position);
}

Board occupyPosition(Board board, Position position, Player player) {
  var newBoard = copyBoard(board);
  newBoard[position.x][position.y] = player;
  return newBoard;
}

Board genMove(Game game, Position position) => occupyPosition(game.board, position, game.turn);

bool positionOccupied(Board board, Position position, Player player) => board[position.x][position.y] == player;

bool positionUnoccupied(Board board, Position position) => positionOccupied(board, position, Player.none);

bool occupiedByFirstPlayer(Board board, Position position) => positionOccupied(board, position, Player.first);

bool occupiedBySecondPlayer(Board board, Position position) => positionOccupied(board, position, Player.second);

List<Position> getOccupiedPositions(Board board, bool Function(Board board, Position position) test) {
  Iterable<Position> positions = getBoardPositions(board);
  return positions.where((position) => test(board, position)).toList();
}

List<Position> getLegalMoves(Board board) => getOccupiedPositions(board, positionUnoccupied);
