import 'package:test/test.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';

void main() {
  group("Equality", () {
    test("Running State object", () {
      expect(Running(), Running());
    });

    test("GameOver State object", () {
      State state1 = GameOver(Player.none);
      State state2 = GameOver(Player.none);
      expect(state1, state2);

      State state3 = GameOver(Player.first);
      State state4 = GameOver(Player.second);

      expect(state3, isNot(state4));
    });

    test("Game Object", () {
      Game gameObject1 = Game.initialGame;

      Game gameObject2 = Game(board: [
        [Player.none, Player.none, Player.none],
        [Player.none, Player.none, Player.none],
        [Player.none, Player.none, Player.none],
      ], state: Running(), turn: Player.first);

      expect(gameObject1, gameObject2);

      gameObject1 = Game(board: [
        [Player.none, Player.first, Player.none],
        [Player.none, Player.none, Player.none],
        [Player.none, Player.none, Player.first],
      ], state: Running(), turn: Player.second);

      gameObject2 = Game(board: [
        [Player.none, Player.none, Player.none],
        [Player.none, Player.none, Player.none],
        [Player.none, Player.none, Player.none],
      ], state: Running(), turn: Player.second);

      expect(gameObject1, isNot(gameObject2));
    });
  });

  test("Copy board", () {
    Board board = [
      [Player.none, Player.none, Player.none],
      [Player.none, Player.none, Player.none],
      [Player.none, Player.none, Player.none]
    ];

    Board newBoard = copyBoard(board);

    expect(board, newBoard);

    newBoard[0][1] = Player.first;

    expect(board, isNot(newBoard));
  });

  test("Get positions on board", () {
    Board board = [
      [Player.none, Player.none, Player.none],
      [Player.none, Player.none, Player.none],
      [Player.none, Player.none, Player.none]
    ];

    expect(getBoardPositions(board), [
      Position(0, 0),
      Position(0, 1),
      Position(0, 2),
      Position(1, 0),
      Position(1, 1),
      Position(1, 2),
      Position(2, 0),
      Position(2, 1),
      Position(2, 2),
    ]);

    Board board1 = [
      [Player.none, Player.first],
      [Player.first],
      [Player.none, Player.second, Player.first],
      [Player.second]
    ];

    expect(getBoardPositions(board1), [
      Position(0, 0),
      Position(0, 1),
      Position(1, 0),
      Position(2, 0),
      Position(2, 1),
      Position(2, 2),
      Position(3, 0),
    ]);
  });

  test("Transpose board (swap rows with columns)", () {
    Board board3x3 = [
      [Player.none, Player.first, Player.none],
      [Player.none, Player.first, Player.second],
      [Player.second, Player.none, Player.none]
    ];

    expect(transposeBoard(board3x3), [
      [Player.none, Player.none, Player.second],
      [Player.first, Player.first, Player.none],
      [Player.none, Player.second, Player.none]
    ]);

    Board board2x2 = [
      [Player.none, Player.second],
      [Player.second, Player.first],
    ];

    expect(transposeBoard(board2x2), board2x2);

    Board board2x3 = [
      [Player.none, Player.none, Player.first],
      [Player.second, Player.second, Player.first],
    ];

    expect(transposeBoard(board2x3), [
      [Player.none, Player.second],
      [Player.none, Player.second],
      [Player.first, Player.first],
    ]);

    Board board3x2 = [
      [Player.none, Player.first],
      [Player.second, Player.none],
      [Player.first, Player.second],
    ];

    expect(transposeBoard(board3x2), [
      [Player.none, Player.second, Player.first],
      [Player.first, Player.none, Player.second],
    ]);

    expect(transposeBoard(transposeBoard(board3x2)), board3x2);
  });

  group("Occupy board cell to player on the specific position", () {
    test("Opponent player", () {
      Player firstPlayer = Player.first;
      Player secondPlayer = firstPlayer.opponent;

      expect(secondPlayer, Player.second);
      expect(secondPlayer.opponent, Player.first);
      expect(Player.none, Player.none);
    });

    test("Check position occupied", () {
      Board board = [
        [Player.none, Player.none, Player.second],
        [Player.first, Player.first, Player.none],
        [Player.none, Player.second, Player.none]
      ];
      List<Position> nonePlayer = [Position(0, 0), Position(0, 1), Position(1, 2), Position(2, 0), Position(2, 2)];
      List<Position> firstPlayer = [Position(1, 0), Position(1, 1)];
      List<Position> secondPlayer = [Position(0, 2), Position(2, 1)];

      expect(nonePlayer.any((position) => positionOccupied(board, position, Player.first)), false);
      expect(nonePlayer.any((position) => occupiedByFirstPlayer(board, position)), false);

      expect(nonePlayer.every((position) => positionOccupied(board, position, Player.none)), true);
      expect(firstPlayer.every((position) => positionOccupied(board, position, Player.first)), true);
      expect(secondPlayer.every((position) => positionOccupied(board, position, Player.second)), true);

      expect(nonePlayer.every((position) => positionUnoccupied(board, position)), true);
      expect(firstPlayer.every((position) => occupiedByFirstPlayer(board, position)), true);
      expect(secondPlayer.every((position) => occupiedBySecondPlayer(board, position)), true);
    });

    test("Get occupied positions according to player", () {
      Board board = [
        [Player.none, Player.none, Player.second],
        [Player.first, Player.first, Player.none],
        [Player.none, Player.second, Player.none]
      ];

      List<Position> nonePlayer = [Position(0, 0), Position(0, 1), Position(1, 2), Position(2, 0), Position(2, 2)];
      List<Position> firstPlayer = [Position(1, 0), Position(1, 1)];
      List<Position> secondPlayer = [Position(0, 2), Position(2, 1)];

      expect(getOccupiedPositions(board, positionUnoccupied), nonePlayer);
      expect(getOccupiedPositions(board, occupiedByFirstPlayer), firstPlayer);
      expect(getOccupiedPositions(board, occupiedBySecondPlayer), secondPlayer);
      expect(getOccupiedPositions(board, positionUnoccupied), getLegalMoves(board));
    });

    test("Occupy position", () {
      Board board = Game.initialGame.board;
      Board newBoard = occupyPosition(board, Position(0, 1), Player.first);

      // check no side effects
      expect(board, Game.initialGame.board);

      //check new board has changed
      expect(newBoard, isNot(board));

      expect(newBoard[0][1], Player.first);
    });

    test("Occupy position according to player turn", () {
      Game initialGame = Game.initialGame;

      // occupy position [0][1] with player who start first and change turn to opponent player.
      Game game = initialGame.copyWith(board: genMove(initialGame, Position(0, 1)), turn: initialGame.turn.opponent);

      //check board has changed.
      expect(initialGame.board, isNot(game.board));

      //check position has changed
      expect(initialGame.board[0][1], isNot(game.board[0][1]));

      //check position [0][1] has changed to player turn.
      expect(initialGame.turn, game.board[0][1]);

      game = game.copyWith(board: genMove(game, Position(1, 1)));

      //check position [0][1] has changed to player turn.
      expect(initialGame.turn, game.board[0][1]);

      //check position [1][1] has changed to opponent player.
      expect(initialGame.turn.opponent, game.board[1][1]);
    });
  });

  group("Board diagonals", () {
    Board board3x3 = [
      [Player.first, Player.none, Player.none],
      [Player.none, Player.first, Player.none],
      [Player.none, Player.none, Player.first],
    ];

    Board board5x5 = [
      [Player.first, Player.none, Player.none, Player.none, Player.none],
      [Player.none, Player.first, Player.none, Player.none, Player.none],
      [Player.none, Player.none, Player.first, Player.none, Player.none],
      [Player.none, Player.none, Player.none, Player.first, Player.none],
      [Player.none, Player.none, Player.none, Player.none, Player.first],
    ];

    test("Left diagonal", () {
      expect(getLeftDiagonal(board3x3), [Player.first, Player.first, Player.first]);
      expect(getLeftDiagonal(board5x5), [Player.first, Player.first, Player.first, Player.first, Player.first]);
    });

    test("Right diagonal", () {
      expect(getRightDiagonal(board3x3), [Player.none, Player.first, Player.none]);
      expect(getRightDiagonal(board5x5), [Player.none, Player.none, Player.first, Player.none, Player.none]);
    });
  });

  group("Check wins", () {
    Board board3x3 = [
      [Player.second, Player.none, Player.none],
      [Player.none, Player.second, Player.none],
      [Player.first, Player.first, Player.first],
    ];
    test("Check row for win by player", () {
      expect(checkRowForWin(board3x3[2], Player.first), isTrue);
      expect(checkRowForWin(board3x3[2], Player.second), isFalse);
      expect(checkRowForWin(board3x3[0], Player.second), isFalse);
      expect(checkRowForWin(board3x3[0], Player.first), isFalse);
    });

    test("check player has win in any rows", () {
      expect(checkRowsForWin(board3x3, Player.first), isTrue);
      expect(checkRowsForWin(board3x3, Player.second), isFalse);
    });

    test("check player has win in any columns", () {
      expect(checkRowsForWin(transposeBoard(board3x3), Player.first), isFalse);
      expect(checkRowsForWin(transposeBoard(board3x3), Player.second), isFalse);
    });

    group("Check player wins in diagonal sides", () {
      Board board3x3 = [
        [Player.first, Player.none, Player.second],
        [Player.none, Player.second, Player.none],
        [Player.second, Player.first, Player.first],
      ];

      test("Left diagonal wins", () {
        expect(checkRowForWin(getLeftDiagonal(board3x3), Player.first), isFalse);
        expect(checkRowForWin(getLeftDiagonal(board3x3), Player.second), isFalse);
      });

      test("Right diagonal wins", () {
        expect(checkRowForWin(getRightDiagonal(board3x3), Player.first), isFalse);
        expect(checkRowForWin(getRightDiagonal(board3x3), Player.second), isTrue);
      });

      test("Check player wins in any diagonal sides", () {
        expect(checkWinDiagonalSides(board3x3, Player.first), isFalse);
        expect(checkWinDiagonalSides(board3x3, Player.second), isTrue);
      });
    });

    test("Check player wins in any rows, columns and diagonal sides", () {
      expect(checkWin(board3x3, Player.first), isTrue);
      expect(checkWin(board3x3, Player.second), isFalse);
    });
  });

  group("Check unoccupied", () {
    test("Check row has any unoccupied", () {
      expect(checkRowForUnoccupied([Player.first, Player.second, Player.none]), isTrue);
      expect(checkRowForUnoccupied([Player.first, Player.second, Player.first]), isFalse);
      expect(checkRowForUnoccupied([]), isFalse);
    });
    test("Check board for any unoccupied", () {
      expect(
        checkBoardForUnoccupied([
          [Player.first, Player.second, Player.none],
          [Player.first, Player.second, Player.first]
        ]),
        isTrue,
      );

      expect(
        checkBoardForUnoccupied([
          [Player.first, Player.second, Player.first],
          [Player.first, Player.second, Player.first]
        ]),
        isFalse,
      );
    });
  });

  test("Check draw (tie)", () {
    expect(
      checkDraw([
        [Player.first, Player.first, Player.second],
        [Player.second, Player.second, Player.first],
        [Player.first, Player.first, Player.second]
      ]),
      isTrue,
    );
    expect(
      checkDraw([
        [Player.first, Player.none, Player.second],
        [Player.none, Player.second, Player.first],
        [Player.first, Player.first, Player.second]
      ]),
      isFalse,
    );
  });

  group("Game change state and turns", () {
    Game game = Game.initialGame;

    test("Flip players turn", () {
      Game nextGame = changeTurn(game);

      expect(nextGame.turn, game.turn.opponent);
      expect(nextGame.board, game.board);
      expect(nextGame.state, game.state);
    });

    test("Running state", () {
      State state = handleRunning(game.copyWith(state: GameOver(Player.first))).state;
      expect(state, TypeMatcher<Running>());
    });

    group("GameOver state", () {
      test("GameOver by player win", () {
        State state = handleWin(game).state;
        expect(state, TypeMatcher<GameOver>().having((p0) => p0.player, "player", game.turn));
      });
      test("GameOver by draw (no players win)", () {
        State state = handleDraw(game).state;
        expect(state, TypeMatcher<GameOver>().having((p0) => p0.player, "player", Player.none));
      });
    });
  });

  test("Occupy player by turn", () {
    Game game = Game.initialGame;
    game = runMove(game, Position(0, 1));
    expect(game.board[0][1], game.turn);

    game = changeTurn(game);
    game = runMove(game, Position(2, 2));

    expect(game.board[2][2], game.turn);

    expect(game.board[0][1], game.turn.opponent);
  });
}
