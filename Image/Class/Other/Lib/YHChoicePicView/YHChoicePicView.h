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
typedef void (^YHChoicePicViewDidFinishedSelectOneImageBlock) (UIImage *selectedImage, PHAsset *asset);
/** 选择完一个图片数组后调用的 block */
typedef void (^YHChoicePicViewDidFinishedSelectImagesBlock) (NSArray<UIImage *> *selectedImages, NSArray<PHAsset *> *assets);


@interface YHChoicePicView : UIView

//

@end
