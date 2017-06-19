//
//  ViewController.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "ViewController.h"

#import "YHChoicePicView.h"

#import "UIImage+YH.h"

//#import <Photos/Photos.h>


@interface ViewController ()

@property (nonatomic, weak) YHChoicePicView *choicePicView;

@end

@implementation ViewController

- (YHChoicePicView *)choicePicView
{
    if (!_choicePicView) {
        YHChoicePicView *choicePicView = [[YHChoicePicView alloc] initWithMaxNumber:4 didFinishedSelectImageBlock:^(UIImage *selectedImage, PHAsset *asset, NSError *error) {
            ;
        }];
        [self.view addSubview:choicePicView];
        _choicePicView  = choicePicView;
    }
    
    return _choicePicView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat choiceX = 10;
    CGFloat choiceY = 80;
    CGFloat choiceW = self.view.frame.size.width - 2 * choiceX;
    CGFloat choiceH = 500;
    self.choicePicView.frame = CGRectMake(choiceX, choiceY, choiceW, choiceH);
    
    
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    
    CGSize size = CGSizeMake(200, 200);
    UIImage *newImage = [image scaleOriginalToSize:size];
//    [UIImageJPEGRepresentation(newImage, 1.0) writeToFile:@"/Users/harry/Desktop/hh2.jpg" atomically:YES];
    
    [newImage saveToPhotosAlbumWithBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
//    NSLog(@"%@", newImage);
    
    
    
}





@end
