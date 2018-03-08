//
//  NSDictionary+XHExtension.m
//  QiMu
//
//  Created by XH on 17/4/5.
//  Copyright © 2017年 XH. All rights reserved.
//

#import "NSDictionary+XHExtension.h"

@implementation NSDictionary (XHExtension)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        XHLog(@"json serialize failue");
        return nil;
    }
    return dic;
}

- (NSString*)jsonString
{
    NSError *error;
    NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    NSString *jsonString = @"";
    if (! infoJsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
