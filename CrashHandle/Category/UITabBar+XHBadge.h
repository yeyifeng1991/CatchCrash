//
//  UITabBar+XHBadge.h
//  QiMu
//
//  Created by XH on 17/4/20.
//  Copyright © 2017年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (XHBadge)
///显示小红点
- (void)showBadgeOnItemIndex:(int)index;
///隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index;
///带数字的小红点
- (void)setBadgeValue:(NSInteger)value AtIndex:(NSInteger)index;
- (void)hideBadgeValueAtIndex:(NSInteger)index;
///判断是否有小红点
- (BOOL)isBadgeOnIndex:(int)index;
///判断是否有带数字带小红点
- (BOOL)isBadgeValueOnIndex:(int)index;

@end
