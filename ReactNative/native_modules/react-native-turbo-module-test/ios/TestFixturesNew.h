//
//  TestFixture.h
//  Native
//
//  Created by Team nStudio on 6/22/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestFixturesNew : NSObject
- (int32_t)methodWithX:(int32_t)x Y:(int32_t)y Z:(int32_t)z;
- (int32_t)methodWithX:(int32_t)x;

- (NSString*)methodWithString:(NSString*)aString;

- (UIImage*)methodWithBigData:(NSArray*)array;
@end
