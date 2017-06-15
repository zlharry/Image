//
//  UIImage+YH.h
//  Image
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 harry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^finishedSaveToPhotosAlbumBlock)(NSError *error);

@interface UIImage (YH)


/**
 *将图片缩放到指定的CGSize大小, 图片多出部分会被挤压或拉伸(图片的实际大小会变化)
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
- (UIImage*)scaleToSize:(CGSize)size;

/**
 *将图片缩放到指定的CGSize大小之内, 图片保持原始比例(图片的实际大小会变化)
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
- (UIImage*)scaleOriginalToSize:(CGSize)size;


/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)clipInRect:(CGRect)rect;

/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
- (UIImage *)clipToSize:(CGSize)size;

/** 保存图片到手机相册 */
- (void)saveToPhotosAlbumWithBlock:(finishedSaveToPhotosAlbumBlock)finshedBlock;

@end
