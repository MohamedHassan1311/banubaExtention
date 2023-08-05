import 'package:pigeon/pigeon.dart';

enum SeverityLevel {
  debug,
  info,
  warning,
  error,
}

/// An entry point to Banuba SDK
@HostApi()
abstract class BanubaSdkManager {
  /// Intialize common banuba SDK resources. This must be called before any
  /// other call. Counterpart `deinitialize` exists.
  ///
  /// parameter resourcePath: paths to cutom resources folders
  /// parameter clientTokenString: client token
  /// parameter logLevel: log level
  static void initialize(List<String> resourcePath, String clientTokenString,
      SeverityLevel logLevel) {}

  /// Release common Banuba SDK resources.
  static void deinitialize() {}

  void attachWidget(int banubaId);
  void openCamera();
  void startPlayer();
  void stopPlayer();
  void loadEffect(String path);
  void evalJs(String script);
}
