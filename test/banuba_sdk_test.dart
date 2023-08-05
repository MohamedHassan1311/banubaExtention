import 'package:flutter_test/flutter_test.dart';
import 'package:banuba_sdk/banuba_sdk.dart';
import 'package:banuba_sdk/banuba_sdk_platform_interface.dart';
import 'package:banuba_sdk/banuba_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBanubaSdkPlatform
    with MockPlatformInterfaceMixin
    implements BanubaSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BanubaSdkPlatform initialPlatform = BanubaSdkPlatform.instance;

  test('$MethodChannelBanubaSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBanubaSdk>());
  });

  test('getPlatformVersion', () async {
    BanubaSdk banubaSdkPlugin = BanubaSdk();
    MockBanubaSdkPlatform fakePlatform = MockBanubaSdkPlatform();
    BanubaSdkPlatform.instance = fakePlatform;

    expect(await banubaSdkPlugin.getPlatformVersion(), '42');
  });
}
