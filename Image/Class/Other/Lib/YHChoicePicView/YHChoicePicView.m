//
//  YHChoicePicView.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePicView.h"

#import "YHChoicePicViewCell.h"
//#import "YHChoicePicViewCellModel.m"

#define CELL_ID @"YHChoicePicViewCell_id"   // CELL 重用ID
//#define COLUMNS 4 // 显示的列数
//#define COLUMN_Padding 5 // 列间距
//#define ROW_Padding 5 // 行间距

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
        
       
    }
    
    return self;
}

#pragma mark - 延迟加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        CGFloat sizeW = (self.frame.size.width - (COLUMNS + 1) * COLUMN_Padding) / COLUMNS;
//        CGFloat sizeH = sizeW;
//        layout.itemSize = CGSizeMake(sizeW, sizeH);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        collectionView.backgroundColor = [UIColor clearColor];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerClass:[YHChoicePicViewCell class] forCellWithReuseIdentifier:CELL_ID];
        
    }
    
    return _collectionView;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupFrames];
    
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    CGFloat sizeW = (self.frame.size.width - (COLUMNS + 1) * COLUMN_Padding) / COLUMNS;
//    CGFloat sizeH = sizeW;
//    layout.itemSize = CGSizeMake(sizeW, sizeH);
////    layout.minimumLineSpacing = COLUMN_Padding;
//    
//    NSLog(@"%f -- %f", sizeW, self.frame.size.width);
//    
//    // 设置列的最小间距
//    layout.minimumInteritemSpacing = 10;
//    // 设置最小行间距
//    layout.minimumLineSpacing = 15;
//    // 设置布局的内边距
//    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
//    // 滚动方向
//    
//    [self.collectionView setCollectionViewLayout:layout animated:YES];
    
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
        [self showAllPicsWithAscending:YES];
    }
    
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
    
    YHChoicePicViewCellModel *model = self.pics[indexPath.item];
    cell.model = model;
    
    return cell;
}

#pragma mark -UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 200);
}

#pragma mark - 获取相册内所有照片资源
/** 加载所有的手机图片资源 */
- (void)getAllPicsWithAscending:(BOOL)ascending
{
    __block NSMutableArray<YHChoicePicViewCellModel *> *models = [NSMutableArray<YHChoicePicViewCellModel *> array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        
        
        [models addObject:[YHChoicePicViewCellModel modelWithAsset:asset]];
    }];
    self.pics = models;
//    PHCachingImageManager *manager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
//    
//    [manager startCachingImagesForAssets:self.pics
//                              targetSize:CGSizeMake(400, 400)
//                             contentMode:PHImageContentModeAspectFill
//                                 options:nil];
}

/** 显示所有图片资源 */
- (void)showAllPicsWithAscending:(BOOL)ascending
{
    [self getAllPicsWithAscending:ascending];
    [self.collectionView reloadData];
}


@end
