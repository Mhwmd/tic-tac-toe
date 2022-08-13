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
}
