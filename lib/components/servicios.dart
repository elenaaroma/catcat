bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.size.x;
  final blockHeight = block.size.y;

  final fixedX = player.scale.x < 0
      ? playerX - hitbox.width // Ajuste cuando el jugador está volteado
      : playerX;
  final fixedY = block.isPlatform ? playerY + hitbox.height : playerY;

  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
