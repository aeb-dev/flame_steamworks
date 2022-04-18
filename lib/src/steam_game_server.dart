import "dart:ffi";

import "package:flame/game.dart";
import "package:steamworks/steamworks.dart";

/// A mixin to enable steam api for game server
mixin SteamGameServer on FlameGame {
  /// Instance of the [SteamServer] to access the steam api.
  /// Do not call this until [init] is called
  SteamServer get steamServer => SteamServer.instance;

  @override
  void update(double dt) {
    super.update(dt);

    steamServer.runFrame();
  }

  /// Initializes [SteamServer]. Call this
  /// function before calling any function
  void init(
    String ip, {
    int steamPort = 0,
    int gamePort = 27015,
    int queryPort = 27016,
    int serverMode = 3,
    String versionString = "1.0.0.0",
  }) {
    SteamServer.init(
      ip: ip,
      steamPort: steamPort,
      gamePort: gamePort,
      queryPort: queryPort,
      serverMode: serverMode,
      versionString: versionString,
    );
  }

  /// Registers a [Callback]
  Callback<T> registerCallback<T extends NativeType>(
    void Function(Pointer<T> data) cb,
  ) {
    Callback<T> callback = Callback<T>(
      cb: cb,
    );

    steamServer.registerCallback(callback);

    return callback;
  }

  /// Registers a [CallResult]
  CallResult<T> registerCallResult<T extends NativeType>(
    SteamApiCall asyncCallId,
    void Function(Pointer<T> data, bool hasFailed) cb,
  ) {
    CallResult<T> callResult = CallResult<T>(
      asyncCallId: asyncCallId,
      cb: cb,
    );

    steamServer.registerCallResult(callResult);

    return callResult;
  }

  /// Unregisters a [Callback]
  void unregisterCallback(
    Callback callback,
  ) {
    steamServer.unregisterCallback(callback);
  }

  /// Unregisters a [CallResult]
  void unregisterCallResult(
    CallResult callResult,
  ) {
    steamServer.unregisterCallResult(callResult);
  }
}
