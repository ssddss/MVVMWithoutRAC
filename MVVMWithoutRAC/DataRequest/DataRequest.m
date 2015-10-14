//
//  DataRequest.m
//  MVVMWithoutRAC
//
//  Created by ssdd on 15/10/14.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "DataRequest.h"
//1代表数据获取成功
#define DataGainStatus  1
@interface DataRequest()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) DataSucceedBlock successHandler;
@property (nonatomic,copy) DataFailedBlock failureHandler;

@end
@implementation DataRequest

- (void)getUserList:(NSString *)input success :(DataSucceedBlock)successHandler failure:(DataFailedBlock)failureHandler {

    self.successHandler = successHandler;
    self.failureHandler = failureHandler;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    
}
- (void)cancelRequest {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)delayMethod {
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<2; i++) {
        NSString *userName = [NSString stringWithFormat:@"joe :%d号",i];
        NSNumber *userNumber = @(i);
        NSDictionary *user = @{@"userName":userName,@"userNumber":userNumber};
        [users addObject:user];
    }
    
    if (DataGainStatus == 1) {
        self.successHandler(users);
        return ;
    }
    
    NSError *error = [NSError errorWithDomain:@"获取超时了" code:500 userInfo:nil];
    self.failureHandler(error);
}

@end
