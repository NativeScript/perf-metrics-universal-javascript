#import <jsi/jsilib.h>
#import <jsi/jsi.h>
#import <React/RCTBridgeModule.h>
#import "TestFixturesNew.h"

@interface ProfileJsiOld : NSObject <RCTBridgeModule>

@property (nonatomic, assign) BOOL setBridgeOnMainQueue;

@end
