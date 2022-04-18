// ignore_for_file: public_member_api_docs

import "package:flame/game.dart";
import "package:flame_steamworks/flame_steamworks.dart";
import "package:flutter/material.dart";
import "package:steamworks/steamworks.dart";

class GameInstance extends FlameGame with FPSCounter, SteamGame {
  TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 18.0,
      fontFamily: "Awesome Font",
      color: Colors.red,
    ),
  );

  int count = 0;

  GameInstance() {
    init();
    registerCallback<UnreadChatMessagesChanged>((data) => ++count);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    textPaint.render(canvas, "fps: ${fps()}", Vector2(5, 20));

    textPaint.render(canvas, "# of events received: $count", Vector2(5, 40));
  }
}
