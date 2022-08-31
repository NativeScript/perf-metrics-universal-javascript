#import <jsi/jsilib.h>
#import <jsi/jsi.h>
#import <React/RCTBridgeModule.h>
#import "TestFixturesNew.h"

@interface ProfileJsi : NSObject <RCTBridgeModule>

@property (nonatomic, assign) BOOL setBridgeOnMainQueue;

- (void)install:(facebook::jsi::Runtime &)runtime;
- (void)cleanUp:(facebook::jsi::Runtime &)runtime;

@end
