//
//  CYCatchCrash.h
//  CrashHandle
//
//  Created by YeYiFeng on 2018/3/7.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYCatchCrash : NSObject
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
