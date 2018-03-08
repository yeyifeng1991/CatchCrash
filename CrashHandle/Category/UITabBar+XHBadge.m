//
//  UITabBar+XHBadge.m
//  QiMu
//
//  Created by XH on 17/4/20.
//  Copyright © 2017年 XH. All rights reserved.
//

#import "UITabBar+XHBadge.h"
#define TabbarItemNums 5   //tabbar的数量
@implementation UITabBar (XHBadge)

- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = qimuRedColor;
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

- (void)setBadgeValue:(NSInteger)value AtIndex:(NSInteger)index {
    if (index<0||index>=TabbarItemNums) {
        return;
    }
    [self hideBadgeValueAtIndex:index];
    CGRect tabFrame = self.frame;
    float percentX = (index + 0.55) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    UILabel *badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 15, 15)];
    badgeLabel.backgroundColor = qimuRedColor;
    badgeLabel.tag = 999+index;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont systemFontOfSize:9.0];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.layer.cornerRadius = badgeLabel.height_xh/2.0;
    badgeLabel.layer.masksToBounds = YES;
    [self addSubview:badgeLabel];
    value = value>99 ? 99 : value;
    badgeLabel.text = [NSString stringWithFormat:@"%zd",value];
    if (value <= 0) {
        badgeLabel.hidden = YES;
    }
}

- (void)hideBadgeValueAtIndex:(NSInteger)index {
    for (UIView *subView in self.subviews) {
        if (subView.tag == 999+index) {
            [subView removeFromSuperview];
        }
    }
}

- (BOOL)isBadgeOnIndex:(int)index
{
    BOOL isView = NO;
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            isView = YES;
            break;
        }
    }
    return isView;
}
- (BOOL)isBadgeValueOnIndex:(int)index
{
    BOOL isView = NO;
    for (UIView *subView in self.subviews) {
        if (subView.tag == 999+index) {
            isView = YES;
            break;
        }
    }
    return isView;
}


@end
