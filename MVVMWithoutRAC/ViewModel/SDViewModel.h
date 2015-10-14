//
//  SDViewModel.h
//  MVVMWithoutRAC
//
//  Created by ssdd on 15/10/14.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCommand.h"

@interface SDViewModel : NSObject
@property (nonatomic,readonly) SDCommand *followCommand;
/**
 *  执行获取数据
 *
 *  @param userID 
 */
- (void)execute:(NSString *)userID;
/**
 *  取消请求
 */
- (void)cancel;
@end
