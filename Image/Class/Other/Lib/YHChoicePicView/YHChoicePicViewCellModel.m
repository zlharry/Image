//
//  YHChoicePicViewCellModel.m
//  Image
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePicViewCellModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YHChoicePicViewCellModel ()

/** 加载图片的ID（可通过此ID取消谋求请求） */
@property (nonatomic, assign) PHImageRequestID requestID;

@end

@implementation YHChoicePicViewCellModel



+ (instancetype)modelWithAsset:(PHAsset *)asset
{
    YHChoicePicViewCellModel *model = [[YHChoicePicViewCellModel alloc] init];
    model.asset = asset;
    return model;
}

- (void)getImageWithAscending:(BOOL)ascending size:(CGSize)size useingBlock:(YHChoicePicViewCellModelDidGetImageBlock)didGetImageBlock
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //仅显示缩略图，不控制质量显示
    /**
     PHImageRequestOptionsResizeModeNone,
     PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
     PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
     */
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    
    __weak YHChoicePicViewCellModel *weakSelf = self;
    dispatch_async(dispatch_queue_create("pic", DISPATCH_QUEUE_CONCURRENT), ^{
        self.requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:weakSelf.asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            //解析出来的图片
            if (didGetImageBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    didGetImageBlock(image);
                });
                
            }
        }];
    });
    
}

- (void)cancelRequeat
{
    [[PHCachingImageManager defaultManager] cancelImageRequest:self.requestID];
}

@end
