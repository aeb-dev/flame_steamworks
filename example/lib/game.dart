// ignore_for_file: public_member_api_docs, avoid_print

import "package:flame/components.dart";
import "package:flame/game.dart";
import "package:flame/input.dart";
import "package:flame_steamworks/flame_steamworks.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:steamworks/steamworks.dart";

class GameInstance extends FlameGame with KeyboardEvents, HasSteamClient {
  TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 18.0,
      fontFamily: "Awesome Font",
      color: Colors.red,
    ),
  );

  int count = 0;

  GameInstance() {
    add(FpsTextComponent());
    init();
    registerCallback<UnreadChatMessagesChanged>((data) => ++count);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    textPaint.render(
      canvas,
      "# of chat events received: $count",
      Vector2(5, 40),
    );
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    bool isKeyDown = event is KeyDownEvent;

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
