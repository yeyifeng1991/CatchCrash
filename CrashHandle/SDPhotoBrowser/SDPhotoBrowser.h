//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required
//加载当前图片
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
//删除当前图片 xh
- (BOOL)photoBrowser:(SDPhotoBrowser *)browser deleteImageForindex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

//如果此属性有值，这代表图片一次性加载，再大量图片情况下不建议使用
@property (nonatomic, strong) NSMutableArray *photoArr;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;

@end
