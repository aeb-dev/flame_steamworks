import "dart:ffi";

import "package:flame/game.dart";
import "package:steamworks/steamworks.dart";

/// A mixin to enable steam api for game client
mixin HasSteamClient on FlameGame {
  /// Instance of the [SteamClient] to access the steam api
  /// Do not call this until [init] is called
  SteamClient get steamClient => SteamClient.instance;

  @override
  void update(double dt) {
    super.update(dt);

    steamClient.runFrame();
  }

  /// Initializes [SteamClient]. Call this
  /// function before calling any function
  void init() {
    SteamClient.init();
  }

  /// Registers a [Callback]
  Callback<T> registerCallback<T extends NativeType>(
    void Function(Pointer<T> data) cb,
  ) =>
      steamClient.registerCallback(
        cb: cb,
      );

  /// Registers a [CallResult]
  CallResult<T> registerCallResult<T extends NativeType>(
    SteamApiCall asyncCallId,
    void Function(Pointer<T> data, bool hasFailed) cb,
  ) =>
      steamClient.registerCallResult(
        asyncCallId: asyncCallId,
        cb: cb,
      );

  /// Unregisters a [Callback]
  void unregisterCallback(
    Callback callback,
  ) =>
      steamClient.unregisterCallback(
        callback: callback,
      );

  /// Unregisters a [CallResult]
  void unregisterCallResult(
    CallResult callResult,
  ) =>
      steamClient.unregisterCallResult(
        callResult: callResult,
      );
}
