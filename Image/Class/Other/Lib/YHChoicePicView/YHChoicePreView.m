//
//  YHChoicePreView.m
//  Image
//
//  Created by harry on 2017/6/16.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePreView.h"

@interface YHChoicePreView ()

/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancelBtn;

/** 预览按钮 */
@property (nonatomic, weak) UIButton *preBtn;

/** 显示已选数量的Label */
@property (nonatomic, weak) UILabel *selectedLabel;

/** 完成按钮 */
@property (nonatomic, weak) UIButton *completeBtn;

@end

@implementation YHChoicePreView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

#pragma mark - 延迟加载
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        UIButton *cancelBtn = [[UIButton alloc] init];
        [self addSubview:cancelBtn];
        _cancelBtn = cancelBtn;
        
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    
    return _cancelBtn;
}

- (UIButton *)preBtn
{
    if (!_preBtn)
    {
        UIButton *preBtn = [[UIButton alloc] init];
        [self addSubview:preBtn];
        _preBtn = preBtn;
        
        [preBtn setTitle:@"预览" forState:UIControlStateNormal];
    }
    return _preBtn;
}

- (UILabel *)selectedLabel
{
    if (!_selectedLabel) {
        UILabel *selectLabel = [[UILabel alloc] init];
        [self addSubview:selectLabel];
        _selectedLabel = selectLabel;
        
        selectLabel.text = @"2";
    }
    return _selectedLabel;
}

- (UIButton *)completeBtn
{
    if (!_completeBtn) {
        UIButton *completeBtn = [[UIButton alloc] init];
        [self addSubview:completeBtn];
        _completeBtn = completeBtn;
        
        [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    return _completeBtn;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat canX = 10;
    CGFloat canY = 0;
    CGFloat canH = self.frame.size.height;
    CGFloat canW = canH;
    self.cancelBtn.frame = CGRectMake(canX, canY, canW, canH);
    
    CGFloat preX = canX + canW + 10;
    CGFloat preY = 0;
    CGFloat preW = canW;
    CGFloat preH = canH;
    self.preBtn.frame = CGRectMake(preX, preY, preW, preH);
    
    
    
    CGFloat comY = 0;
    CGFloat comH = self.frame.size.height;
    CGFloat comW = comH;
    CGFloat comX = self.frame.size.width - comW - 10;
    self.completeBtn.frame = CGRectMake(comX, comY, comW, comH);
    
    CGFloat labH = self.frame.size.height;
    CGFloat labW = labH;
    CGFloat labX = comX - labW - 10;
    CGFloat labY = 0;
    self.selectedLabel.frame = CGRectMake(labX, labY, labW, labH);
}

@end
