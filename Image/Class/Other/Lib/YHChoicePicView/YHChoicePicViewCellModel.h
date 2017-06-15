//
//  YHChoicePicViewCellModel.h
//  Image
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


typedef void(^YHChoicePicViewCellModelDidGetImageBlock) (UIImage *image);

@interface YHChoicePicViewCellModel : NSObject


@property (nonatomic, strong) PHAsset *asset;

+ (instancetype)modelWithAsset:(PHAsset *)asset;

- (void)getImageWithAscending:(BOOL)ascending size:(CGSize)size useingBlock:(YHChoicePicViewCellModelDidGetImageBlock)didGetImageBlock;

- (void)cancelRequeat;

@end
