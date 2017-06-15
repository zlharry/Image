//
//  UIImage+YH.m
//  Image
//
//  Created by harry on 2017/6/14.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "UIImage+YH.h"

@interface UIImage ()

@end

@implementation UIImage (YH)

/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
- (UIImage*)scaleToSize:(CGSize)size
{
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    
    // 将图片按照指定大小绘制
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


/**
 *将图片缩放到指定的CGSize大小之内, 图片保持原始比例
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
- (UIImage*)scaleOriginalToSize:(CGSize)size
{
    CGSize tarSize;
    
    if (size.width / size.height > self.size.width / self.size.height)
    {
        tarSize.height = size.height;
        tarSize.width = size.height * self.size.width / self.size.height;
    }
    else
    {
        tarSize.height = size.width / (self.size.width / self.size.height);
        tarSize.width = size.width;
    }
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(tarSize);
    
    // 将图片按照指定大小绘制
    [self drawInRect:CGRectMake(0, 0, tarSize.width, tarSize.height)];
    
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)clipInRect:(CGRect)rect
{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [self CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
-(UIImage *)clipToSize:(CGSize)size
{
    
    //被切图片宽比例比高比例小 或者相等，以图片宽进行放大
    if (self.size.width*size.height <= self.size.height*size.width) {
        
        //以被剪裁图片的宽度为基准，得到剪切范围的大小
        CGFloat width  = self.size.width;
        CGFloat height = self.size.width * size.height / size.width;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self clipInRect:CGRectMake(0, (self.size.height -height)/2, width, height)];
        
    }else{ //被切图片宽比例比高比例大，以图片高进行剪裁
        
        // 以被剪切图片的高度为基准，得到剪切范围的大小
        CGFloat width  = self.size.height * size.width / size.height;
        CGFloat height = self.size.height;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self clipInRect:CGRectMake((self.size.width -width)/2, 0, width, height)];
    }
    return nil;
}


/** 保存图片到手机相册(保存结果通过Block回调) */
- (void)saveToPhotosAlbumWithBlock:(finishedSaveToPhotosAlbumBlock)finshedBlock
{
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void * _Nullable)(finshedBlock));
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (contextInfo) {
        finishedSaveToPhotosAlbumBlock block = (__bridge finishedSaveToPhotosAlbumBlock)contextInfo;
        block(error);
    }
}

@end
