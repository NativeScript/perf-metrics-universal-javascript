#import "ProfileJsiOld.h"
#import <stdio.h>
#import <iostream>
#import <React/RCTBridge+Private.h>
#import <React/RCTUtils.h>
#import "TestFixturesNew.h"

#define UNUSED(x) (void)(x)

using namespace facebook;

@implementation ProfileJsiOld

@synthesize bridge = _bridge;
@synthesize methodQueue = _methodQueue;
static TestFixturesNew *testFixtures;

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(jsinstall) {
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
  [self install:*(facebook::jsi::Runtime *)cxxBridge.runtime];
  return @true;
}

- (void)setBridge:(RCTBridge *)bridge
{
  std::cout << "aaa setBridge JSI module" << "\n";
  _bridge = bridge;
  _setBridgeOnMainQueue = RCTIsMainQueue();

  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
  if (!cxxBridge.runtime) {
    return;
  }
}

- (void)invalidate {
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
  [self cleanUp:*(facebook::jsi::Runtime *)cxxBridge.runtime];
}

- (void)cleanUp:(jsi::Runtime &)runtime {
  // We can't simply delete properties as far as I can tell, but let's at least try to set them back to undefined.
  runtime.global().setProperty(runtime, "multiplyJsi", jsi::Value::undefined());
  runtime.global().setProperty(runtime, "concatStrJsi", jsi::Value::undefined());
}

- (void)install:(jsi::Runtime &)runtime {
  std::cout << "aaa Initialising JSI module" << "\n";
  
  testFixtures = [[TestFixturesNew alloc] init];
  
    auto marshalMethodWithXYZHostFunction = [] (jsi::Runtime& _runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
      
      int32_t result = [testFixtures methodWithX:(int32_t)arguments[0].asNumber() Y:(int32_t)arguments[1].asNumber() Z:(int32_t)arguments[2].asNumber()];
//      return jsi::String::createFromUtf8(_runtime, [result cStringUsingEncoding:NSUTF8StringEncoding]);
      return jsi::Value(result);
    };
    auto marshalMethodWithXYZJsiFunction = jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "methodWithXYZ"), 3, marshalMethodWithXYZHostFunction);
    runtime.global().setProperty(runtime, "methodWithXYZ", std::move(marshalMethodWithXYZJsiFunction));
  
  
  auto marshalMethodWithStringHostFunction = [] (jsi::Runtime& _runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    
    NSString* result = [testFixtures methodWithString: [NSString stringWithUTF8String: arguments[0].asString(_runtime).utf8(_runtime).c_str()]];

      return jsi::String::createFromUtf8(_runtime, [result UTF8String]);
  };
  auto marshalMethodWithStringJsiFunction = jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "methodWithString"), 1, marshalMethodWithStringHostFunction);
  runtime.global().setProperty(runtime, "methodWithString", std::move(marshalMethodWithStringJsiFunction));
  
  auto marshalMethodWithStringArrayBufferHostFunction = [] (jsi::Runtime& _runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    
    auto ab = arguments[0].getObject(_runtime).getArrayBuffer(_runtime);
    char * str = reinterpret_cast<char *>(ab.data(_runtime));
    
    NSString* result = [testFixtures methodWithString: [NSString stringWithUTF8String: str]];

      return jsi::String::createFromUtf8(_runtime, [result UTF8String]);
  };
  auto marshalMethodWithStringArrayBufferJsiFunction = jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "methodWithStringAsArrayBuffer"), 1, marshalMethodWithStringArrayBufferHostFunction);
  runtime.global().setProperty(runtime, "methodWithStringAsArrayBuffer", std::move(marshalMethodWithStringArrayBufferJsiFunction));
  
  
  
  auto marshalMethodWithBigDataHostFunction = [] (jsi::Runtime& _runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    
    auto array = arguments[0].asObject(_runtime).asArray(_runtime);
    NSMutableArray* nsArray = [NSMutableArray new];
    size_t size = array.size(_runtime);
    for (int i = 0; i < size; i++) {
      [nsArray addObject: [NSNumber numberWithInt: (int32_t)array.getValueAtIndex(_runtime, i).asNumber()]];
    }
    [testFixtures methodWithBigData:nsArray];
    return jsi::Value::undefined();
  };
  auto marshalMethodWithBigDataJsiFunction = jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "methodWithBigData"), 1, marshalMethodWithBigDataHostFunction);
  runtime.global().setProperty(runtime, "methodWithBigData", std::move(marshalMethodWithBigDataJsiFunction));

  
  auto marshalMethodWithBigDataArrayBufferHostFunction = [] (jsi::Runtime& _runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    
    auto array = arguments[0].asObject(_runtime).getArrayBuffer(_runtime);
    NSMutableArray* nsArray = [NSMutableArray new];
    size_t size = array.size(_runtime);
    uint8_t * ab = array.data(_runtime);
    for (int i = 0; i < size; i++) {
      [nsArray addObject: [NSNumber numberWithInt: ab[i]]];
    }
    [testFixtures methodWithBigData:nsArray];
    return jsi::Value::undefined();
  };
  auto marshalMethodWithBigDataArrayBufferJsiFunction = jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "methodWithBigDataArrayBuffer"), 1, marshalMethodWithBigDataArrayBufferHostFunction);
  runtime.global().setProperty(runtime, "methodWithBigDataArrayBuffer", std::move(marshalMethodWithBigDataArrayBufferJsiFunction));
}

@end
