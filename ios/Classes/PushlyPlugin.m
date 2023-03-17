#import "PushlyPlugin.h"
#if __has_include(<pushly_pushsdk/pushly_pushsdk-Swift.h>)
#import <pushly_pushsdk/pushly_pushsdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pushly_pushsdk-Swift.h"
#endif

@implementation PushlyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPushlyPlugin registerWithRegistrar:registrar];
}
@end
