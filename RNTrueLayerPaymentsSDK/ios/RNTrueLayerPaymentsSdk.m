
#import "RNTrueLayerPaymentsSdk.h"

@implementation RNTrueLayerPaymentsSdk

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE("TrueLayerPaymentsSDK")

@end
  