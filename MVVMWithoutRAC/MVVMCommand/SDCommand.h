//
//  SDCommand.h
//  MVVMWithoutRAC
//
//  Created by ssdd on 15/10/14.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  成功时的回调block
 *
 *  @param error
 *  @param content
 */
typedef void(^SDCommandCompletionBlock)(id error,id content);
/**
 *  执行的block
 *
 *  @param input             输入
 *  @param completionHandler 完成结果
 */
typedef void(^SDCommandConsumeBlock)(id input,SDCommandCompletionBlock completionHandler);
/**
 *  取消的block
 */
typedef void(^SDCommandCancelBlock)(void);

/**
 *  Model
 */
@interface SDCommandResult : NSObject
@property (nonatomic,readonly) NSError *error;
@property (nonatomic,readonly) id content;
- (instancetype)initWithError:(NSError *)error content:(id)content;
@end

/**
 *  封装逻辑
 */
@interface SDCommand : NSObject
@property (nonatomic, readonly) NSNumber *executing;/**< 1为成功，3为失败,2为获取中,4为取消*/
@property (nonatomic, readonly) SDCommandResult *result;
/**
 *   初始化
 *
 *  @param consumeHandler
 *
 *  @return
 */
- (instancetype)initWithConsumeHandler:(SDCommandConsumeBlock)consumeHandler;
/**
 *  带取消操作
 *
 *  @param consumeHandler
 *  @param cancelHandler
 *
 *  @return
 */
- (instancetype)initWithConsumeHandler:(SDCommandConsumeBlock)consumeHandler cancelHandler:(SDCommandCancelBlock)cancelHandler;
/**
 *  执行
 *
 *  @param input
 */
- (void)execute:(id)input;
/**
 *  取消
 */
- (void)cancel;
@end
