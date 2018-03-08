//
//  UIBarButtonItem+XHExtension.m
//  b2b
//
//  Created by XH on 16/8/14.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "UIBarButtonItem+XHExtension.h"

NSString const *UIBarButtonItem_badgeKey = @"UIBarButtonItem_badgeKey";

NSString const *UIBarButtonItem_badgeBGColorKey = @"UIBarButtonItem_badgeBGColorKey";
NSString const *UIBarButtonItem_badgeTextColorKey = @"UIBarButtonItem_badgeTextColorKey";
NSString const *UIBarButtonItem_badgeFontKey = @"UIBarButtonItem_badgeFontKey";
NSString const *UIBarButtonItem_badgePaddingKey = @"UIBarButtonItem_badgePaddingKey";
NSString const *UIBarButtonItem_badgeMinSizeKey = @"UIBarButtonItem_badgeMinSizeKey";
NSString const *UIBarButtonItem_badgeOriginXKey = @"UIBarButtonItem_badgeOriginXKey";
NSString const *UIBarButtonItem_badgeOriginYKey = @"UIBarButtonItem_badgeOriginYKey";
NSString const *UIBarButtonItem_shouldHideBadgeAtZeroKey = @"UIBarButtonItem_shouldHideBadgeAtZeroKey";
NSString const *UIBarButtonItem_shouldAnimateBadgeKey = @"UIBarButtonItem_shouldAnimateBadgeKey";
NSString const *UIBarButtonItem_badgeValueKey = @"UIBarButtonItem_badgeValueKey";

@implementation UIBarButtonItem (XHExtension)

@dynamic badgeValue, badgeBGColor, badgeTextColor, badgeFont;
@dynamic badgePadding, badgeMinSize, badgeOriginX, badgeOriginY;
@dynamic shouldHideBadgeAtZero, shouldAnimateBadge;

#pragma mark - 添加小红点

- (void)badgeInit
{
    UIView *superview = nil;
    CGFloat defaultOriginX = 0;
    if (self.customView) {
        superview = self.customView;
        defaultOriginX = superview.frame.size.width - self.badge.frame.size.width/2;
        // Avoids badge to be clipped when animating its scale
        superview.clipsToBounds = NO;
    } else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
        defaultOriginX = superview.frame.size.width - self.badge.frame.size.width;
    }
    [superview addSubview:self.badge];
    
    // Default design initialization
    self.badgeBGColor   = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeFont      = [UIFont systemFontOfSize:12.0];
    self.badgePadding   = 6;
    self.badgeMinSize   = 8;
    self.badgeOriginX   = defaultOriginX;
    self.badgeOriginY   = -4;
    self.shouldHideBadgeAtZero = YES;
    self.shouldAnimateBadge = YES;
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)refreshBadge
{
    // Change new attributes
    self.badge.textColor        = self.badgeTextColor;
    self.badge.backgroundColor  = self.badgeBGColor;
    self.badge.font             = self.badgeFont;
    
    if (!self.badgeValue || [self.badgeValue isEqualToString:@""] || ([self.badgeValue isEqualToString:@"0"] && self.shouldHideBadgeAtZero)) {
        self.badge.hidden = YES;
    } else {
        self.badge.hidden = NO;
        [self updateBadgeValueAnimated:YES];
    }
    
}

- (CGSize) badgeExpectedSize
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don't call sizeToFit on the true label to avoid bad display
    UILabel *frameLabel = [self duplicateLabel:self.badge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

- (void)updateBadgeFrame
{
    
    CGSize expectedLabelSize = [self badgeExpectedSize];
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.badgePadding;
    
    // Using const we make sure the badge doesn't get too smal
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    self.badge.layer.masksToBounds = YES;
    self.badge.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, minWidth + padding, minHeight + padding);
    self.badge.layer.cornerRadius = (minHeight + padding) / 2;
}

// Handle the badge changing value
- (void)updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.shouldAnimateBadge && ![self.badge.text isEqualToString:self.badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    // Set the new value
    self.badge.text = self.badgeValue;
    
    // Animate the size modification if needed
    if (animated && self.shouldAnimateBadge) {
        [UIView animateWithDuration:0.2 animations:^{
            [self updateBadgeFrame];
        }];
    } else {
        [self updateBadgeFrame];
    }
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)removeBadge
{
    // Animate badge removal
    [UIView animateWithDuration:0.2 animations:^{
        self.badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }];
}

#pragma mark - getters/setters
-(UILabel*) badge {
    UILabel* lbl = objc_getAssociatedObject(self, &UIBarButtonItem_badgeKey);
    if(lbl==nil) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 20, 20)];
        [self setBadge:lbl];
        [self badgeInit];
        [self.customView addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
    }
    return lbl;
}
-(void)setBadge:(UILabel *)badgeLabel
{
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge value to be display
-(NSString *)badgeValue {
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeValueKey);
}
-(void) setBadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    [self updateBadgeValueAnimated:YES];
    [self refreshBadge];
}

