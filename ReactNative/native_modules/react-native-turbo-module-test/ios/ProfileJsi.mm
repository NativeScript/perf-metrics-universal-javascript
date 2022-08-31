#import "ProfileJsi.h"
#import <stdio.h>
#import <iostream>
#import <React/RCTBridge+Private.h>
#import <React/RCTUtils.h>
#import "TestFixturesNew.h"
#import <JSIProfileSpec/JSIProfileSpec.h>

#define UNUSED(x) (void)(x)

using namespace facebook;

@interface ProfileJsi() <NativeJSIProfileSpec>
@end

@implementation ProfileJsi

@synthesize bridge = _bridge;
@synthesize methodQueue = _methodQueue;
static TestFixturesNew *testFixtures;

RCT_EXPORT_MODULE()

- (std::shared_ptr<react::TurboModule>)getTurboModule:(const react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<react::NativeJSIProfileSpecJSI>(params);
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

- (void)methodWithBigData:(NSArray *)data {
    [testFixtures methodWithBigData:data];
}

- (NSString *)methodWithString:(NSString *)string {
    return [testFixtures methodWithString: string];
}

- (NSNumber *)methodWithXYZ:(double)x y:(double)y z:(double)z {
    return [NSNumber numberWithInt: [testFixtures methodWithX:(int32_t)x Y:(int32_t)y Z:(int32_t)z]];
}

@end
