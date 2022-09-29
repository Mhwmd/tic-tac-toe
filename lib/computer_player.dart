import 'dart:math' as math;

import 'package:tic_tac_toe/utils.dart';

import 'game.dart';
import 'game_logic.dart';
import 'pair.dart';
import 'player.dart';
import 'types.dart';

// // Player.first as Ai Player
// // Player.second as player
Pair<int, Position> minimaxOptimization(
  Board board,
  Player player, [
  int depth = 0,
  int alpha = -1000,
  int beta = 1000,
]) {
  if (checkWin(board, Player.first)) return Pair(1000, Position(-1, -1));
  if (checkWin(board, Player.second)) return Pair(-1000, Position(-1, -1));
  if (!checkBoardForUnoccupied(board)) return Pair(0, Position(-1, -1));

  List<Position> legalMoves = getLegalMoves(board);
  if (legalMoves.length == 8) return Pair(0, randomChoice(legalMoves));

  legalMoves.shuffle();

  if (player == Player.first) {
    int bestScore = -1000;
    late Pair<int, Position> bestMove = Pair(bestScore, Position(-1, -1));
    for (Position currMove in legalMoves) {
      board[currMove.x][currMove.y] = player;

      int score = minimaxOptimization(board, Player.second, depth + 1, alpha, beta).first;
      if (bestScore < score) {
        bestScore = score - depth * 10;
        bestMove = Pair(bestScore, currMove);
      }
      board[currMove.x][currMove.y] = Player.none;
      if (math.max(alpha, bestScore) <= alpha) break;
    }
    return bestMove;
  } else {
    int bestScore = 1000;
    late Pair<int, Position> bestMove = Pair(bestScore, Position(-1, -1));
    for (Position currMove in legalMoves) {
      board[currMove.x][currMove.y] = player;
      int score = minimaxOptimization(board, Player.first, depth + 1, alpha, beta).first;
      if (bestScore > score) {
        bestScore = score + depth * 10;
        bestMove = Pair(bestScore, currMove);
      }
      board[currMove.x][currMove.y] = Player.none;
      if (beta <= math.min(alpha, bestScore)) break;
    }
    return bestMove;
  }
}

Game playAsComputer(Game game, Position Function(Board board, Player player) intelligence) {
  return runMove(game, intelligence(game.board, game.turn));
}

Position hardComputerPlayer(Board board, Player player) {
  return minimaxOptimization(copyBoard(board), Player.first).second;
}

Position easyComputerPlayer(Board board) {
  return pickRandomMove(board);
}

Position pickRandomMove(Board board) {
  List<Position> legalMoves = getLegalMoves(board);
  return randomChoice(legalMoves);
}
