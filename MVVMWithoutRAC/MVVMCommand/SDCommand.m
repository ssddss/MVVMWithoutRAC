//
//  SDCommand.m
//  MVVMWithoutRAC
//
//  Created by ssdd on 15/10/14.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "SDCommand.h"
@interface SDCommandResult()
@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) id content;
@end
@implementation SDCommandResult
- (instancetype)initWithError:(NSError *)error content:(id)content {
    self = [super init];
    if (!self) {
        return nil;
    }
    _error = error;
    _content = content;
    return self;
}
@end

@interface SDCommand()
@property (nonatomic, strong) NSNumber *executing;/**< 是否正在执行*/
@property (nonatomic, strong) SDCommandResult *result;/**< 结果*/
@property (nonatomic,copy) SDCommandConsumeBlock consumeHandler;/**< 执行的block*/
@property (nonatomic,copy) SDCommandCancelBlock cancelHandler;/**< 取消*/
@property (nonatomic,copy) SDCommandCompletionBlock completionHandler;/**< 成功*/
@end
@implementation SDCommand
- (instancetype)initWithConsumeHandler:(SDCommandConsumeBlock)consumeHandler {
    self = [super init];
    if (!self) {
        return nil;
    }
    _consumeHandler = consumeHandler;
    _result = [[SDCommandResult alloc]init];
    return self;
}
- (instancetype)initWithConsumeHandler:(SDCommandConsumeBlock)consumeHandler cancelHandler:(SDCommandCancelBlock)cancelHandler {
    self = [super init];
    if (!self) {
        return nil;
    }
    _consumeHandler = consumeHandler;
    _cancelHandler = cancelHandler;
    return self;
}
- (void)execute:(id)input {
    self.executing = [NSNumber numberWithInt:2];
    //生成model
    if (!self.completionHandler) {
        __weak typeof(self) weakSelf = self;

        self.completionHandler = ^(id error,id content) {
            __strong typeof(self) strongSelf = weakSelf;
            if (error) {
                strongSelf.executing = [NSNumber numberWithInt:3];
            }
            else {
            strongSelf.executing = [NSNumber numberWithInt:1];
            }
            strongSelf.result = [[SDCommandResult alloc]initWithError:error content:content];
        };
    }
    
    self.consumeHandler(input,self.completionHandler);
    
}
- (void)cancel {
    //取消请求
    if (self.cancelHandler) {
        self.cancelHandler();
    }
    self.executing = [NSNumber numberWithInt:4];
}
@end
