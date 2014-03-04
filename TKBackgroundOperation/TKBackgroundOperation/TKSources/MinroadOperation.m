//
//  MinroadOperation.m
//  laixin
//
//  Created by apple on 14-2-12.
//  Copyright (c) 2014年 jijia. All rights reserved.
//

#import "MinroadOperation.h"
#import "UIImage+Resize.h"
#import "UIImage+WebP.h"
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>
#import "CTAssetsPickerController.h"
#import "EGOCache.h"
#import "AFNetworking.h"

#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height


#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                        \
\
+ (classname *)shared##classname {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}
#endif


@implementation MinroadOperation
@synthesize operationQueue;


SINGLETON_GCD(MinroadOperation);

- (id)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:1];//设置同时进行的线程数量，建议为2。
    }
    return self;
}

- (void)addOperation:(NSDictionary *)_dic
{
    [self.operationQueue setMaxConcurrentOperationCount:1];
    //保存上传列表到nsuserdefaults
    if ([[EGOCache globalCache] plistForKey:@"upload"] == nil) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithObject:_dic],@"upload",nil];
        [[EGOCache globalCache] setPlist:@[_dic] forKey:@"upload"];
    }
    else {
        NSArray *array = [[EGOCache globalCache] plistForKey:@"upload"];
        NSLog(@"%@",array);
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
        [arr addObject:_dic];
        [[EGOCache globalCache] setPlist:arr forKey:@"upload"];
    }
    
    //添加到队列
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                        selector:@selector(myTaskMethod:) object:_dic];
    
    [self.operationQueue addOperation:theOp];
    
    //更新UI
    
    
}

- (void)reStartOperation:(NSDictionary *)_dic
{
    //从userdefaults读取数据，并添加到队列
    NSArray *array = [[EGOCache globalCache] plistForKey:@"upload"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
    int i = (int)[arr indexOfObject:_dic];
    if (i == NSNotFound) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:i]];
    [dic setValue:[NSNumber numberWithInt:0] forKey:@"state"];//0 等待上传 1 上传中 2 失败
    [arr replaceObjectAtIndex:i withObject:dic];
    [[EGOCache globalCache] setPlist:arr forKey:@"upload"];
    
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                        selector:@selector(myTaskMethod:) object:dic];
    
    [self.operationQueue addOperation:theOp];
    
    //更新UI
}

- (void)myTaskMethod:(id)_obj
{
    //实现上传方法
    NSDictionary * objDict = _obj;
    
    /*: objDict{
     postid = 137;
     url = "assets-library://asset/asset.JPG?id=5DCC6E95-3591-4387-9A7D-21A2E27ED5F9&ext=JPG";
     }*/
//    NSString * strSrcURL = objDict[@"url"];
    NSLog(@"objDict %@",objDict);
    
    NSString * postid = objDict[@"postid"];
    ALAsset *asset = objDict[@"asset"];
    
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *image = [UIImage imageWithCGImage:imgRef
                                         scale:assetRep.scale
                                   orientation:(UIImageOrientation)assetRep.orientation];
    //http://service.xianchangjia.com/upload/PostEx?sessionid=zS8VbU8lmUtEUsD&postid=106
    
    if (image == nil) {
        // success
         [self performSelectorOnMainThread:@selector(taskMethodDidFinish:) withObject:_obj waitUntilDone:YES];
        return;
    }
    
    
    [self uploadimagewithPostid:postid image:image token:@"" withDict:_obj];
    
}

-(void) uploadimagewithPostid:(NSString *) postid  image:(UIImage*) image token:(NSString*) token withDict:(NSDictionary *) dict
{
    
    int Wasy = image.size.width/APP_SCREEN_WIDTH;
    int Hasy = image.size.height/APP_SCREEN_HEIGHT;
    int quality = Wasy/2;
    UIImage * newimage = [[image copy] resizedImage:CGSizeMake(APP_SCREEN_WIDTH*Wasy/quality, APP_SCREEN_HEIGHT*Hasy/quality) interpolationQuality:kCGInterpolationDefault];
    NSData * FileData = UIImageJPEGRepresentation(newimage, 0.5);
    if (!FileData) {
        FileData = UIImageJPEGRepresentation(image, 0.5);
    }
    
     // 图片压缩处理  NSData *FileData  =  [UIImage imageToWebP:newimage quality:75.0];
    
    if (FileData) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
        [parameters setValue:token  forKey:@"token"];
        [parameters setValue:@(1) forKey:@"x:filetype"];
        [parameters setValue:@"" forKey:@"x:length"];
        [parameters setValue:postid forKey:@"x:postid"];
        AFHTTPRequestOperation * operation =  [manager POST:@"http://up.qiniu.com/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:FileData name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject :%@",responseObject);
            if ([responseObject[@"errno"] intValue] == 0) {
                //成功调用
                [self performSelectorOnMainThread:@selector(taskMethodDidFinish:) withObject:dict waitUntilDone:YES];
            }else{
                //失败调用
                [self performSelectorOnMainThread:@selector(taskMethodDidFailed:) withObject:dict waitUntilDone:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //失败调用
            [self performSelectorOnMainThread:@selector(taskMethodDidFailed:) withObject:dict waitUntilDone:YES];
        }];
        [operation start];
    }else{
        [self performSelectorOnMainThread:@selector(taskMethodDidFinish:) withObject:dict waitUntilDone:YES];
        
    }
}
- (void)taskMethodDidFailed:(id)_obj
{
      NSLog(@"fail _obj:%@",_obj);
    //失败的任务更改状态之后保存
    NSDictionary *tdic = [_obj mutableCopy];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tdic];
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"state"];
    
    NSArray *array =  [[EGOCache globalCache] plistForKey:@"upload"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
    int _index = (int)[arr indexOfObject:dic];
    if (_index != NSNotFound) {
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:_index]];
        [tmp setValue:[NSNumber numberWithInt:2] forKey:@"state"];//0 等待上传 1 上传中 2 失败
        [arr replaceObjectAtIndex:_index withObject:tmp];
    }
    [[EGOCache globalCache] setPlist:arr forKey:@"upload"];
    
    //更新UI
}

- (void)taskMethodDidFinish:(id)_obj
{
    NSLog(@"success _obj:%@",_obj);
    //成功的任务从userdefaults中删除
    NSDictionary *tdic = [_obj mutableCopy];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tdic];
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"state"];
    NSArray *array =  [[EGOCache globalCache] plistForKey:@"upload"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
    int _index = (int)[arr indexOfObject:dic];
    if (_index != NSNotFound) {
        [arr removeObjectAtIndex:_index];
    }
   [[EGOCache globalCache] setPlist:arr forKey:@"upload"];
    
    //更新UI
}

@end