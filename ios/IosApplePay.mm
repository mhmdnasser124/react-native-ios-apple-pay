#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(ApplePay, NSObject)

RCT_EXTERN_METHOD(makePayment:(nonnull NSNumber *)total
                  currencyCode:(NSString *)currencyCode
                  merchantId:(NSString *)merchantId
                  countryCode:(NSString *)countryCode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(canMakePayments:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject)


+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end