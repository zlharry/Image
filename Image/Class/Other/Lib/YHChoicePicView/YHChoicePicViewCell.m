//
//  YHChoicePicViewCell.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePicViewCell.h"

#import <Photos/Photos.h>

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

- (void)setModel:(YHChoicePicViewCellModel *)model
{
    
    __weak YHChoicePicViewCell *weakSelf = self;
    CGSize size = CGSizeMake(4000, 4000);
    
    // 先取消原来的请求
    [_model cancelRequeat];
    
    // 请求当前的
    [model getImageWithAscending:YES size:size useingBlock:^(UIImage *image) {
        weakSelf.imageView.image = image;
       
        
        
        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
//        [imgData writeToFile:@"/Users/harry/Desktop/test.jpg" atomically:YES];
    }];
    
    _model = model;
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
