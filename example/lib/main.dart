import "dart:developer" as developer;
import "dart:io";

import "package:flame/game.dart";
import "package:flutter/material.dart";

import "game.dart";

Future<void> main() async {
  // Attempt to get the VM service URI and dump it to a file.
  try {
    final info = await developer.Service.getInfo();
    final uri = info.serverUri; // may be null if service not yet available
    if (uri != null) {
      await File("vmservice_info.txt").writeAsString("{ \"uri\": \"$uri\" }");
    }
  } catch (e) {
    // ignore or log somewhere safe
  }

  runApp(GameWidget(game: GameInstance()));
}
