//
//  SDViewModel.m
//  MVVMWithoutRAC
//
//  Created by ssdd on 15/10/14.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "SDViewModel.h"
#import "DataRequest.h"

@interface SDViewModel()
@property (nonatomic) SDCommand *followCommand;
@property (nonatomic) NSArray *users;
@property (nonatomic) DataRequest *requestApi;
@end
@implementation SDViewModel
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
        __weak typeof(self) weakSelf = self;


    _followCommand = [[SDCommand alloc]initWithConsumeHandler:^(id input, SDCommandCompletionBlock completionHandler) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.requestApi getUserList:input success:^(NSArray *users) {
            strongSelf.users = users;
            completionHandler(nil,users);
        } failure:^(NSError *error) {
            completionHandler(error,nil);
        }];
    } cancelHandler:^{
        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf.requestApi cancelRequest];
    }];
    return self;
}
- (void)execute:(NSString *)userID {
    [self.followCommand execute:userID];
}
- (void)cancel {
    [self.followCommand cancel];
}
- (DataRequest *)requestApi {
    if (!_requestApi) {
        _requestApi = [[DataRequest alloc]init];
    }
    return _requestApi;
}
@end
