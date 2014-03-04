//
//  MinroadOperation.h
//  laixin
//
//  Created by apple on 14-2-12.
//  Copyright (c) 2014年 jijia. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  后台上传图片队列处理
 */
@interface MinroadOperation : NSObject
{
    NSOperationQueue *operationQueue;
}
+(MinroadOperation*) sharedMinroadOperation;
- (void)addOperation:(NSDictionary *)_dic;
- (void)reStartOperation:(NSDictionary *)_dic;
@property (retain,nonatomic) NSOperationQueue *operationQueue;
@end
