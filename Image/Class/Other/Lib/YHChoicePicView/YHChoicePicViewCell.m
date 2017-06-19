//
//  YHChoicePicViewCell.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePicViewCell.h"

#import <Photos/Photos.h>

#import "UIImage+YH.h"

@interface YHChoicePicViewCell ()

/** 显示图片的View */
@property (nonatomic, weak) UIImageView *imageView;

/** 左上角的是否打勾按钮 */
@property (nonatomic, weak) UIButton *selectBtn;

/** 是否可选的半透明蒙版 */
@property (nonatomic, weak) UIView *coverView;

@end

@implementation YHChoicePicViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setModel:(YHChoicePicViewCellModel *)model
{
    
    __weak YHChoicePicViewCell *weakSelf = self;
//    CGFloat scale = 2;
//    CGFloat width = self.imageView.frame.size.width * scale;
//    CGFloat height = self.imageView.frame.size.height * scale;
    CGSize size = CGSizeMake(250, 250);
    
    
    // 先取消原来的请求
    [_model cancelRequeat];
    
    // 请求当前的图片
    [model getImageWithAscending:YES size:size useingBlock:^(UIImage *image) {
        weakSelf.imageView.image = image;
    }];
    
    // 是否选中
//    self.selectBtn.selected = model.selected;
    
    if (model.selected)
    {
        // 选择的状态
        self.selectBtn.backgroundColor = [UIColor greenColor];
    }
    else
    {
        // 未选择的状态
        self.selectBtn.backgroundColor = [UIColor redColor];
    }
    
    
    // 是否显示蒙版
    self.coverView.hidden = model.canSelect;
    
    
    _model = model;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _imageView = imageView;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIView *)coverView
{
    if(!_coverView)
    {
        UIView *coverView = [[UIView alloc] init];
        [self insertSubview:coverView aboveSubview:self.imageView];
        _coverView = coverView;
        
        coverView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    }
    return _coverView;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        UIButton *selectBtn = [[UIButton alloc] init];
        [self insertSubview:selectBtn aboveSubview:self.coverView];
        _selectBtn = selectBtn;
        
        selectBtn.backgroundColor = [UIColor redColor];
        
        [selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // image
//    CGFloat imageX = 0;
//    CGFloat imageY = 0;
//    CGFloat imageW = 0;
//    CGFloat imageH = 0;
//    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    self.imageView.frame = self.bounds;
    
    // coverView
//    CGFloat coverX = 0;
//    CGFloat coverY = 0;
//    CGFloat coverW = 0;
//    CGFloat coverH = 0;
//    self.coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
    self.coverView.frame = self.imageView.frame;
    
    // select btn
    CGFloat slebtnW = 30;
    CGFloat slebtnH = slebtnW;
    CGFloat slebtnX = self.frame.size.width - slebtnW;
    CGFloat slebtnY = 0;
    self.selectBtn.frame = CGRectMake(slebtnX, slebtnY, slebtnW, slebtnH);
}

#pragma mark - 事件处理
- (void)selectBtnClicked:(UIButton *)sender
{
    if (!self.model.canSelect) {
        NSLog(@"提示用户，不能继续添加了！！！");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(choicePicViewCell:didClickedSelectBtn:)]) {
        [self.delegate choicePicViewCell:self didClickedSelectBtn:sender];
    }
    
    sender.selected = !sender.selected;
}

@end
