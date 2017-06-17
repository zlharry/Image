//
//  YHChoicePicViewCell.h
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHChoicePicViewCellModel.h"

@protocol YHChoicePicViewCellDelegate <NSObject>

@optional
- (void)choicePicViewCell:(UICollectionViewCell *)cell didClickedSelectBtn:(UIButton *)selectBrn;

@end


@interface YHChoicePicViewCell : UICollectionViewCell

/** 代理对象 */
@property (nonatomic, weak) id<YHChoicePicViewCellDelegate> delegate;

@property (nonatomic, strong) YHChoicePicViewCellModel *model;

@end
