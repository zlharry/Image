//
//  ViewController.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "ViewController.h"

#import "YHChoicePicView.h"

#import <Photos/Photos.h>


@interface ViewController ()

@property (nonatomic, weak) YHChoicePicView *choicePicView;

@end

@implementation ViewController

- (YHChoicePicView *)choicePicView
{
    if (!_choicePicView) {
        YHChoicePicView *choicePicView = [[YHChoicePicView alloc] init];
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
    CGFloat choiceH = 600;
    self.choicePicView.frame = CGRectMake(choiceX, choiceY, choiceW, choiceH);

    
}





@end
