// ignore_for_file: public_member_api_docs, avoid_print

import "package:flame/game.dart";
import "package:flame/input.dart";
import "package:flame_steamworks/flame_steamworks.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:steamworks/steamworks.dart";

class GameInstance extends FlameGame
    with FPSCounter, KeyboardEvents, HasSteamClient {
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

    textPaint.render(
      canvas,
      "# of chat events received: $count",
      Vector2(5, 40),
    );
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    bool isKeyDown = event is RawKeyDownEvent;

    bool isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      CSteamId steamId = steamClient.steamUser.getSteamId();
      SteamApiCall callId =
          steamClient.steamUserStats.requestUserStats(steamId);

      registerCallResult<UserStatsReceived>(
        callId,
        (ptrUserStatus, hasFailed) {
          print("User stats received");
          print("GameId: ${ptrUserStatus.gameId}");
          print("SteamIdUser: ${ptrUserStatus.steamIdUser}");
        },
      );

      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
