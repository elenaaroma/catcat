bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.size.x;
  final playerHeight = player.size.y;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.size.x;
  final blockHeight = block.size.y;

  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      playerX < blockX + blockWidth &&
      playerX + playerWidth > blockX);
}