// Badge background color
-(UIColor *)badgeBGColor {
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeBGColorKey);
}
-(void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Badge text color
-(UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeTextColorKey);
}
-(void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Badge font
-(UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &UIBarButtonItem_badgeFontKey);
}
-(void)setBadgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Padding value for the badge
-(CGFloat) badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &UIBarButtonItem_badgePaddingKey);
    return number.floatValue;
}
-(void) setBadgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &UIBarButtonItem_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// Minimum size badge to small
-(CGFloat) badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &UIBarButtonItem_badgeMinSizeKey);
    return number.floatValue;
}
-(void) setBadgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// Values for offseting the badge over the BarButtonItem you picked
-(CGFloat) badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &UIBarButtonItem_badgeOriginXKey);
    return number.floatValue;
}
-(void) setBadgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

-(CGFloat) badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &UIBarButtonItem_badgeOriginYKey);
    return number.floatValue;
}
-(void) setBadgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &UIBarButtonItem_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// In case of numbers, remove the badge when reaching zero
-(BOOL) shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &UIBarButtonItem_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setShouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &UIBarButtonItem_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.badge) {
        [self refreshBadge];
    }
}

// Badge has a bounce animation when value changes
-(BOOL) shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &UIBarButtonItem_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setShouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &UIBarButtonItem_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.badge) {
        [self refreshBadge];
    }
}

#pragma mark -
+ (instancetype)barButtonLeftItemWithImageName:(NSString *)imageName
                                        target:(id)target
                                        action:(SEL)action{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}

+ (instancetype)barButtonRightItemWithImageName:(NSString *)imageName
                                         target:(id)target
                                         action:(SEL)action{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 22)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}
+ (instancetype)barButtonLeftItemWithName:(NSString *)str
                                   target:(id)target
                                   action:(SEL)action
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
    [button setTitle:str forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:17];
    [button setTitleColor:XHColor(0x333333) forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}
+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:obj action:selector];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateDisabled];
    return buttonItem;
}


+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title image:(UIImage *)image target:(id)obj action:(SEL)selector{
    UIButton* rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 48, 50);
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [rightButton setImage:image forState:UIControlStateNormal];
    // 调button上的图和文字
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [rightButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    return buttonItem;
}
//返回纯图片的导航栏
+ (UIBarButtonItem *)itemWithBtnImage:(UIImage *)image target:(id)obj action:(SEL)selector;
{
    UIButton* rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 18, 22);
    //    rightButton.backgroundColor = [UIColor cyanColor];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    return buttonItem;
}
//返回图片上方有红点的图标
+ (UIBarButtonItem *)itemWithBtnImage:(UIImage *)image withTipView:(BOOL)hidden target:(id)obj action:(SEL)selector;
{
    UIButton* rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    //    rightButton.backgroundColor = [UIColor cyanColor];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(18, 2, 10, 10)]; //设置右上角的小图标
    redView.backgroundColor = [UIColor redColor];
    redView.layer.masksToBounds = YES;
    
    redView.layer.cornerRadius =5;
    redView.hidden = hidden;
    [rightButton addSubview:redView];
    
    UIBarButtonItem *buttonItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    return buttonItem;
    
}
#pragma mark----自定义的角标 有文字 有图片
+ (UIBarButtonItem *)itemWithBtnTitle:(NSInteger )title Iconimage:(UIImage *)image target:(id)obj action:(SEL)selector
{
    
    UIButton* rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 48, 48);
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    rightButton.backgroundColor  = [UIColor cyanColor];
    rightButton.titleLabel.textColor = [UIColor blackColor];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setTitle:@"新增" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
    // 调button上的图和文字
    //    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 0)];
    //    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [rightButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 15, 15)];//添加右侧的角图标
    //    label.backgroundColor=[UIColor colorWithHex:@"#d2d2d2" alpha:1];
    label.backgroundColor=[UIColor orangeColor];
    label.textAlignment=NSTextAlignmentCenter;
    
    label.textColor=[UIColor blackColor];
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=7.5;
    label.layer.borderWidth=0.5f;
    label.layer.shouldRasterize=YES;
    label.layer.rasterizationScale=[UIScreen mainScreen].scale;
    label.layer.borderColor=[[UIColor redColor]CGColor];
    if (title>99)
    {
        label.font=[UIFont systemFontOfSize:7];
        label.frame=CGRectMake(7, 10, 20, 15);
        label.text=[NSString stringWithFormat:@"99+"];
        
    }
    else if(title>10)
    {
        label.font=[UIFont systemFontOfSize:7];
        label.text=[NSString stringWithFormat:@"%ld",(long)title];
    }
    else
    {
        label.font=[UIFont systemFontOfSize:10];
        label.text=[NSString stringWithFormat:@"%ld",(long)title];
    }
    if (title==0)
    {
        label.hidden=YES;
        
    }
    [rightButton addSubview:label];
    UIBarButtonItem *buttonItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    return buttonItem;
    
}

@end
