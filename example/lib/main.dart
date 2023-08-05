import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:banuba_sdk/banuba_sdk.dart';
var AGORA_APP_ID =
    "5a363832ded74366bcf981eb9e46203c"; // 'e68dcc8fcf214eecacf76f7c44111bab';
final banubaLicenseToken=
    "UmOiJn4Fsd2lk02m96znXTRKfl6KoEI4M7W1GH3HmBnIrkvZ5UFkfyXBArfdDPJ+ruILLhDjOrIbQji4RQLoFqZ6zIvTZOOVAcdrM/qGgzdNiv1jLHq12mexlUOOm7mxDBeuccYFsN5AggiYDzhEQAD42AxMTvFOvMP+3tmO8h9yOzUbFjK4AlOFL0jWE703NrxoOfEsutDUKdPo033OM1ZzcFD8Er/iWUOAxirSrx7oG608g4r/bZYKtoxZp2Pp2Hs/r+Id2/7WwqUx4N3+g75l5B1UwBsQv73urcNXlx4AeW+3p5opSq9L4TGg0+ZrRBvzffK5uUkZyaDTNmyca7Bxn4Xq9RAcNUtdijPckDB9Z1kGxCTsnEtYif1xEk0tEfAfowi5yzbo7N2XajwXILQu8/PoWZnnRxZ4o59cfcl41A8Ohwmc0o7Tek5pHZ/RJULO4rdBK9vtONV+0xsmnpXzoWRg4curzydcK+E+8VW3vUtvRFjRcS900u0Ot1JZWXhfB5x/4hTnFKzez3PKcvLzahAgNV1JNsg=";
const channel = "<-- Insert Channel Name -->";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _banubaSdkManager = BanubaSdkManager();
  final _epWidget = EffectPlayerWidget(key: null);
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  @override
  void initState() {
    super.initState();
    // initPlatformState();
    initAgoraRtcEngineForHost();
  }
  RtcEngine? engine;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    await _banubaSdkManager.initialize([],
        "Place Token here",
        SeverityLevel.info);
    await _banubaSdkManager.initializeExtension(engine,
        "Place Token here",
        SeverityLevel.info);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
    // await _banubaSdkManager.openCamera();
    // await _banubaSdkManager.attachWidget(_epWidget.banubaId);

    await _banubaSdkManager.startPlayer();
    await _banubaSdkManager.loadEffect("effects/TrollGrandma");
  }
  Future<void> initAgoraRtcEngineForHost() async {
    print("CallCubit | _initAgoraRtcEngine");

    engine = createAgoraRtcEngine();
    await engine?.initialize(RtcEngineContext(
      appId: AGORA_APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));



    // Enable video

    await engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await engine?.enableExtension(provider: "BANUBA_PROVIDER_NAME", extension: "BANUBA_EXTENSION_NAME",enable: true,type:MediaSourceType.primaryCameraSource );
    await engine?.setExtensionProperty(provider: "BNBKeyVendorName", extension: "BNBKeyExtensionName", key: "BNBKeyLoadEffect", value: banubaLicenseToken);

    await engine?.enableFaceDetection(true);
    await engine?.enableFaceDetection(true);
    await engine?.enableVideo();
    await engine?.enableLocalVideo(true);
    await engine?.startPreview();
    await engine?.setExtensionProviderProperty(provider: "BNBKeyVendorName", key: "BNBKeyLoadEffect", value: banubaLicenseToken);
    await _banubaSdkManager.initializeExtension(engine,
        banubaLicenseToken,
        SeverityLevel.info);
// print("value $value");






    await    _banubaSdkManager.startPlayer();
    await _banubaSdkManager.loadEffect("effects/ActionunitsGrout");


  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _banubaSdkManager.startPlayer();
    } else {
      _banubaSdkManager.stopPlayer();
    }
  }
}
