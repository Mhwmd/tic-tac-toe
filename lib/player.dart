enum Player {
  none,
  first,
  second;

  Player get opponent {
    if (this == Player.first) return Player.second;
    if (this == Player.second) return Player.first;
    return Player.none;
  }
}
