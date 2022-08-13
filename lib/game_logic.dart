import 'package:tic_tac_toe/tic_tac_toe.dart';

Board copyBoard(Board board) => board.map(BoardRow.from).toList();

Board transposeBoard(Board board) => zip(board).toList();
