//
//  DataRequest.h
//  MVVMWithoutRAC
//
//  Created by ssdd on 15/10/14.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^DataSucceedBlock)(NSArray *users);
typedef void(^DataFailedBlock)(NSError *error);
@interface DataRequest : NSObject
/**
 *  获取数据
 *
 *  @param input          <#input description#>
 *  @param successHandler <#successHandler description#>
 *  @param failureHandler <#failureHandler description#>
 */
- (void)getUserList:(NSString *)input success:(DataSucceedBlock)successHandler failure:(DataFailedBlock)failureHandler;
/**
 *  模拟取消请求
 */
- (void)cancelRequest;
@end
