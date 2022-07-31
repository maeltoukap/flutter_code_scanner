#import "FlutterQrPlugin.h"

#if __has_include(<flutter_code_scanner/flutter_code_scanner-Swift.h>)
#import <flutter_code_scanner/flutter_code_scanner-Swift.h>
#else
#import "flutter_code_scanner-Swift.h"
#endif

@implementation FlutterQrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftFlutterQrPlugin registerWithRegistrar:registrar];
}
@end
