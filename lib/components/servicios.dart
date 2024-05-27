bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x +
      (player.scale.x < 0 ? -hitbox.offsetX - hitbox.width : hitbox.offsetX);
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.size.x;
  final blockHeight = block.size.y;

  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      playerX < blockX + blockWidth &&
      playerX + playerWidth > blockX);
}
