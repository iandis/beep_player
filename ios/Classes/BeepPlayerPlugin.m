#import "BeepPlayerPlugin.h"
#if __has_include(<beep_player/beep_player-Swift.h>)
#import <beep_player/beep_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "beep_player-Swift.h"
#endif

@implementation BeepPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBeepPlayerPlugin registerWithRegistrar:registrar];
}
@end
