import 'package:flutter/foundation.dart';

class Application {
  /// [debugEnabled] is set to enable or disable select developer debugging
  /// tools regardless if a debug app or production app.
  static const enableDebug =
      bool.fromEnvironment('APP_ENABLE_DEBUG', defaultValue: false) ||
          kDebugMode;
}
