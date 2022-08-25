<p>
  <a title="Pub" href="https://pub.dev/packages/flame_steamworks" ><img src="https://img.shields.io/pub/v/flame_steamworks.svg?style=popout" /></a>
</p>

⚠️Until [this issue](https://github.com/dart-lang/sdk/issues/42816) is fixed, this package only support windows. There is a workaround though, you can generate platform specific api using https://github.com/aeb-dev/steamworks_gen

# flame_steamworks
A package that makes it possible to make a game in steam with flutter! It combines [steamworks](https://github.com/aeb-dev/steamworks) and [flame](https://github.com/flame-engine/flame).

&nbsp;

# Features
The goal of this library is to provide complete coverage possible over steam api. We can split functionality provided with the steam api into three categories:

- Initilization, common apis
- Asynchronous callbacks
- Asynchronous call results

You can get detailed information about these from the [steam docs](https://partner.steamgames.com/doc/sdk/api)

&nbsp;

# Requirements

You need to steam_api.dll and steam_api.lib to be able to use this package. You can either download from [here](https://partner.steamgames.com/?goto=%2Fdownloads%2Fsteamworks_sdk.zip) by signing in or you can use the files under the example. If you chose to download from steam, the files are under `redistributable_bin`.

&nbsp;

# How to use

## Flame Game Instance

First we need a game right! Lets make it.

```dart
class GameInstance extends FlameGame with KeyboardEvents, HasSteamClient {
  GameInstance() {
    init();  // it is important to call this to initialize steam api
  }
}
```

&nbsp;

## Registering for a callback

  `HasSteamClient` mixin provides a simple api to register a callback. You can register a callback in any place in the code
```dart
class GameInstance extends FlameGame with KeyboardEvents, HasSteamClient {
  GameInstance() {
    init();
    registerCallback<UnreadChatMessagesChanged>((data) => /*do what you want*/);
  }
}
```

There are many callbacks in steam api, you check all of them on steam docs.

&nbsp;

## Registering for a call result
`HasSteamClient` mixin provides a simple api to register a call result. Call results are a little different from callbacks. Before you subscribe to call result, you need to make a request and subscribe to result of that request.
```dart
class GameInstance extends FlameGame with KeyboardEvents, HasSteamClient {
  // We wait for space key to be pressed and if it is then we make a request for UserStatsReceived an subscribe to its result
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
```

There are many call results in steam api, you check all of them on steam docs.

&nbsp;

# What is next?
Well, steam is the limit!
