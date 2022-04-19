# flame_steamworks
A package that makes it possible to make a game in steam with flutter! It combines [steamworks](https://github.com/aeb-dev/steamworks) and [flame](https://github.com/flame-engine/flame).

<p>
  <a title="Pub" href="https://pub.dev/packages/flame_steamworks" ><img src="https://img.shields.io/pub/v/flame_steamworks.svg?style=popout" /></a>
</p>

## Features
The goal of this library is to provide complete coverage possible over steam_api. We can split functionality provided with the steam api into three categories:

- Initilization, common apis
- Asynchronous callbacks
- Asynchronous call results

You can get detailed information about these from the [steam docs](https://partner.steamgames.com/doc/sdk/api)

## Requirements
- You need to steam_api.dll and steam_api.lib to be able to use this package. You can either download from [here](https://partner.steamgames.com/?goto=%2Fdownloads%2Fsteamworks_sdk.zip) by signing in or you can use the files under the example. If you chose to download from steam, the files are under `redistributable_bin`.

## How to use
- ### Flame Game Instance
First we need a game right! Lets make it.
```dart
class GameInstance extends FlameGame with SteamGame {
  GameInstance() {
    init();  // it is important to call this to initialize steam api
  }
}
```

- ### Accessing steam api

A reference to the steam api interfaces are provided inside the `SteamGame` mixin. You can access this anywhere in your game.
```dart
  class GameInstance extends FlameGame with SteamGame {

    @override
    void update(double dt) {
      super.update(dt);
      steamClient.steamFriends.activateGameOverlay("friends".toNativeUtf8());
    }
  }
```

- ### Registering for a callback

`SteamGame` mixin provides a simple api to register a callback
```dart
class GameInstance extends FlameGame with SteamGame {
  GameInstance() {
    init();  // it is important to call this to initialize steam api
    registerCallback<UnreadChatMessagesChanged>((data) => /*do what you want*/);
  }
}
```

There are many callbacks in steam api, you check all of them on steam docs.

- ### Registering for a call result
`SteamGame` mixin provides a simple api to register a call result. Call results are a little different from callbacks. Before you subscribe to call result, you need to make a request and subscribe to result of that request.
```dart
class GameInstance extends FlameGame with KeyboardEvents, SteamGame {
  // We wait for space key to be pressed and if it is then we make a request for UserStatsReceived an subscribe to its result
  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      CSteamId steamId = steamClient.steamUser.getSteamId();
      SteamApiCall callId = steamClient.steamUserStats.requestUserStats(steamId);

      CallResult cr = CallResult<UserStatsReceived>(
        asyncCallId: callId,
        cb: (ptrUserStatus, hasFailed) {
          print("User stats second");
          print("GameId: ${ptrUserStatus.gameId}");
          print("SteamIdUser: ${ptrUserStatus.steamIdUser}");
        },
      );

      registerCallResult(cr);

      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
```

There are many call results in steam api, you check all of them on steam docs.

## What is next?
Well, steam is the limit!
