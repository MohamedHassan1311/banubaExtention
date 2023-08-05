//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<agora_rtc_engine/AgoraRtcNgPlugin.h>)
#import <agora_rtc_engine/AgoraRtcNgPlugin.h>
#else
@import agora_rtc_engine;
#endif

#if __has_include(<banuba_sdk/BanubaSdkPlugin.h>)
#import <banuba_sdk/BanubaSdkPlugin.h>
#else
@import banuba_sdk;
#endif

#if __has_include(<iris_method_channel/IrisMethodChannelPlugin.h>)
#import <iris_method_channel/IrisMethodChannelPlugin.h>
#else
@import iris_method_channel;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AgoraRtcNgPlugin registerWithRegistrar:[registry registrarForPlugin:@"AgoraRtcNgPlugin"]];
  [BanubaSdkPlugin registerWithRegistrar:[registry registrarForPlugin:@"BanubaSdkPlugin"]];
  [IrisMethodChannelPlugin registerWithRegistrar:[registry registrarForPlugin:@"IrisMethodChannelPlugin"]];
}

@end
