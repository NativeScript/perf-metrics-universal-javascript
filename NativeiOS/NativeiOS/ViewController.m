//
//  ViewController.m
//  NativeiOS
//
//  Created by Team nStudio on 8/3/22.
//

#import "ViewController.h"
#import "TestFixtures.h"
#import "GlobalTime.h"

@interface ViewController ()

-(void)runBenchmarks:(UIButton*)sender;
-(void)measurePerf:(NSString*)name action: (void (^)(void))action;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(runBenchmarks:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(52, 252, 215, 40)];
    [button setTitle:@"Run Bechmarks" forState:UIControlStateNormal];
    button.center = self.view.center;
    [button setExclusiveTouch:YES];
    [self.view addSubview:button];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"View did appear time %f ms", (CACurrentMediaTime() - AppStartTime) * 1000.0);
}

- (void)runBenchmarks:(UIButton*)sender {
        [self measurePerf:@"Primitives" action: ^void() {
            id instance = [[TestFixtures alloc] init];
            for (int32_t i = 0; i < 1e6; i++) {
                [instance methodWithX:i Y:i Z:i];
            }
        }];
        
        [self measurePerf:@"Strings" action: ^void() {
            id instance = [[TestFixtures alloc] init];
    
            NSMutableArray* strings = [NSMutableArray array];
    
            for (int32_t i = 0; i < 100; i++) {
                [strings addObject:[NSString stringWithFormat:@"abcdefghijklmnopqrstuvwxyz%d", i]];
            }
    
            for (int32_t i = 0; i < 100000; i++) {
                [instance methodWithString:strings[i % strings.count]];
            }
        }];
    
        [self measurePerf:@"Big data marshalling" action: ^void() {
            @autoreleasepool {
                id instance = [[TestFixtures alloc] init];
                NSMutableArray* array = [NSMutableArray array];
    
                for (int32_t i = 0; i < (1 << 16); i++) {
                    [array addObject:@(i)];
                }
    
                for (int32_t i = 0; i < 200; i++) {
                    [instance methodWithBigData:array];
                }
            }
        }];
}

- (void)measurePerf:(NSString *)name action:(void (^)(void))action {
    NSDate* startDate = [NSDate date];

    action();

    NSTimeInterval elapsedSeconds = -[startDate timeIntervalSinceNow];
    NSLog(@"%@: %fms", name, elapsedSeconds * 1000);
}

@end
