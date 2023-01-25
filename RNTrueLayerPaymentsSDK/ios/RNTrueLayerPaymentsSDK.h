#import <React/RCTBridgeModule.h>
#ifdef RCT_NEW_ARCH_ENABLED
#import <RNTrueLayerPaymentsSDKSpec/RNTrueLayerPaymentsSDKSpec.h>
#endif

NS_ASSUME_NONNULL_BEGIN


@interface RNTrueLayerPaymentsSDK : NSObject <RCTBridgeModule>
@end

#ifdef RCT_NEW_ARCH_ENABLED
@interface RNTrueLayerPaymentsSDK () <NativeTrueLayerPaymentsSDKSpec>
@end
#endif

NS_ASSUME_NONNULL_END
