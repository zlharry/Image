//
//  YHChoicePicView.h
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

/** 选择了一个图片完成后调用的 block */
typedef void (^YHChoicePicViewDidFinishedSelectOneImageBlock) (UIImage *selectedImage, PHAsset *asset, NSError *error);
/** 选择完一个图片数组后调用的 block */
typedef void (^YHChoicePicViewDidFinishedSelectImagesBlock) (NSArray<UIImage *> *selectedImages, NSArray<PHAsset *> *assets, NSError *error);


@interface YHChoicePicView : UIView


/** 创建一个图片选择View,同时设置选择完 多张图片 成功或失败后的相应动作 */
- (instancetype)initWithMaxNumber:(NSInteger)maxNumber didFinishedSelectImagesBlock:(YHChoicePicViewDidFinishedSelectImagesBlock)didFinishedSelectImagesBlock;

/** 创建一个图片选择View,同时设置选择完 一张图片 成功或失败后的相应动作 */
- (instancetype)initWithMaxNumber:(NSInteger)maxNumber didFinishedSelectImageBlock:(YHChoicePicViewDidFinishedSelectOneImageBlock)didFinishedSelectImageBlock;

@end
