//
//  YHChoicePicView.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePicView.h"

#import <Photos/Photos.h>

#import "YHChoicePicViewCell.h"

#define CELL_ID @"YHChoicePicViewCell_id"

@interface YHChoicePicView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *pics;

/** 滚动视图 */
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation YHChoicePicView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor yellowColor];
        
        // 1.判断是否有
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            // 这里便是无访问权限
            NSLog(@"没有访问权限");
        }
        else
        {
            NSLog(@"有访问权限");
            self.pics = [self getAllAssetInPhotoAblumWithAscending:YES];
            NSLog(@"%@", self.pics);
            [self.collectionView reloadData];
        }
    }
    
    return self;
}

#pragma mark - 延迟加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        collectionView.backgroundColor = [UIColor clearColor];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerClass:[YHChoicePicViewCell class] forCellWithReuseIdentifier:CELL_ID];
        
//        collectionView.delegate = self
    }
    
    return _collectionView;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupFrames];
}

- (void)setupFrames
{
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YHChoicePicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - 获取相册内所有照片资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    __block NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        NSLog(@"%@", [self imageWithAss:asset]);
        
        
        [assets addObject:asset];
    }];
    
    
    return assets;
}

- (UIImage *)imageWithAss:(PHAsset *)asset
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
    
    CGSize size = CGSizeMake(100, 100);
    
    __block UIImage *img = nil;
    NSLog(@"---:  %@", [NSThread currentThread]);
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        //解析出来的图片
        img = image;
        NSLog(@"info ---:  %@", [NSThread currentThread]);
        
        
        
    }];
    
    return img;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    PHAsset *asset = self.pics[0];
    NSLog(@"%@", [self imageWithAss:asset]);
}
@end
