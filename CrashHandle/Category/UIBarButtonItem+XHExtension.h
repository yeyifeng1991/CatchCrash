//
//  UIBarButtonItem+XHExtension.h
//  b2b
//
//  Created by XH on 16/8/14.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XHExtension)

@property (strong, atomic) UILabel *badge;

// Badge value to be display
@property (nonatomic) NSString *badgeValue;
// Badge background color
@property (nonatomic) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;
// Badge font
@property (nonatomic) UIFont *badgeFont;
// Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;


+ (instancetype)barButtonLeftItemWithImageName:(NSString *)imageName
                                        target:(id)target
                                        action:(SEL)action;
+ (instancetype)barButtonRightItemWithImageName:(NSString *)imageName
                                         target:(id)target
                                         action:(SEL)action;

+ (instancetype)barButtonLeftItemWithName:(NSString *)str
                                        target:(id)target
                                        action:(SEL)action;
+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector;//自定义名称的导航栏按钮


+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title image:(UIImage *)image target:(id)obj action:(SEL)selector;

+ (UIBarButtonItem *)itemWithBtnTitle:(NSInteger )title Iconimage:(UIImage *)image target:(id)obj action:(SEL)selector;//自定义导航栏带有角图标的按钮
+ (UIBarButtonItem *)itemWithBtnImage:(UIImage *)image target:(id)obj action:(SEL)selector;
//返回图片上方有红点的图标
+ (UIBarButtonItem *)itemWithBtnImage:(UIImage *)image withTipView:(BOOL)hidden  target:(id)obj action:(SEL)selector;

@end
