import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:banuba_sdk/banuba_sdk_method_channel.dart';

void main() {
  MethodChannelBanubaSdk platform = MethodChannelBanubaSdk();
  const MethodChannel channel = MethodChannel('banuba_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
