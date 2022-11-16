#import "RTNTrueLayerPaymentsSDKSpec.h"
#import "RTNTrueLayerPaymentsSDK.h"

@implementation RTNTrueLayerPaymentsSDK

RCT_EXPORT_MODULE()

- (NSString *)configureSDK {
    return @"LOGGING FROM SDK";
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTrueLayerPaymentsSDKSpecJSI>(params);
}

@end