//
//  YHChoicePicViewCell.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePicViewCell.h"

#import <Photos/Photos.h>
#import "PHAsset+YHChoicePicView.h"

@interface YHChoicePicViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation YHChoicePicViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = 0;
    CGFloat imageH = 0;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    self.imageView.frame = self.bounds;
}

@end
