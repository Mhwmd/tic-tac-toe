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

BoardRow getLeftDiagonal(Board board) => getDiagonal(board, (row, i) => row[i]);

BoardRow getRightDiagonal(Board board) => getDiagonal(board, (row, i) => row[board.length - 1 - i]);

BoardRow getDiagonal(Board board, Player Function(BoardRow row, int i) operation) {
  int i = 0;
  return board.fold<BoardRow>([], (previousValue, row) {
    previousValue.add(operation(row, ++i - 1));
    return previousValue;
  });
}

bool checkRowForUnoccupied(BoardRow row) => row.any((val) => val == Player.none);

bool checkBoardForUnoccupied(Board board) => board.any(checkRowForUnoccupied);

bool checkDraw(Board board) => !checkBoardForUnoccupied(board);

bool checkRowForWin(BoardRow row, Player player) => row.every((val) => val == player);

bool checkRowsForWin(Board board, Player player) => board.any((row) => checkRowForWin(row, player));

bool checkWinDiagonalSides(Board board, Player player) {
  return checkRowForWin(getLeftDiagonal(board), player) || checkRowForWin(getRightDiagonal(board), player);
}

bool checkWin(Board board, Player player) {
  return checkRowsForWin(board, player) ||
      checkRowsForWin(transposeBoard(board), player) ||
      checkWinDiagonalSides(board, player);
}

Game changeTurn(Game game) => game.copyWith(turn: game.turn.opponent);

Game handleWin(Game game) => game.copyWith(state: GameOver(game.turn));

Game handleDraw(Game game) => game.copyWith(state: const GameOver(Player.none));

Game handleRunning(Game game) => game.copyWith(state: const Running());
